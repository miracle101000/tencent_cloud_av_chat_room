import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class TencentCloudAvChatRoomCallback {
  TencentCloudAvChatRoomCallback({this.onMemberEnter, this.onRecvNewMessage});

  /// Callback called when user joined av room chat.
  final Function(List<V2TimGroupMemberInfo> memberInfo)? onMemberEnter;

  /// Callback will be called when recv new message
  final Function(V2TimMessage onRecvNewMessage)? onRecvNewMessage;
}
