import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class UserEnterSlideAnimation extends StatefulWidget {
  // const UserEnterSlideAnimation(
  //     {super.key, required this.child, required this.onEnd});

  final Widget child;
  final Function onEnd;

  const UserEnterSlideAnimation(
      {Key? key, required this.child, required this.onEnd})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserEnterSlideAnimationState();
}

class _UserEnterSlideAnimationState extends State<UserEnterSlideAnimation>
    with SingleTickerProviderStateMixin {
  Duration startAnimationDuraion = const Duration(milliseconds: 1000);
  Duration endAnimationDuraion = const Duration(milliseconds: 800);
  double startPos = 1.0;
  double endPos = 0.0;
  Curve curve = Curves.easeIn;
  bool isStart = true;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: Offset(startPos, 0), end: Offset(endPos, 0)),
      duration: startAnimationDuraion,
      curve: curve,
      builder: (context, offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: SizedBox(
            width: double.infinity,
            child: widget.child,
          ),
        );
      },
      child: widget.child,
      onEnd: () {
        if (!isStart) {
          widget.onEnd();
        }
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            curve = curve == Curves.easeIn ? Curves.easeInOut : Curves.easeIn;
            if (startPos == 1) {
              setState(() {
                isStart = false;
                startPos = 0.0;
                endPos = -2.0;
              });
            }
          },
        );
      },
    );
  }
}

class UserEnterBanner extends StatelessWidget {
  // const UserEnterBanner(
  //     {super.key, required this.displayName, this.backgroundColor, this.level});

  final String displayName;
  final int? level;
  final Color? backgroundColor;

  const UserEnterBanner(
      {Key? key, required this.displayName, this.level, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(left: 16.w),
        child: RoundedContainer(
          color: backgroundColor?.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14.w),
          padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (level != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                  margin: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(12.w))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 10.w,
                      ),
                      Text(
                        level.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              Text(
                displayName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                TIM_t("进入直播间"),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
