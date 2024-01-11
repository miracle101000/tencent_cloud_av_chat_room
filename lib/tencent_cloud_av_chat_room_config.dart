import 'package:tencent_cloud_av_chat_room/config/display_config.dart';
import 'package:tencent_cloud_av_chat_room/config/message_config.dart';

class TencentCloudAvChatRoomConfig {
  TencentCloudAvChatRoomConfig(
      {this.sdkAppID,
      required this.loginUserID,
      this.userSig,
      required this.avChatRoomID,
      this.barrageMaxCount,
      this.giftHttpBase,
      DisplayConfig? displayConfig})
      : displayConfig = displayConfig ?? DisplayConfig();

  /// If IM is already initialized and logged in outside of Live Kit, you do not need to pass this parameter. [https://cloud.tencent.com/document/product/269/75293]
  final int? sdkAppID;

  /// If IM is already initialized and logged in outside of Live Kit, you do not need to pass this parameter. [https://cloud.tencent.com/document/product/269/75293]
  final String loginUserID;

  /// If IM is already initialized and logged in outside of Live Kit, you do not need to pass this parameter. [https://cloud.tencent.com/document/product/269/75293]
  final String? userSig;

  /// view display config
  final DisplayConfig displayConfig;

  /// use for gift message.
  final String? giftHttpBase;

  /// Tht id of av chat group.
  final String avChatRoomID;

  /// The max of barrage count. default is 200.
  final int? barrageMaxCount;
}
