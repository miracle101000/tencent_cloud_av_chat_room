import 'package:tencent_cloud_av_chat_room/model/anchor_info.dart';

class TencentCloudAvChatRoomData {
  TencentCloudAvChatRoomData({
    required this.anchorInfo,
    this.isSubscribe = false,
    this.notification,
  });

  late bool isSubscribe;
  late AnchorInfo anchorInfo;
  late String? notification;

  TencentCloudAvChatRoomData copyWith({
    String? loginUserID,
    bool? isSubscribe,
    AnchorInfo? anchorInfo,
    String? avChatRoomID,
    String? notification,
  }) {
    return TencentCloudAvChatRoomData(
        isSubscribe: isSubscribe ?? this.isSubscribe,
        anchorInfo: anchorInfo ?? this.anchorInfo,
        notification: notification ?? this.notification);
  }
}
