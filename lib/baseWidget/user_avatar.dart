import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  // const UserAvatar(
  //     {super.key,
  //     String? url,
  //     double? width,
  //     double? height,
  //     this.child,
  //     this.backgroundColor})
  //     : faceUrl = url ?? "",
  //       width = width ?? 32.0,
  //       height = height ?? 32.0;
  final String faceUrl;
  final double width;
  final double height;
  final Widget? child;
  final Color? backgroundColor;

  const UserAvatar(
      {Key? key,
      String? url,
      double? width,
      double? height,
      this.child,
      this.backgroundColor})
      : faceUrl = url ?? "",
        width = width ?? 32.0,
        height = height ?? 32.0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.w,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: faceUrl.isEmpty ? null : NetworkImage(faceUrl),
        child: child,
      ),
    );
  }
}
