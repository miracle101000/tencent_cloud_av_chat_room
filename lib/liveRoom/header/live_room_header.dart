import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/header/anchor_panel.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/header/anchor_profile.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/header/online_member.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/header/room_hot.dart';
import 'package:tencent_cloud_av_chat_room/model/anchor_info.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';

class LiveRoomHeader extends StatelessWidget {
  final TencentCloudAvChatRoomConfig config;
  final TencentCloudAvChatRoomData data;
  final Widget? leading;
  final Widget? action;
  final Widget? tag;
  final Widget Function(BuildContext context, String groupID)?
      onlineMemberListPanelBuilder;

  final Widget Function(BuildContext context, String groupID)?
      anchorInfoPanelBuilder;

  const LiveRoomHeader(
      {Key? key,
      required this.config,
      required this.data,
      this.leading,
      this.action,
      this.tag,
      this.onlineMemberListPanelBuilder,
      this.anchorInfoPanelBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anchorinfo = data.anchorInfo;
    final isSubscribe = data.isSubscribe;
    return LiveRoomHeaderScaffold(
      action: action ??
          Row(
            children: [
              if (config.displayConfig.showOnlineMemberCount)
                GestureDetector(
                    onTap: () {
                      showMaterialModalBottomSheet(
                          context: context,
                          expand: false,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.w),
                                  topRight: Radius.circular(20.w))),
                          builder: (c) {
                            if (onlineMemberListPanelBuilder != null) {
                              return onlineMemberListPanelBuilder!(
                                  context, config.avChatRoomID);
                            }
                            return OnlineMemberList(
                              avChatRoomID: config.avChatRoomID,
                            );
                          });
                    },
                    child: OnlineMember(avChatRoomID: config.avChatRoomID)),
            ],
          ),
      leading: leading ??
          (config.displayConfig.showAnchor
              ? AnchorProfile(
                  faceUrl: anchorinfo.avatarUrl,
                  nickName: anchorinfo.nickName,
                  subInfo: RoomHot(
                    groupID: config.avChatRoomID,
                  ),
                  isSubscribe: isSubscribe,
                  onAvatarTap: () {
                    _showAnchorPanel(context, anchorinfo);
                  },
                  onSubscribeTap: () {
                    _showAnchorPanel(context, anchorinfo);
                  },
                )
              : Container()),
      tag: tag ?? Container(),
    );
  }

  _showAnchorPanel(BuildContext context, AnchorInfo anchorInfo) {
    showMaterialModalBottomSheet(
        context: context,
        expand: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.w),
                topRight: Radius.circular(20.w))),
        builder: (c) {
          if (anchorInfoPanelBuilder != null) {
            return anchorInfoPanelBuilder!(context, config.avChatRoomID);
          }
          return AnchorPanel(
            anchorInfo: anchorInfo,
            isSubScribe: data.isSubscribe,
          );
        });
  }
}

class LiveRoomHeaderScaffold extends StatelessWidget {
  final Widget? leading;
  final Widget? action;
  final Widget? tag;

  const LiveRoomHeaderScaffold({Key? key, this.leading, this.action, this.tag})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double topPadding;
    if (orientation == Orientation.landscape || kIsWeb) {
      topPadding = 10.w;
    } else {
      topPadding = ScreenUtil().statusBarHeight;
    }
    return Container(
      padding: EdgeInsets.only(top: topPadding, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerBar(),
          _headerTag(),
        ],
      ),
    );
  }

  Widget _headerBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [leading ?? Container(), action ?? Container()],
    );
  }

  Widget _headerTag() {
    return tag ?? Container();
  }
}
