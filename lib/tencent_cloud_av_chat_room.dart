library tencent_live_kit;

// export im sdk
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_callback.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_custom_widget.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_theme.dart';

import 'tencent_cloud_chat_sdk_type.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/live_room.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/store/live_room_store.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_controller.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';

class TencentCloudAVChatRoom extends StatefulWidget {
  final TencentCloudAvChatRoomConfig config;
  final TencentCloudAvChatRoomCustomWidgets? customWidgets;
  final TencentCloudAvChatRoomData data;
  final TencentCloudAvChatRoomController? controller;
  final TencentCloudAvChatRoomCallback? callback;
  final TencentCloudAvChatRoomTheme? theme;

  const TencentCloudAVChatRoom(
      {Key? key,
      required this.config,
      this.customWidgets,
      required this.data,
      this.controller,
      this.callback,
      this.theme})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TencentAVChatRoomKitState();
}

class _TencentAVChatRoomKitState extends State<TencentCloudAVChatRoom> {
  late final TencentCloudAvChatRoomConfig _config;

  @override
  void initState() {
    super.initState();
    // _config = widget.config ?? TencentAvChatRoomKitConfig();
    _config = widget.config;
    initializeIM();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final theme = widget.theme ?? TencentCloudAvChatRoomTheme();
    Size designSize;
    if (orientation == Orientation.landscape) {
      designSize = const Size(812, 375);
    } else {
      designSize = const Size(375, 812);
    }
    ScreenUtil.init(
      context,
      designSize: designSize,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Theme(
        data: theme.themeData,
        child: LiveRoomStore(
          liveKitData: widget.data,
          child: LiveRoom(
            controller: widget.controller,
            config: _config,
            data: widget.data,
            customWidgets: widget.customWidgets,
            callback: widget.callback,
          ),
        ),
      ),
    );
  }

  initializeIM() async {
    ///  if IM not initialized outside of Live Kit
    if (_config.sdkAppID != null) {
      await TencentImSDKPlugin.v2TIMManager.initSDK(
          sdkAppID: _config.sdkAppID!,
          loglevel: LogLevelEnum.V2TIM_LOG_ALL,
          listener: V2TimSDKListener());
    }

    /// if IM not logged in outside of Live Kit
    if (_config.userSig != null) {
      TencentImSDKPlugin.v2TIMManager
          .login(userID: _config.loginUserID, userSig: _config.userSig!);
    }
  }
}
