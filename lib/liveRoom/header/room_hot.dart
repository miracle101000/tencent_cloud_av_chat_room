import 'package:flutter/material.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/store/live_room_store.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class RoomHot extends StatefulWidget {
  // const RoomHot({super.key, required this.groupID});
  final String groupID;

  const RoomHot({Key? key, required this.groupID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoomHotState();
}

class _RoomHotState extends State<RoomHot> {
  late V2TimGroupListener _listener;

  @override
  void initState() {
    super.initState();
    _getRoomHot();
    _addHotChangeListener();
  }

  @override
  void dispose() {
    super.dispose();
    TencentImSDKPlugin.v2TIMManager.removeGroupListener(listener: _listener);
  }

  @override
  Widget build(BuildContext context) {
    final liveRoomStoreState = LiveRoomStore.of(context);
    final option1 = liveRoomStoreState.thumbsUpCount;
    return Text(
      TIM_t_para("{{option1}} 本场点赞", "$option1 本场点赞")(option1: option1),
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  _getRoomHot() async {
    final response = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupCounters(groupID: widget.groupID, keys: ['hot']);

    if (response.code == 0) {
      final hot = response.data?['hot'] ?? 0;
      // ignore: use_build_context_synchronously
      final liveRoomStoreState = LiveRoomStore.of(context, rebuild: false);
      liveRoomStoreState.updateThumbsUpCount(hot);
    }
  }

  _addHotChangeListener() {
    _listener = V2TimGroupListener(
      onGroupCounterChanged: (groupID, key, newValue) {
        if (groupID == widget.groupID && key == "hot") {
          final hot = newValue;
          final liveRoomStoreState = LiveRoomStore.of(context, rebuild: false);
          final thumbsUpCount = liveRoomStoreState.thumbsUpCount;
          if (hot > thumbsUpCount) {
            liveRoomStoreState.updateThumbsUpCount(hot);
          }
        }
      },
    );

    TencentImSDKPlugin.v2TIMManager.addGroupListener(listener: _listener);
  }
}
