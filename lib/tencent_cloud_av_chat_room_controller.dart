import 'package:flutter/material.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

enum TencentCloudAvChatRoomControllerActionType {
  updateData,
  normal,
  sendGiftMessage,
  sendMessage,
  sendTextMessage,
  playAnimation,
}

class TencentCloudAvChatRoomController extends ChangeNotifier {
  TencentCloudAvChatRoomControllerActionType actionType =
      TencentCloudAvChatRoomControllerActionType.normal;
  TencentCloudAvChatRoomData? _data;
  String _giftData = "";
  V2TimMessage? _message;
  String _textString = "";
  String _animationUrl = "";

  TencentCloudAvChatRoomData? get liveKitData => _data;
  String get giftData => _giftData;
  V2TimMessage? get message => _message;
  String get textString => _textString;
  String get animationUrl => _animationUrl;

  /// update live kit releated data.
  updateData(TencentCloudAvChatRoomData data) {
    actionType = TencentCloudAvChatRoomControllerActionType.updateData;
    _data = data;
    notifyListeners();
  }

  /// send gift message.
  sendGiftMessage(String data) {
    actionType = TencentCloudAvChatRoomControllerActionType.sendGiftMessage;
    _giftData = data;
    notifyListeners();
  }

  /// send message.
  /// Need use tencent im sdk plugin to create message.
  sendMessage(V2TimMessage message) {
    actionType = TencentCloudAvChatRoomControllerActionType.sendMessage;
    _message = message;
    notifyListeners();
  }

  /// send text message.
  sendTextMessage(String text, String roomID) {
    actionType = TencentCloudAvChatRoomControllerActionType.sendTextMessage;
    _textString = text;
    notifyListeners();
  }

  /// play animation
  /// The [url] paramter support lottie json file and svga file.
  /// if [url] start with http will play network animation.
  playAnimation(String url) {
    actionType = TencentCloudAvChatRoomControllerActionType.playAnimation;
    _animationUrl = url;
    notifyListeners();
  }
}
