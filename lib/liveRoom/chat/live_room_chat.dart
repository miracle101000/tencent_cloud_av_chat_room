import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/gift_special_effect_player.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/gift.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/message_send_area.dart'
    as messageSendArea;
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/message_show_area.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/store/live_room_store.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_custom_widget.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class LiveRoomChat extends StatelessWidget {
  // const LiveRoomChat(
  //     {super.key,
  //     required this.messageConfig,
  //     required this.avChatRoomID,
  //     required this.isKeyBoardOpened,
  //     required this.giftSpecialEffectPlayerController,
  //     required this.notification,
  //     this.customWidgets,
  //     required this.messageController,
  //     required this.config});
  final String avChatRoomID;
  final String notification;
  final bool isKeyBoardOpened;
  final GiftSpecialEffectPlayerController giftSpecialEffectPlayerController;
  final TencentCloudAvChatRoomCustomWidgets? customWidgets;
  final MessageController messageController;
  final TencentCloudAvChatRoomConfig config;

  const LiveRoomChat({
    Key? key,
    required this.avChatRoomID,
    required this.notification,
    required this.isKeyBoardOpened,
    required this.giftSpecialEffectPlayerController,
    this.customWidgets,
    required this.messageController,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Column(
      children: [
        SizedBox(
          height: (isKeyBoardOpened && orientation == Orientation.landscape)
              ? 0
              : null,
          child: MessageShowArea(
            config: config,
            conroller: messageController,
            avChatRoomID: avChatRoomID,
            messageItemBuilder: customWidgets?.messageItemBuilder,
            giftMessageBuilder: customWidgets?.giftMessageBuilder,
            messageItemPrefixBuilder: customWidgets?.messageItemPrefixBuilder,
            giftSpecialEffectPlayerController:
                giftSpecialEffectPlayerController,
            barrageCacheCount: config.barrageMaxCount,
            initialMessage: notification.isNotEmpty
                ? V2TimMessage(
                    elemType: 11, textElem: V2TimTextElem(text: notification))
                : null,
          ),
        ),
        SizedBox(
          height: 10.w,
        ),
        messageSendArea.MessageSendArea(
          onActionTap: onActionTap,
          config: config,
          onSubmit: submitMessage,
          textFieldActionBuilder: customWidgets?.textFieldActionBuilder,
          textFieldDecoratorBuilder: customWidgets?.textFieldDecoratorBuilder,
        )
      ],
    );
  }

  submitMessage(String val) {
    if (val.isEmpty) {
      return;
    }
    messageController.sendTextMessage(val, avChatRoomID);
  }

  onActionTap(BuildContext context, messageSendArea.Actions type) {
    switch (type) {
      case messageSendArea.Actions.gifts:
        showMaterialModalBottomSheet(
            context: context,
            expand: false,
            backgroundColor: Colors.black.withOpacity(0.8),
            barrierColor: Colors.white.withOpacity(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.w),
                    topRight: Radius.circular(20.w))),
            builder: (c) {
              if (customWidgets?.giftsPanelBuilder != null) {
                return customWidgets!.giftsPanelBuilder!(c);
              }
              return GiftPanel(onTap: (item) => sendGiftMessage(item, c));
            });
        break;
      case messageSendArea.Actions.thumbsUp:
        sendThumbsupMessage(context);
        break;
      default:
    }
  }

  sendThumbsupMessage(BuildContext c) async {
    final customInfo = {
      "version": 1.0, // 协议版本号
      "businessID": "flutter_live_kit", // 业务标识字段
      "data": {
        "cmd":
            "thumbs_up", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
      }
    };
    messageController.sendThumbsUpMessage(jsonEncode(customInfo), avChatRoomID);
    final liveRoomStoreState = LiveRoomStore.of(c, rebuild: false);
    liveRoomStoreState.increaseThumbsUpCount();
    TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .increaseGroupCounter(groupID: avChatRoomID, key: "hot", value: 1);
  }

  sendGiftMessage(GiftItem item, BuildContext context) {
    final customInfo = {
      "version": 1.0, // 协议版本号
      "businessID": "flutter_live_kit", // 业务标识字段
      "data": {
        "cmd":
            "send_gift_message", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
        "cmdInfo": {
          "type": item.type, // 1: 普通礼物， 2: 礼物不带特效, 3: 礼物带特效 [必填]
          "giftUrl": item.giftUrl, // 礼物图片地址 [必填]
          "giftCount": 1, // 礼物数量 [必填]
          "giftSEUrl": item.seUrl, // 礼物特效地址 [可选]
          "giftName": item.name,
          "giftUnits": TIM_t("朵"), // 礼物单位
        }, // 本次指令的额外信息
      }
    };
    messageController.sendGiftMessage(jsonEncode(customInfo), avChatRoomID);
    Navigator.pop(context);
  }
}
