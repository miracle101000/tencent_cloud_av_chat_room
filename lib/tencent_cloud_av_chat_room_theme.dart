import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TencentCloudAvChatRoomTheme {
  final Color backgroundColor;
  final Color hintColor;
  final Color highlightColor;
  final Color secondaryColor;
  final Color accentColor;
  final TencentCloudAvChatRoomTextTheme textTheme;
  final InputDecorationTheme inputDecorationTheme;
  final bool isDark;

  TencentCloudAvChatRoomTheme(
      {Color? backgroundColor,
      Color? hintColor,
      Color? highlightColor,
      Color? accentColor,
      TencentCloudAvChatRoomTextTheme? textTheme,
      InputDecorationTheme? inputDecorationTheme,
      this.isDark = true,
      Color? secondaryColor})
      : backgroundColor = backgroundColor ?? Colors.black.withOpacity(0.3),
        highlightColor = highlightColor ?? const Color(0xFF7AF4FF),
        secondaryColor = secondaryColor ?? Colors.white.withOpacity(0.6),
        accentColor = accentColor ?? Colors.black,
        hintColor = hintColor ?? Colors.white.withOpacity(0.6),
        textTheme = textTheme ?? TencentCloudAvChatRoomTextTheme(),
        inputDecorationTheme = inputDecorationTheme ??
            const InputDecorationTheme(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              isDense: true,
              hintStyle: TextStyle(color: Color(0xFFb4b4b9), fontSize: 14),
            );

  static Color globalAccentColor = Colors.black;

  ThemeData get themeData {
    TextTheme txtTheme =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    final textColor = txtTheme.bodyText1?.color;
    globalAccentColor = accentColor;
    return ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        backgroundColor: backgroundColor,
        hintColor: hintColor,
        highlightColor: highlightColor,
        inputDecorationTheme: inputDecorationTheme,
        textTheme: TextTheme(
            headline5: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)
                .merge(textTheme.giftBannerTitleStyle),
            headline6:
                TextStyle(fontSize: 12.sp).merge(textTheme.anchorTitleStyle),
            subtitle1: TextStyle(fontSize: 10.sp, color: secondaryColor)
                .merge(textTheme.anchorSubTitleStyle),
            subtitle2: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryColor)
                .merge(textTheme.giftBannerSubTitleStyle),
            bodyText1: TextStyle(
              color: highlightColor,
              fontSize: 12.sp,
            ).merge(textTheme.barrageTitleStyle),
            bodyText2: TextStyle(color: textColor, fontSize: 12.sp)
                .merge(textTheme.barrageTextStyle)));
  }
}

class TencentCloudAvChatRoomTextTheme {
  TencentCloudAvChatRoomTextTheme({
    this.barrageTitleStyle,
    this.barrageTextStyle,
    this.giftBannerSubTitleStyle,
    this.giftBannerTitleStyle,
    this.anchorTitleStyle,
    this.anchorSubTitleStyle,
  });

  final TextStyle? anchorTitleStyle;
  final TextStyle? anchorSubTitleStyle;
  final TextStyle? barrageTitleStyle;
  final TextStyle? barrageTextStyle;
  final TextStyle? giftBannerTitleStyle;
  final TextStyle? giftBannerSubTitleStyle;

  TencentCloudAvChatRoomTextTheme copyWith({
    TextStyle? anchorTitleStyle,
    TextStyle? anchorSubTitleStyle,
    TextStyle? barrageTitleStyle,
    TextStyle? barrageTextStyle,
    TextStyle? giftBannerTitleStyle,
    TextStyle? giftBannerSubTitleStyle,
  }) {
    return TencentCloudAvChatRoomTextTheme(
        barrageTextStyle: barrageTextStyle ?? this.barrageTextStyle,
        barrageTitleStyle: barrageTitleStyle ?? this.barrageTitleStyle,
        giftBannerTitleStyle: giftBannerTitleStyle ?? this.giftBannerTitleStyle,
        giftBannerSubTitleStyle:
            giftBannerSubTitleStyle ?? this.giftBannerSubTitleStyle,
        anchorSubTitleStyle: anchorSubTitleStyle ?? this.anchorSubTitleStyle,
        anchorTitleStyle: anchorTitleStyle ?? this.anchorTitleStyle);
  }
}

extension CustomColorSchemeX on ColorScheme {
  Color? get accentColor => TencentCloudAvChatRoomTheme.globalAccentColor;
}
