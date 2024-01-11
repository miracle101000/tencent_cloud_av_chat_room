import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class UserEnter {
  UserEnter(this.timestamp, this.userInfo);

  final int timestamp;
  final V2TimGroupMemberInfo userInfo;
}
