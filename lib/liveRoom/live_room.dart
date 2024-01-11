import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/gift_special_effect_player.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/live_room_chat.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/message_show_area.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/header/live_room_header.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/store/live_room_store.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_callback.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_controller.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_custom_widget.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class LiveRoom extends StatefulWidget {
  final TencentCloudAvChatRoomConfig config;
  final TencentCloudAvChatRoomData data;
  final TencentCloudAvChatRoomController? controller;
  final TencentCloudAvChatRoomCustomWidgets? customWidgets;
  final TencentCloudAvChatRoomCallback? callback;

  const LiveRoom(
      {Key? key,
      required this.config,
      required this.data,
      this.controller,
      this.customWidgets,
      this.callback})
      : super(key: key);

  @override
  State<LiveRoom> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoom> {
  final GiftSpecialEffectPlayerController _giftSpecialEffectPlayerController =
      GiftSpecialEffectPlayerController();
  final MessageController _messageController = MessageController();
  TencentCloudAvChatRoomController? _tencentLiveKitController;
  late V2TimAdvancedMsgListener _messageListener;
  late V2TimGroupListener _groupListener;

  @override
  void initState() {
    super.initState();
    _observerListener();
    _initMessageListener();
    _initGroupListener();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (widget.controller != null &&
        widget.controller != _tencentLiveKitController) {
      _tencentLiveKitController!.removeListener(_controllerHandler);
      _observerListener();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_tencentLiveKitController != null) {
      _tencentLiveKitController!.removeListener(_controllerHandler);
    }
    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .removeAdvancedMsgListener(listener: _messageListener);
    TencentImSDKPlugin.v2TIMManager
        .removeGroupListener(listener: _groupListener);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        LiveRoomContainer(
          config: widget.config,
          customWidgets: widget.customWidgets,
          giftSpecialEffectPlayerController: _giftSpecialEffectPlayerController,
          messageController: _messageController,
        ),
        GiftSpecialEffectPlayer(
          controller: _giftSpecialEffectPlayerController,
        ),
      ],
    );
  }

  _initMessageListener() {
    _messageListener = V2TimAdvancedMsgListener(
      onRecvNewMessage: (msg) {
        if (widget.callback != null) {
          if (widget.callback!.onRecvNewMessage != null) {
            widget.callback!.onRecvNewMessage!(msg);
          }
        }
      },
    );

    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .addAdvancedMsgListener(listener: _messageListener);
  }

  _initGroupListener() {
    _groupListener = V2TimGroupListener(
      onMemberEnter: (groupID, memberList) {
        if (widget.config.avChatRoomID == groupID) {
          if (widget.callback != null) {
            if (widget.callback!.onMemberEnter != null) {
              widget.callback!.onMemberEnter!(memberList);
            }
          }
        }
      },
    );
    TencentImSDKPlugin.v2TIMManager.addGroupListener(listener: _groupListener);
  }

  _observerListener() {
    _tencentLiveKitController = widget.controller;
    if (_tencentLiveKitController != null) {
      _tencentLiveKitController!.addListener(_controllerHandler);
    }
  }

  _controllerHandler() {
    final actionType = _tencentLiveKitController!.actionType;
    final roomID = widget.config.avChatRoomID;
    switch (actionType) {
      case TencentCloudAvChatRoomControllerActionType.updateData:
        final liveKitData = _tencentLiveKitController?.liveKitData;
        if (liveKitData != null) {
          final liveRoomStoreState = LiveRoomStore.of(context, rebuild: false);
          liveRoomStoreState.updateLiveKitData(liveKitData);
        }
        break;
      case TencentCloudAvChatRoomControllerActionType.sendGiftMessage:
        final giftData = _tencentLiveKitController?.giftData;
        if (giftData != null) {
          _messageController.sendGiftMessage(giftData, roomID);
        }
        break;
      case TencentCloudAvChatRoomControllerActionType.sendMessage:
        final message = _tencentLiveKitController?.message;
        if (message != null) {
          _messageController.sendMessage(message, roomID);
        }
        break;
      case TencentCloudAvChatRoomControllerActionType.sendTextMessage:
        final textString = _tencentLiveKitController?.textString;
        if (textString != null) {
          _messageController.sendTextMessage(textString, roomID);
        }
        break;
      case TencentCloudAvChatRoomControllerActionType.playAnimation:
        final animationUrl = _tencentLiveKitController?.animationUrl;
        if (animationUrl != null && animationUrl.isNotEmpty) {
          _giftSpecialEffectPlayerController.play(url: animationUrl);
        }
        break;
      default:
    }
  }
}

class LiveRoomContainer extends StatefulWidget {
  final TencentCloudAvChatRoomConfig config;
  final GiftSpecialEffectPlayerController giftSpecialEffectPlayerController;
  final TencentCloudAvChatRoomCustomWidgets? customWidgets;
  final MessageController messageController;

  const LiveRoomContainer(
      {Key? key,
      required this.config,
      required this.giftSpecialEffectPlayerController,
      this.customWidgets,
      required this.messageController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveRoomContainerState();
}

class _LiveRoomContainerState extends State<LiveRoomContainer> {
  bool isJoinedGroupSuccess = false;
  bool isKeyBoardShow = false;
  String avChatRoomID = "";
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    joinGroup();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyBoardShow = visible;
      setState(() {});
    });
  }

  @override
  void dispose() {
    quitGroup();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveKitData = LiveRoomStore.of(context).data;
    avChatRoomID = widget.config.avChatRoomID;
    if (!isJoinedGroupSuccess) {
      return Container();
    }
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
                child: AnimatedOpacity(
              opacity: isKeyBoardShow ? 0.0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.only(left: 16.w),
                child: LiveRoomHeader(
                  config: widget.config,
                  data: liveKitData,
                  action: widget.customWidgets?.roomHeaderAction,
                  leading: widget.customWidgets?.roomHeaderLeading,
                  tag: widget.customWidgets?.roomHeaderTag,
                  anchorInfoPanelBuilder:
                      widget.customWidgets?.anchorInfoPanelBuilder,
                  onlineMemberListPanelBuilder:
                      widget.customWidgets?.onlineMemberListPanelBuilder,
                ),
              ),
            )),
            LiveRoomChat(
              config: widget.config,
              notification: liveKitData.notification ?? "",
              avChatRoomID: widget.config.avChatRoomID,
              isKeyBoardOpened: isKeyBoardShow,
              giftSpecialEffectPlayerController:
                  widget.giftSpecialEffectPlayerController,
              customWidgets: widget.customWidgets,
              messageController: widget.messageController,
            )
          ],
        ),
      ),
    );
  }

  void joinGroup() async {
    final response = await TencentImSDKPlugin.v2TIMManager
        .joinGroup(groupID: widget.config.avChatRoomID, message: "hello");
    if (response.code == 0) {
      setState(() {
        isJoinedGroupSuccess = true;
      });
    }
  }

  quitGroup() async {
    TencentImSDKPlugin.v2TIMManager.quitGroup(groupID: avChatRoomID);
  }
}
