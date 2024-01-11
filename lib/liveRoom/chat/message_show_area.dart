import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/barrage.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/gift_special_effect_player.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/gift.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/message_prefix.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/user_enter_animation.dart';
import 'package:tencent_cloud_av_chat_room/model/user_enter.dart';

enum ACTION_TYPE { normal, sendMessage, sendGiftMessage, sendThumbsUpMessage }

class MessageController extends ChangeNotifier {
  ACTION_TYPE actionType = ACTION_TYPE.normal;
  V2TimMessage? sendingMessage;
  late String reciver;

  /// send message.
  sendMessage(
    V2TimMessage message,
    String groupID, {
    ACTION_TYPE type = ACTION_TYPE.sendMessage,
  }) {
    reciver = groupID;
    actionType = type;
    sendingMessage = message;
    notifyListeners();
  }

  /// send text message.
  sendTextMessage(String val, String groupID) async {
    final tmpTextMessage = await _createTextMessage(val);
    if (tmpTextMessage != null) {
      sendMessage(tmpTextMessage, groupID);
    }
  }

  /// send gift message.
  sendGiftMessage(String data, String groupID) async {
    final tmpGiftMessage = await _createCustomMessage(data);
    if (tmpGiftMessage != null) {
      sendMessage(tmpGiftMessage, groupID, type: ACTION_TYPE.sendGiftMessage);
    }
  }

  /// send custom message
  sendThumbsUpMessage(String data, String groupID) async {
    final tmpGiftMessage = await _createCustomMessage(data);
    if (tmpGiftMessage != null) {
      sendMessage(tmpGiftMessage, groupID,
          type: ACTION_TYPE.sendThumbsUpMessage);
    }
  }

  Future<V2TimMessage?> _createTextMessage(String val) async {
    final textMessageInfo = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(text: val);
    final messageInfo = textMessageInfo.data?.messageInfo;
    if (messageInfo != null) {
      messageInfo.isSelf = true;
    }
    return messageInfo;
  }

  Future<V2TimMessage?> _createCustomMessage(String data) async {
    final giftMessageInfo = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(data: data);
    final messageInfo = giftMessageInfo.data?.messageInfo;
    if (messageInfo != null) {
      messageInfo.isSelf = true;
    }
    return messageInfo;
  }
}

class MessageShowArea extends StatefulWidget {
  /// [MessageShowArea] controller, use for send message outside of widget.
  final MessageController conroller;

  /// group ID of AVChatRoom type. use for send and show message. official docs [https://cloud.tencent.com/document/product/269/75697].
  final String avChatRoomID;

  /// message item builder.
  final Widget Function(
          BuildContext context, V2TimMessage message, Widget child)?
      messageItemBuilder;

  /// gift message item builder.
  final Widget Function(BuildContext context, V2TimMessage message)?
      giftMessageBuilder;

  /// message item prefix builder.
  final Widget Function(BuildContext context, V2TimMessage message)?
      messageItemPrefixBuilder;

  /// Gift special effect player.
  final GiftSpecialEffectPlayerController giftSpecialEffectPlayerController;

  /// initial message
  final V2TimMessage? initialMessage;

  final TencentCloudAvChatRoomConfig config;

  final int? barrageCacheCount;

  const MessageShowArea(
      {Key? key,
      required this.conroller,
      required this.avChatRoomID,
      this.messageItemBuilder,
      this.giftMessageBuilder,
      this.messageItemPrefixBuilder,
      required this.giftSpecialEffectPlayerController,
      this.initialMessage,
      required this.config,
      this.barrageCacheCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageAreaState();
}

class _MessageAreaState extends State<MessageShowArea> {
  final V2TIMManager _timManager = TencentImSDKPlugin.v2TIMManager;
  late V2TimGroupListener _groupListener;
  final List<UserEnter> _userEnterList = [];
  final GlobalKey<BarrageState> _barrageStateKey = GlobalKey();
  final GlobalKey<GiftsState> _giftsKey = GlobalKey();
  V2TimUserFullInfo? _loginUserInfo;
  Future<V2TimUserFullInfo?>? _currentUserEnter;
  // 礼物并行展示数量
  int concurrenceGiftCount = 2;

  @override
  void initState() {
    super.initState();
    // get login user info, use for send message.
    _getLoginUserInfo();
    // add controller
    widget.conroller.addListener(_controllerHandler);

    // add message listener & group listener, recive message & subscribe user enter room
    _initGroupListener();
  }

  @override
  void dispose() {
    super.dispose();
    widget.conroller.dispose();
    _timManager.removeGroupListener(listener: _groupListener);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      concurrenceGiftCount = 1;
    } else {
      concurrenceGiftCount = 2;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gifts(
            key: _giftsKey,
            avChatRoomID: widget.avChatRoomID,
            barrageStateKey: _barrageStateKey,
            giftMessageBuilder: widget.giftMessageBuilder,
            concurrenceGiftCount: concurrenceGiftCount,
            giftHttpBase: widget.config.giftHttpBase ?? "",
            giftSpecialEffectPlayerController:
                widget.giftSpecialEffectPlayerController),
        SizedBox(
          height: 4.w,
        ),
        SizedBox(
          height: 37.w,
          child: _userEnterSlideWidget(),
        ),
        Barrage(
          key: _barrageStateKey,
          initialMessage: widget.initialMessage,
          barrageItemBuilder: widget.messageItemBuilder,
          barrageItemPrefix: widget.messageItemPrefixBuilder,
          avChatRoomID: widget.avChatRoomID,
          cacheCount: widget.barrageCacheCount,
        )
      ],
    );
  }

  _initGroupListener() {
    _groupListener = V2TimGroupListener(
      onMemberEnter: (groupID, memberList) {
        if (widget.avChatRoomID == groupID) {
          final userEnterList = List<UserEnter>.empty(growable: true);
          for (var item in memberList) {
            final timeStamp = DateTime.now().millisecondsSinceEpoch;
            userEnterList.add(UserEnter(timeStamp, item));
          }
          final haveAnimationRunning = _userEnterList.isNotEmpty;
          _userEnterList.addAll(userEnterList);
          if (!haveAnimationRunning) {
            _currentUserEnter = _getUserInfo();
            setState(() {});
          }
        }
      },
    );
    _timManager.addGroupListener(listener: _groupListener);
  }

  _controllerHandler() {
    final actionType = widget.conroller.actionType;
    final sendingMessage = widget.conroller.sendingMessage;
    switch (actionType) {
      case ACTION_TYPE.sendMessage:
        sendingMessage?.userID = _loginUserInfo?.userID;
        sendingMessage?.nickName = _loginUserInfo?.nickName;
        sendingMessage?.cloudCustomData = _getUserLevelString();
        if (sendingMessage != null) {
          _barrageStateKey.currentState
              ?.insertBarrageItemAndScroll(sendingMessage);
        }
        break;
      case ACTION_TYPE.sendGiftMessage:
        sendingMessage?.userID = _loginUserInfo?.userID;
        sendingMessage?.nickName = _loginUserInfo?.nickName;
        sendingMessage?.faceUrl = _loginUserInfo?.faceUrl;
        sendingMessage?.cloudCustomData = _getUserLevelString();
        if (sendingMessage != null) {
          final isGiftMessage = Gift.isGiftMessage(sendingMessage);
          if (isGiftMessage) {
            _giftsKey.currentState?.handleGiftMessage(sendingMessage);
          } else {
            throw Exception('Invalid gift message');
          }
        }
        break;
      case ACTION_TYPE.sendThumbsUpMessage:
        sendingMessage?.userID = _loginUserInfo?.userID;
        sendingMessage?.nickName = _loginUserInfo?.nickName;
        sendingMessage?.faceUrl = _loginUserInfo?.faceUrl;
        sendingMessage?.cloudCustomData = _getUserLevelString();
        if (sendingMessage != null) {
          _barrageStateKey.currentState
              ?.insertBarrageItemAndScroll(sendingMessage);
        }
        break;
      default:
    }

    if (sendingMessage != null) {
      _sendMessage(sendingMessage, actionType);
    }
  }

  String _getUserLevelString() {
    final userCustomString = _loginUserInfo?.customInfo;
    if (userCustomString != null &&
        userCustomString.isNotEmpty &&
        userCustomString.containsKey("level")) {
      return jsonEncode({
        "version": 1.0, // 协议版本号
        "businessID": "flutter_live_kit", // 业务标识字段
        "data": {
          "cmd":
              "userLevel", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数,  userLevel: 用户等级
          "cmdInfo": {
            "level": userCustomString["level"],
            "color": [60, 207, 165, 1],
          }, // 本次指令的额外信息
        }
      });
    } else {
      return "";
    }
  }

  _sendMessage(V2TimMessage message, ACTION_TYPE type) {
    MessagePriorityEnum priority = MessagePriorityEnum.V2TIM_PRIORITY_NORMAL;
    if (type == ACTION_TYPE.sendGiftMessage) {
      priority = MessagePriorityEnum.V2TIM_PRIORITY_HIGH;
    }
    if (type == ACTION_TYPE.sendThumbsUpMessage) {
      priority = MessagePriorityEnum.V2TIM_PRIORITY_LOW;
    }
    TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
        id: message.id!,
        receiver: "",
        groupID: widget.avChatRoomID,
        priority: priority,
        cloudCustomData: message.cloudCustomData);
  }

  static String? _getMemberNickName(V2TimGroupMemberInfo e) {
    final friendRemark = e.friendRemark;
    final nameCard = e.nameCard;
    final nickName = e.nickName;
    final userID = e.userID;

    if (friendRemark != null && friendRemark != "") {
      return friendRemark;
    } else if (nameCard != null && nameCard != "") {
      return nameCard;
    } else if (nickName != null && nickName != "") {
      return nickName;
    } else {
      return userID;
    }
  }

  Widget _userEnterSlideWidget() {
    if (_userEnterList.isEmpty) {
      return Container();
    }
    return FutureBuilder<V2TimUserFullInfo?>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final userMemberInfo = snapshot.data;
          if (userMemberInfo != null) {
            final customString = userMemberInfo.customInfo;
            final displayName =
                _getMemberNickName(_userEnterList.first.userInfo);
            if (customString != null &&
                customString.isNotEmpty &&
                customString.containsKey("level")) {
              final level = int.parse(customString["level"] as String);
              final userColor = PrefixColorUtils.getColor(level);
              return UserEnterSlideAnimation(
                  child: UserEnterBanner(
                    displayName: displayName ?? "",
                    level: level,
                    backgroundColor: userColor,
                  ),
                  onEnd: () {
                    _userEnterList.removeAt(0);
                    if (_userEnterList.isNotEmpty) {
                      _currentUserEnter = _getUserInfo();
                      setState(() {});
                    }
                  });
            }
            return UserEnterSlideAnimation(
                child: UserEnterBanner(
                  displayName: displayName ?? "",
                  level: null,
                  backgroundColor: null,
                ),
                onEnd: () {
                  _userEnterList.removeAt(0);
                  if (_userEnterList.isNotEmpty) {
                    _currentUserEnter = _getUserInfo();
                    setState(() {});
                  }
                });
          }
        }
        return Container();
      },
      future: _currentUserEnter,
    );
  }

  Future<V2TimUserFullInfo?> _getUserInfo() async {
    final firstEnter = _userEnterList.first;
    if (firstEnter.userInfo.userID != null) {
      final userInfoResponse = await TencentImSDKPlugin.v2TIMManager
          .getUsersInfo(userIDList: [firstEnter.userInfo.userID!]);
      if (userInfoResponse.code == 0) {
        final userMemberInfo = userInfoResponse.data!.first;
        return userMemberInfo;
      }
    }
    return null;
  }

  _getLoginUserInfo() async {
    final loginData = await TencentImSDKPlugin.v2TIMManager.getLoginUser();
    if (loginData.code == 0) {
      final loginUserId = loginData.data;
      final loginUserInfoResponse = await TencentImSDKPlugin.v2TIMManager
          .getUsersInfo(userIDList: [loginUserId!]);
      if (loginUserInfoResponse.data != null) {
        _loginUserInfo = loginUserInfoResponse.data!.first;
      }
    }
  }
}
