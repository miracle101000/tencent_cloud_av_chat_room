import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/gift.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/message_item.dart';
import 'package:tencent_cloud_av_chat_room/liveRoom/chat/message_prefix.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class Barrage extends StatefulWidget {
  // const Barrage({
  //   super.key,
  //   this.barrageItemBuilder,
  //   this.barrageItemPrefix,
  //   this.initialMessage,
  //   required this.avChatRoomID,
  // });

  /// message item builder.
  final Widget Function(
          BuildContext context, V2TimMessage message, Widget child)?
      barrageItemBuilder;

  /// message item prefix builder.
  final Widget Function(BuildContext context, V2TimMessage message)?
      barrageItemPrefix;

  /// initial message
  final V2TimMessage? initialMessage;

  final String avChatRoomID;

  final int cachedMessageCount;

  const Barrage(
      {Key? key,
      this.barrageItemBuilder,
      this.barrageItemPrefix,
      this.initialMessage,
      int? cacheCount,
      required this.avChatRoomID})
      : cachedMessageCount = cacheCount ?? 200,
        super(key: key);

  @override
  State<StatefulWidget> createState() => BarrageState();
}

class BarrageState extends State<Barrage> {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);

  bool inTwoScreen = false;
  bool inBottom = true;
  final List<V2TimMessage> barrageList = [];
  final List<V2TimMessage> barrageListTask = [];
  final List<V2TimMessage> newBarrageList = [];
  Timer? _barragePeriodTimer;
  int needDisplayCount = 0;

  late V2TimAdvancedMsgListener _messageListener;

  @override
  void initState() {
    super.initState();
    _initMessageListener();
    // add scroll controller listener
    _scrollController.addListener(_scrollControllerHandler);

    // show initial message
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.initialMessage != null) {
        barrageList.add(widget.initialMessage!);
        _animatedListKey.currentState!
            .insertItem(0, duration: const Duration(milliseconds: 200));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _removeMessageListener();
    _scrollController.dispose();
  }

  insertBarrageItem(V2TimMessage msg) {
    _insertMessage(msg);
  }

  insertBarrageItemAndScroll(V2TimMessage msg) {
    _showLatestMessageList();
    barrageList.add(msg);
    _animatedListKey.currentState!
        .insertItem(0, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    final option1 = newBarrageList.length;
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            // ignore: prefer_const_constructors
            return LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: const [Colors.black, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, bounds.width, 37.w));
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            padding: EdgeInsets.only(left: 16.w),
            height: 0.3.sh,
            alignment: Alignment.bottomCenter,
            child: AnimatedList(
                key: _animatedListKey,
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                reverse: true,
                initialItemCount: 0,
                itemBuilder: (c, index, animation) {
                  final messageItem = barrageList.reversed.toList()[index];
                  final mesasgePrefix = _messageItemPrefix(messageItem);
                  final isInitialMessage = messageItem.elemType == 11;
                  final defaultMessageItemWidget = MessageItem(
                      message: messageItem, messagePrefix: mesasgePrefix);
                  final Widget messageItemWidget =
                      widget.barrageItemBuilder != null
                          ? widget.barrageItemBuilder!(
                              context, messageItem, defaultMessageItemWidget)
                          : defaultMessageItemWidget;
                  return SizeTransition(
                    sizeFactor: animation,
                    child: isInitialMessage
                        ? InitialMessage(text: messageItem.textElem!.text!)
                        : messageItemWidget,
                  );
                }),
          ),
        ),
        if (inTwoScreen && newBarrageList.isNotEmpty)
          Positioned(
              bottom: 0,
              left: 16.w,
              child: GestureDetector(
                onTap: () {
                  _showLatestMessageList();
                },
                child: RoundedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                  color: Colors.white,
                  child: Text(
                    option1 > 99
                        ? "99+"
                        : TIM_t_para("{{option1}}条新消息", "$option1条新消息")(
                            option1: option1),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ))
      ],
    );
  }

  /// 初始化消息监听器
  _initMessageListener() {
    _messageListener = V2TimAdvancedMsgListener(
      onRecvNewMessage: (msg) {
        if (msg.groupID == widget.avChatRoomID) {
          final isGiftMessage = Gift.isGiftMessage(msg);
          if (!isGiftMessage) {
            _insertMessage(msg);
          }
        }
      },
    );

    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .addAdvancedMsgListener(listener: _messageListener);
  }

  /// 移除消息监听器
  _removeMessageListener() {
    TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .removeAdvancedMsgListener(listener: _messageListener);
  }

  /// 每300毫秒展示消息。展示的消息数量取决于每300毫秒内收到的消息数[needDisplayCount]。
  _timePeriod() {
    _barragePeriodTimer =
        Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (barrageListTask.isNotEmpty) {
        _removeBarrageCount();
        final taskLength = barrageListTask.length;
        int eachDisplayRate = 10;
        if (taskLength > 10) {
          eachDisplayRate = 20;
        } else if (taskLength > 20) {
          eachDisplayRate = 30;
        }
        final displayCount = (taskLength / eachDisplayRate).ceil();
        for (var i = 0; i < displayCount; i++) {
          barrageList.add(barrageListTask.first);
          barrageListTask.removeAt(0);
          final isLast = i == displayCount - 1;
          _animatedListKey.currentState!.insertItem(0,
              duration: Duration(milliseconds: isLast ? 200 : 0));
        }
      } else {
        _cancelTimer();
      }
    });
  }

  _removeBarrageCount() {
    final isListOverflow = barrageList.length > widget.cachedMessageCount;
    if (isListOverflow) {
      final overflowCount = barrageList.length - widget.cachedMessageCount;
      for (var i = 0; i < overflowCount; i++) {
        _animatedListKey.currentState!.removeItem(0, (context, animation) {
          barrageList.removeAt(1);
          return Container();
        });
      }
    }
  }

  _insertMessage(V2TimMessage msg) {
    if (inTwoScreen) {
      _cancelTimer();
      newBarrageList.add(msg);
      setState(() {});
    } else {
      barrageListTask.add(msg);
      if (_barragePeriodTimer == null) {
        _timePeriod();
      }
    }
  }

  _cancelTimer() {
    _barragePeriodTimer?.cancel();
    _barragePeriodTimer = null;
  }

  Widget _messageItemPrefix(V2TimMessage msg) {
    if (widget.barrageItemPrefix != null) {
      return widget.barrageItemPrefix!(context, msg);
    }
    return MessagePrefix(message: msg);
  }

  _showLatestMessageList() {
    if (newBarrageList.isNotEmpty) {
      barrageList.addAll(newBarrageList);
      for (var i = 0; i < newBarrageList.length + needDisplayCount; i++) {
        _animatedListKey.currentState!
            .insertItem(0, duration: const Duration(milliseconds: 0));
      }
      newBarrageList.clear();
      needDisplayCount = 0;
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      setState(() {});
    }
  }

  _scrollControllerHandler() {
    if (_scrollController.offset > _scrollController.position.minScrollExtent) {
      if (!inTwoScreen && inBottom) {
        inTwoScreen = true;
        inBottom = false;
        setState(() {});
      }
    } else if (_scrollController.offset ==
        _scrollController.position.minScrollExtent) {
      if (inTwoScreen && !inBottom) {
        inTwoScreen = false;
        inBottom = true;
        if (newBarrageList.isNotEmpty) {
          _showLatestMessageList();
        } else {
          setState(() {});
        }
      }
    }
  }
}
