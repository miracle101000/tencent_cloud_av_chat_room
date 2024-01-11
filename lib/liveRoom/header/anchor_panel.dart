import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/user_avatar.dart';
import 'package:tencent_cloud_av_chat_room/model/anchor_info.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class AnchorPanel extends StatelessWidget {
  final AnchorInfo anchorInfo;
  final bool isSubScribe;
  final Function(BuildContext context)? onSubscribePress;

  const AnchorPanel(
      {Key? key,
      required this.anchorInfo,
      required this.isSubScribe,
      this.onSubscribePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = isSubScribe ? TIM_t("取消关注") : TIM_t("关注");
    final textColor =
        isSubScribe ? const Color(0xFF999999) : const Color(0xFFFF465D);
    final option1 = anchorInfo.fansNum;
    final option2 = anchorInfo.subscribeNum;
    return Container(
        padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60.w,
                ),
                Text(
                  anchorInfo.nickName,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
                ),
                SizedBox(
                  height: 8.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TIM_t_para("粉丝 {{option1}} |",
                              "粉丝 $option1 |")(
                          option1: option1),
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF999999),
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      TIM_t_para(" 关注 {{option2}}",
                              " 关注 $option2")(
                          option2: option2),
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF999999),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.w,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(
                    text,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  style: ButtonStyle(minimumSize:
                      MaterialStateProperty.resolveWith<Size>((_) {
                    return const Size(335, 52);
                  }), backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((_) {
                    return textColor;
                  }), shape:
                      MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28));
                  })),
                  onPressed: () {
                    if (onSubscribePress != null) {
                      onSubscribePress!(context);
                    }
                  },
                ),
              ],
            ),
            Positioned(
              top: -40,
              child: UserAvatar(
                width: 80,
                height: 80,
                url: anchorInfo.avatarUrl,
              ),
            ),
          ],
        ));
  }
}
