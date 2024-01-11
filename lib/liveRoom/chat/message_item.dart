import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/gift.dart';
import 'package:tencent_cloud_av_chat_room/utils/live_kit_custom_string.dart';

class MessageItem extends StatelessWidget {
  // const MessageItem(
  //     {super.key, required this.message, required this.messagePrefix});
  final V2TimMessage message;
  final Widget messagePrefix;

  const MessageItem(
      {Key? key, required this.message, required this.messagePrefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uesrName = _getMessageDisplayName(message);
    var textMessageString = message.textElem?.text ?? "";
    var giftUrl = "";
    final isGiftMessage = Gift.isGiftMessage(message);
    final isThumbsUpMessage = LiveKitCustomString.isLiveKitCloudCustomData(
            message.customElem?.data) &&
        LiveKitCustomString.getCmd(message.customElem!.data!) == "thumbs_up";
    if (isGiftMessage) {
      final giftData = Gift.getGiftData(message);
      final giftCmdInfo = giftData.data.cmdInfo as Map;
      final giftName = TIM_t(giftCmdInfo['giftName']);
      final giftCount = giftCmdInfo['giftCount'];
      giftUrl = giftCmdInfo['giftUrl'];
      final giftUnits = TIM_t(giftCmdInfo['giftUnits']);
      final option1 = "$giftCount$giftUnits$giftName";
      textMessageString =
          TIM_t_para("送出{{option1}}", "送出$option1")(option1: option1);
    }

    if (isThumbsUpMessage) {
      textMessageString = TIM_t("赞了直播间");
    }

    return Container(
      margin: EdgeInsets.only(bottom: 4.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints(maxWidth: 0.8.sw),
          child: RoundedContainer(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.w),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.w),
                bottomLeft: Radius.circular(20.w),
                bottomRight: Radius.circular(20.w),
                topRight: Radius.circular(20.w)),
            child: RichText(
                text: TextSpan(children: [
              WidgetSpan(
                child: messagePrefix,
              ),
              if (uesrName.isNotEmpty)
                TextSpan(
                    text: "$uesrName: ",
                    style: Theme.of(context).textTheme.bodyText1),
              TextSpan(
                  text: textMessageString,
                  style: Theme.of(context).textTheme.bodyText2),
              if (giftUrl.isNotEmpty)
                WidgetSpan(
                    child: Image.network(
                  "https://qcloudimg.tencent-cloud.cn/raw/$giftUrl",
                  width: 20.w,
                  height: 20.w,
                )),
            ])),
          ),
        ),
      ),
    );
  }

  String _getMessageDisplayName(V2TimMessage message) {
    final friendRemark = message.friendRemark ?? "";
    final nameCard = message.nameCard ?? "";
    final nickName = message.nickName ?? "";
    final sender = message.sender ?? "";
    final displayName = friendRemark.isNotEmpty
        ? friendRemark
        : nameCard.isNotEmpty
            ? nameCard
            : nickName.isNotEmpty
                ? nickName
                : sender;
    return displayName.toString();
  }
}

class InitialMessage extends StatelessWidget {
  // const InitialMessage({super.key, required this.text});

  final String text;

  const InitialMessage({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints(maxWidth: 0.8.sw),
          child: RoundedContainer(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.w),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.w),
                bottomLeft: Radius.circular(20.w),
                bottomRight: Radius.circular(20.w),
                topRight: Radius.circular(20.w)),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ),
    );
  }
}
