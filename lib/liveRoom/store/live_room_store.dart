import 'package:flutter/material.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';

// ignore: must_be_immutable
class LiveRoomSharedWidget extends InheritedWidget {
  TencentCloudAvChatRoomData liveKitData;

  final LiveRoomStoreState data;
  final int thumbsUpCount;

  LiveRoomSharedWidget(
      {Key? key,
      required this.data,
      required this.thumbsUpCount,
      required this.liveKitData,
      required Widget child})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant LiveRoomSharedWidget oldWidget) {
    return (oldWidget.liveKitData != liveKitData ||
        oldWidget.thumbsUpCount != thumbsUpCount);
  }
}

class LiveRoomStore extends StatefulWidget {
  final Widget child;
  final TencentCloudAvChatRoomData liveKitData;

  const LiveRoomStore(
      {Key? key, required this.child, required this.liveKitData})
      : super(key: key);

  static LiveRoomStoreState of(BuildContext context, {bool rebuild = true}) {
    return rebuild
        ? context
            .dependOnInheritedWidgetOfExactType<LiveRoomSharedWidget>()!
            .data
        : context.findAncestorWidgetOfExactType<LiveRoomSharedWidget>()!.data;
  }

  @override
  State<StatefulWidget> createState() => LiveRoomStoreState();
}

class LiveRoomStoreState extends State<LiveRoomStore> {
  late TencentCloudAvChatRoomData _liveKitData;
  int thumbsUpCount = 0;

  @override
  void initState() {
    super.initState();
    _liveKitData = widget.liveKitData;
  }

  updateLiveKitData(TencentCloudAvChatRoomData newData) {
    setState(() {
      _liveKitData = newData;
    });
  }

  updateThumbsUpCount(int count) {
    setState(() {
      thumbsUpCount = count;
    });
  }

  increaseThumbsUpCount() {
    setState(() {
      thumbsUpCount = thumbsUpCount + 1;
    });
  }

  TencentCloudAvChatRoomData get data => _liveKitData;

  @override
  Widget build(BuildContext context) {
    return LiveRoomSharedWidget(
        thumbsUpCount: thumbsUpCount,
        data: this,
        liveKitData: _liveKitData,
        child: widget.child);
  }
}
