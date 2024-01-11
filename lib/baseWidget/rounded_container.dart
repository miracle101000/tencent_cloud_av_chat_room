import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedContainer extends StatelessWidget {
  // const RoundedContainer(
  //     {super.key,
  //     this.child,
  //     this.borderRadius,
  //     this.padding,
  //     this.color,
  //     this.height,
  //     this.width});
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? height;
  final double? width;
  final BoxShape? shape;

  const RoundedContainer(
      {Key? key,
      this.child,
      this.margin,
      this.shape,
      this.borderRadius,
      this.padding,
      this.color,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).backgroundColor;
    final boxShape = shape ?? BoxShape.rectangle;
    return Container(
      height: height,
      width: width,
      padding: padding ??
          EdgeInsets.only(top: 2.w, left: 2.w, bottom: 2.w, right: 4.w),
      margin: margin,
      decoration: BoxDecoration(
          shape: boxShape,
          color: color ?? backgroundColor,
          borderRadius: boxShape == BoxShape.circle
              ? null
              : (borderRadius ?? BorderRadius.circular(33.w))),
      child: child,
    );
  }
}
