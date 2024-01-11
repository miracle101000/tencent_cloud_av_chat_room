import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/gift_special_effect_player.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/barrage.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/user_avatar.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/task_queue.dart';
import 'package:tencent_cloud_av_chat_room/model/gift_message.dart';

final defaultGifts = [
  GiftItem("images/text_field/gift_rocket.png", TIM_t("火箭"), 3,
      "assets/rocket.json", "1e8913f8c6d804972887fc179fa1fbd7.png"),
  GiftItem("images/text_field/gift_plane.png", TIM_t("飞机"), 2,
      "assets/rockets.svga", "5e175b792cd652016aa87327b278402b.png"),
  GiftItem("images/text_field/gift_plane.png", TIM_t("皇冠"), 3,
      "assets/kingset.svga", "5e175b792cd652016aa87327b278402b.png"),
  GiftItem("images/text_field/gift_flower.png", TIM_t("花"), 1, "",
      "8f25a2cdeae92538b1e0e8a04f86841a.png"),
];

class GiftItem {
  GiftItem(this.icon, this.name, this.type, this.seUrl, this.giftUrl);
  final String name;
  final String icon;
  final String seUrl;
  final String giftUrl;
  final int type;
}

class Gift {
  static List<V2TimMessage> giftQueue = [];
  static TaskQueue queue = TaskQueue(concurrenceCount: 2);

  static add(V2TimMessage msg, int removeTime, Function cb) {
    queue.addTask(() async {
      giftQueue.add(msg);
      cb();
      await Future.delayed(Duration(milliseconds: removeTime));
      giftQueue.removeWhere((element) => element == msg);
      cb();
    });
  }

  static bool isGiftMessage(V2TimMessage message) {
    final bool isCustomMessage =
        message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM;
    if (isCustomMessage) {
      final customElem = message.customElem;
      try {
        final Map customData = jsonDecode(customElem?.data ?? "");
        final isIncludeBusinessID = customData.containsKey("businessID");
        final isIncludeData = customData.containsKey("data");
        if (isIncludeBusinessID && isIncludeData) {
          final isLiveKitGiftMessage =
              customData["businessID"] == "flutter_live_kit";
          final Map giftData = customData["data"];
          final isIncludeCmd = giftData.containsKey("cmd");
          final isIncludeCmdInfo = giftData.containsKey("cmdInfo");
          final isMap = giftData['cmdInfo'] is Map;
          return isLiveKitGiftMessage &&
              isIncludeCmd &&
              isIncludeCmdInfo &&
              isMap &&
              (giftData['cmdInfo'] as Map).containsKey('type') &&
              giftData["cmd"] == "send_gift_message";
        }
        return false;
      } catch (error) {
        return false;
      }
    } else {
      return false;
    }
  }

  static LiveKitCustomMessagee getGiftData(V2TimMessage message) {
    final customElem = message.customElem;
    final Map<String, dynamic> customData = jsonDecode(customElem?.data ?? "");
    return LiveKitCustomMessagee.fromJson(customData);
  }
}

class GiftSlideAnimation extends StatefulWidget {
  // const GiftSlideAnimation({
  //   super.key,
  //   required this.child,
  //   required this.onEnd,
  // });
  final Widget child;
  final Function onEnd;

  const GiftSlideAnimation({Key? key, required this.child, required this.onEnd})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GiftSlideAnimationState();
}

class _GiftSlideAnimationState extends State<GiftSlideAnimation>
    with SingleTickerProviderStateMixin {
  Duration startAnimationDuraion = const Duration(milliseconds: 1000);
  Duration endAnimationDuraion = const Duration(milliseconds: 800);
  double startPos = -1.0;
  double endPos = 0.0;
  bool isStart = true;
  Curve curve = Curves.easeIn;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(startPos, 0), end: Offset(endPos, 0)),
      duration: isStart ? startAnimationDuraion : endAnimationDuraion,
      curve: curve,
      builder: (BuildContext context, Offset offset, Widget? child) {
        if (isStart) {
          return FractionalTranslation(
            translation: offset,
            child: child,
          );
        }
        return Opacity(
          opacity: offset.dx + 1,
          child: child,
        );
      },
      child: widget.child,
      onEnd: () {
        if (!isStart) {
          widget.onEnd();
        }
        Future.delayed(
          const Duration(milliseconds: 1000),
          () {
            curve = curve == Curves.easeIn ? Curves.easeOut : Curves.easeIn;
            if (startPos == -1) {
              setState(() {
                isStart = false;
                startPos = 0.0;
                endPos = -1.0;
              });
            }
          },
        );
      },
    );
  }
}

class GiftBanner extends StatelessWidget {
  // const GiftBanner({super.key, required this.message, required this.httpBase});
  final V2TimMessage message;
  final String httpBase;

  const GiftBanner({Key? key, required this.message, required this.httpBase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final faceUrl = message.faceUrl;
    final userNickName = message.nickName ?? message.userID ?? "";
    final giftData = jsonDecode(message.customElem!.data!)["data"]["cmdInfo"];
    final giftName = TIM_t(giftData["giftName"]);
    final giftUrl = giftData["giftUrl"];
    final giftCount = giftData["giftCount"];
    final option1 = giftName;
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RoundedContainer(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatar(
                url: faceUrl,
                width: 34.w,
                height: 34.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userNickName,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  Text(
                    TIM_t_para("送出{{option1}}", "送出$option1")(
                        option1: option1),
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                ],
              ),
              SizedBox(
                width: 8.w,
              ),
              Image.network(
                "$httpBase$giftUrl",
                width: 34.w,
                height: 34.w,
              )
            ],
          )),
          SizedBox(
            width: 5.w,
          ),
          Text(
            "X",
            style: TextStyle(
                color: Theme.of(context).textTheme.headline5?.color,
                fontSize: 20.sp,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 5.w,
          ),
          AnimatedDefaultTextStyle(
            curve: Curves.easeIn,
            style: TextStyle(
                fontSize: 35.sp,
                color: Theme.of(context).textTheme.headline5?.color,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            duration: const Duration(milliseconds: 200),
            child: Text(giftCount.toString()),
          )
        ],
      ),
    );
  }
}

class GiftPanel extends StatelessWidget {
  // const GiftPanel({super.key, required this.onTap});
  final Function(GiftItem item) onTap;

  const GiftPanel({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.w,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TIM_t("送礼物"),
            style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20.w,
          ),
          Wrap(
            spacing: 20.w,
            children: defaultGifts
                .map((e) => GestureDetector(
                      onTap: () {
                        onTap(e);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 52.w,
                            height: 52.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                      e.icon,
                                      package: "tencent_cloud_av_chat_room",
                                    )),
                                color: Colors.black.withOpacity(0.3)),
                          ),
                          SizedBox(
                            height: 4.w,
                          ),
                          Text(
                            e.name,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.merge(TextStyle(fontSize: 14.sp)),
                          )
                        ],
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}

class Gifts extends StatefulWidget {
  const Gifts(
      {Key? key,
      required this.avChatRoomID,
      this.concurrenceGiftCount = 2,
      required this.barrageStateKey,
      required this.giftSpecialEffectPlayerController,
      this.giftMessageBuilder,
      this.giftHttpBase = ""})
      : super(key: key);

  final String avChatRoomID;
  final int concurrenceGiftCount;
  final GiftSpecialEffectPlayerController giftSpecialEffectPlayerController;
  final GlobalKey<BarrageState> barrageStateKey;
  final Widget Function(BuildContext context, V2TimMessage message)?
      giftMessageBuilder;
  final String giftHttpBase;

  @override
  State<StatefulWidget> createState() => GiftsState();
}

class GiftsState extends State<Gifts> {
  late V2TimAdvancedMsgListener _messageListener;
  final List<V2TimMessage> _giftTaskList = [];
  final List<V2TimMessage?> _animationList = [];

  @override
  void initState() {
    super.initState();
    _initMessageListener();
  }

  @override
  void dispose() {
    super.dispose();
    _removeMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    final animation1 = _animationList.length == 2 ? _animationList[1] : null;
    final animation2 = _animationList.isNotEmpty ? _animationList[0] : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16.w),
          child: animation1 == null
              ? Container()
              : GiftSlideAnimation(
                  key: ValueKey(_getMessageIdentifier(animation1)),
                  child: _getGiftMessageBuilder(animation1),
                  onEnd: () {
                    _onEnd(1);
                  },
                ),
        ),
        SizedBox(
          height: 4.w,
        ),
        Container(
          margin: EdgeInsets.only(left: 16.w),
          child: animation2 == null
              ? Container()
              : GiftSlideAnimation(
                  key: ValueKey(_getMessageIdentifier(animation2)),
                  child: _getGiftMessageBuilder(animation2),
                  onEnd: () {
                    _onEnd(0);
                  },
                ),
        )
      ],
    );
  }

  _initMessageListener() {
    _messageListener = V2TimAdvancedMsgListener(
      onRecvNewMessage: (msg) {
        if (msg.groupID == widget.avChatRoomID) {
          final isGiftMessage = Gift.isGiftMessage(msg);
          if (isGiftMessage) {
            handleGiftMessage(msg);
          }
        }
      },
    );

    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .addAdvancedMsgListener(listener: _messageListener);
  }

  handleGiftMessage(V2TimMessage msg) {
    final giftMessage = Gift.getGiftData(msg);
    final giftData = giftMessage.data.cmdInfo as Map;

    /// 1:普通礼物  2: 礼物不带特效 3: 礼物带特效
    final giftType = giftData['type'];

    /// 普通礼物不用队列展示
    if ([2, 3].contains(giftType)) {
      _giftTaskList.add(msg);
      final isRunning = _animationList
              .where(
                (element) => element != null,
              )
              .length ==
          widget.concurrenceGiftCount;
      if (!isRunning) {
        _doTask();
      }
    } else {
      /// 普通礼物会展示到弹幕列表中
      widget.barrageStateKey.currentState?.insertBarrageItem(msg);
    }
  }

  _doTask({int? index}) {
    if (_giftTaskList.isEmpty) {
      return;
    }

    final message = _getAvailablGifts();
    if (message == null) {
      return;
    }
    final giftData = Gift.getGiftData(message);
    final giftCmdInfo = giftData.data.cmdInfo as Map;
    final giftType = giftCmdInfo['type'];
    if (giftType == 3 && giftCmdInfo.containsKey("giftSEUrl")) {
      final giftSEUrl = giftCmdInfo['giftSEUrl'];
      widget.giftSpecialEffectPlayerController.play(url: giftSEUrl);
    }

    if (index != null) {
      _animationList[index] = message;
    } else {
      final index = _animationList.indexWhere((element) => element == null);
      if (index != -1) {
        _animationList[index] = message;
      } else {
        _animationList.add(message);
      }
    }
    setState(() {});
  }

  V2TimMessage? _getAvailablGifts({int defaultIndex = 0}) {
    int index = defaultIndex;
    if (index > _giftTaskList.length - 1) {
      return null;
    }
    final message = _giftTaskList[index];
    final giftData = Gift.getGiftData(message);
    final giftCmdInfo = giftData.data.cmdInfo as Map;
    final giftType = giftCmdInfo['type'];
    if (giftType == 3 && giftCmdInfo.containsKey("giftSEUrl")) {
      if (widget.giftSpecialEffectPlayerController.isPlaying) {
        return _getAvailablGifts(defaultIndex: index + 1);
      } else {
        _giftTaskList.removeAt(index);
        return message;
      }
    } else {
      _giftTaskList.removeAt(index);
      return message;
    }
  }

  _onEnd(int index) {
    _animationList[index] = null;
    _doTask(index: index);
  }

  _removeMessageListener() {
    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .removeAdvancedMsgListener(listener: _messageListener);
  }

  String _getMessageIdentifier(V2TimMessage? message) {
    return "${message?.msgID} - ${message?.timestamp} - ${message?.seq} - ${message?.id}";
  }

  Widget _getGiftMessageBuilder(V2TimMessage message) {
    if (widget.giftMessageBuilder != null) {
      return widget.giftMessageBuilder!(context, message);
    }
    return GiftBanner(
      message: message,
      httpBase: widget.giftHttpBase,
    );
  }
}
