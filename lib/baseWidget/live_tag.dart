import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';

class TencentLiveTag extends StatelessWidget {
  // const TencentLiveTag({super.key, this.icon, this.description});
  final Widget? icon;
  final String? description;

  const TencentLiveTag({Key? key, this.icon, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.w,
            height: 12.w,
            child: icon ?? Container(),
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(
            description ?? "",
            style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
