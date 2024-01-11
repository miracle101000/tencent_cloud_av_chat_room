import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/user_avatar.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_theme.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class AnchorProfile extends StatelessWidget {
  /// anchor face url;
  final String faceUrl;

  /// anchor nick name
  final String nickName;

  /// anchor is subscribe
  final bool isSubscribe;

  /// anchor sub info;
  final Widget? subInfo;

  /// show default subscribe action;
  final bool isShowDefaultAction;

  /// on tap avatar;
  final void Function()? onAvatarTap;

  /// on tap subscribe;
  final void Function()? onSubscribeTap;

  /// customize action, if set action, [isSubscribe]，[isShowDefaultAction] will not work.
  final Widget? action;

  const AnchorProfile(
      {Key? key,
      required this.faceUrl,
      required this.nickName,
      this.isSubscribe = false,
      this.subInfo,
      this.isShowDefaultAction = true,
      this.onAvatarTap,
      this.onSubscribeTap,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      borderRadius: BorderRadius.circular(33.w),
      padding: EdgeInsets.all(2.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: UserAvatar(
              url: faceUrl,
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 80.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickName,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subInfo ?? Container(),
              ],
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          if (action != null)
            action!
          else if (isShowDefaultAction)
            if (!isSubscribe)
              GestureDetector(
                onTap: onSubscribeTap,
                child: RoundedContainer(
                  borderRadius: BorderRadius.circular(48.w),
                  color: Theme.of(context).colorScheme.accentColor,
                  padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 6.w),
                  child: Text(
                    TIM_t("关注"),
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
