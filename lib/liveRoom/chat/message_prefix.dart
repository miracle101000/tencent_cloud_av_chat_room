import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';
import 'package:tencent_cloud_av_chat_room/utils/live_kit_custom_string.dart';

const List<Color> defaultUserLevelColor = [
  Color(0xFF43CD80),
  Color(0xFF3CCFA5),
  Color(0xFFFCAF41),
  Color(0xFFFF8C00),
  Color(0xFFFF8BB7),
  Color(0xFF3074FD),
  Color(0xFF9370DB),
  Color(0xFFDA70D6),
  Color(0xFF9400D3),
  Color(0xFFFF3030),
];

class MessagePrefix extends StatelessWidget {
  // const MessagePrefix({super.key, required this.message});

  final V2TimMessage message;

  const MessagePrefix({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msgCloudCustomData = message.cloudCustomData;
    final isLiveKitCustomData =
        LiveKitCustomString.isLiveKitCloudCustomData(msgCloudCustomData);
    if (isLiveKitCustomData) {
      final cmd = LiveKitCustomString.getCmd(msgCloudCustomData!);
      if (cmd == "userLevel") {
        final cmdInfo = LiveKitCustomString.getCmdInfo(msgCloudCustomData);
        final level = cmdInfo['level'] as String;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
          margin: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
              color: PrefixColorUtils.getColor(int.parse(level)),
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
                level,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        );
      } else {
        return const SizedBox(
          width: 0,
        );
      }
    } else {
      return const SizedBox(
        width: 0,
      );
    }
  }
}

class PrefixColorUtils {
  static Color getColor(int level) {
    int index = 0;
    if (level > 0) {
      index = level - 1 > 9 ? 9 : level - 1;
    }
    return defaultUserLevelColor[index];
  }
}
