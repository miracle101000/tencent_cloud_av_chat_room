import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/text_input_field.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

enum Actions { gifts, thumbsUp }

final defaultAction = [
  TextFieldAction("images/text_field/gifts.png", Actions.gifts),
  TextFieldAction("images/text_field/thumbs_up.png", Actions.thumbsUp),
];

class TextFieldAction {
  TextFieldAction(this.icon, this.type);

  final String icon;
  final Actions type;
}

class MessageSendArea extends StatelessWidget {
  // const MessageSendArea(
  //     {super.key,
  //     required this.onSubmit,
  //     this.textFieldActionBuilder,
  //     required this.onActionTap,
  //     this.textFieldDecoratorBuilder,
  //     required this.config});
  final Function(String val) onSubmit;
  final Function(BuildContext context, Actions type) onActionTap;
  final List<Widget> Function(BuildContext context)? textFieldActionBuilder;
  final Widget Function(BuildContext context)? textFieldDecoratorBuilder;
  final TencentCloudAvChatRoomConfig config;

  const MessageSendArea(
      {Key? key,
      required this.onSubmit,
      required this.onActionTap,
      this.textFieldActionBuilder,
      this.textFieldDecoratorBuilder,
      required this.config})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: kIsWeb ? 10.w : ScreenUtil().bottomBarHeight),
      child: TextInputField(
        onSubmit: onSubmit,
        action: _action,
        decortaor: _decortaor,
        hintText: TIM_t("说点啥..."),
      ),
    );
  }

  Widget _decortaor(BuildContext context) {
    if (textFieldDecoratorBuilder != null) {
      return textFieldDecoratorBuilder!(context);
    }
    return RoundedContainer(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 10.w),
      child: Text(
        TIM_t("说点啥..."),
        style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14.sp),
      ),
    );
  }

  List<Widget> _action(BuildContext context) {
    if (textFieldActionBuilder != null) {
      return textFieldActionBuilder!(context);
    }
    return defaultAction.map((e) {
      if (e.type == Actions.gifts &&
          !config.displayConfig.showTextFieldGiftAction) {
        return Container();
      }
      if (e.type == Actions.thumbsUp &&
          !config.displayConfig.showTextFieldThumbsUpAction) {
        return Container();
      }
      return GestureDetector(
        onTap: () {
          onActionTap(context, e.type);
        },
        child: RoundedContainer(
          width: 44.w,
          height: 44.w,
          margin: EdgeInsets.only(right: 10.w),
          padding: EdgeInsets.zero,
          shape: BoxShape.circle,
          child: Center(
            child: Image.asset(
              e.icon,
              width: 23.w,
              height: 24.w,
              package: "tencent_cloud_av_chat_room",
            ),
          ),
        ),
      );
    }).toList();
  }
}
