import 'dart:convert';
import 'dart:ui';

import 'package:example/pages/home/live_player.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tencent_cloud_av_chat_room/baseWidget/rounded_container.dart';
import 'package:tencent_cloud_av_chat_room/config/display_config.dart';
import 'package:tencent_cloud_av_chat_room/model/anchor_info.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_callback.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_config.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_controller.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_theme.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_custom_widget.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room_data.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class LiveRoom extends StatelessWidget {
  // const LiveRoom({super.key, required this.loginUserID, required this.playUrl});
  final String loginUserID;
  final String playUrl;

  const LiveRoom({Key? key, required this.loginUserID, required this.playUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TencentCloudAVChatRoom(
      controller: TencentCloudAvChatRoomController(),
      theme: TencentCloudAvChatRoomTheme(
          backgroundColor: Colors.black,
          hintColor: Colors.red,
          highlightColor: Colors.orange,
          accentColor: Colors.white,
          textTheme: TencentCloudAvChatRoomTextTheme(
              giftBannerSubTitleStyle: TextStyle(),
              giftBannerTitleStyle: TextStyle(),
              anchorTitleStyle: TextStyle(),
              anchorSubTitleStyle: TextStyle(),
              barrageTitleStyle: TextStyle(),
              barrageTextStyle: TextStyle()),
          secondaryColor: Colors.grey,
          inputDecorationTheme: InputDecorationTheme()),
      callback: TencentCloudAvChatRoomCallback(
          onMemberEnter: (memberInfo) {}, onRecvNewMessage: (message) {}),
      customWidgets: TencentCloudAvChatRoomCustomWidgets(
          roomHeaderAction: Container(),
          roomHeaderLeading: Container(),
          roomHeaderTag: Container(),
          onlineMemberListPanelBuilder: (context, id) {
            return Container();
          },
          anchorInfoPanelBuilder: (context, id) {
            return Container();
          },
          giftsPanelBuilder: (context) {
            return Container();
          },
          messageItemBuilder: (context, message, child) {
            return Container();
          },
          messageItemPrefixBuilder: (context, message) {
            return Container();
          },
          giftMessageBuilder: (context, message) {
            return Container();
          },
          textFieldActionBuilder: (
            context,
          ) {
            return [Container()];
          },
          textFieldDecoratorBuilder: (context) {
            return Container();
          }),
      config: TencentCloudAvChatRoomConfig(
          avChatRoomID: '',
          loginUserID: '',
          sdkAppID: 0,
          userSig: '',
          barrageMaxCount: 200,
          giftHttpBase: '',
          displayConfig: DisplayConfig()),
      data: TencentCloudAvChatRoomData(
          anchorInfo: AnchorInfo(), isSubscribe: false, notification: "直播间公告"),
    );
    return Stack(
      children: [
        LiveRoomPlayer(playUrl: playUrl),
        PageViewWithOpacity(
          child: Stack(
            children: [
              Positioned(
                  right: -15,
                  bottom: 25,
                  child: Lottie.asset(
                    'assets/hearts.json',
                    width: 100,
                    height: 400,
                    repeat: true,
                  )),
              TencentCloudAVChatRoom(
                controller: TencentCloudAvChatRoomController(),
                config: TencentCloudAvChatRoomConfig(
                    avChatRoomID: '@TGS#aCWHGJ3LC',
                    loginUserID: loginUserID,
                    giftHttpBase: "https://qcloudimg.tencent-cloud.cn/raw/",
                    displayConfig: DisplayConfig(
                      showAnchor: true,
                      showOnlineMemberCount: true,
                      showTextFieldGiftAction: true,
                      showTextFieldThumbsUpAction: true,
                    )),
                // customWidgets: TencentAvChatRoomKitCustomWidgets(
                //     // anchorInfoPanelBuilder: (context, groupID) {
                //     //   return const Text("anchorInfoPanelBuilder");
                //     // },
                //     // onlineMemberListPanelBuilder: (context, groupID) {
                //     //   return const Text("onlineMemberListPanelBuilder");
                //     // },
                //     // roomHeaderAction: const Text("roomHeaderAction"),
                //     // roomHeaderLeading: const Text("roomHeaderAction"),
                //     roomHeaderTag: RoundedContainer(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Image.asset(
                //         "assets/Vector.png",
                //         width: 14,
                //         height: 14,
                //       ),
                //       const SizedBox(
                //         width: 4,
                //       ),
                //       const Text(
                //         "小时榜排名162名",
                //         style: TextStyle(
                //             fontSize: 12,
                //             color: Colors.white,
                //             fontWeight: FontWeight.w400),
                //       )
                //     ],
                //   ),
                // )
                //     // messageItemBuilder: (context, message) {
                //     //   return Text("message item builder");
                //     // },
                //     // messageItemPrefixBuilder: (context, message) {
                //     //   return Text("message item prefix builder");
                //     // },
                //     // giftMessageBuilder: (context, message) {
                //     //   return Text("gift message builder");
                //     // },
                //     // textFieldDecoratorBuilder: (context) {
                //     //   return Text("textFieldDecoratorBuilder");
                //     // },
                //     // textFieldActionBuilder: (context) {
                //     //   return [Text("text field action")];
                //     // },
                //     // giftsPanelBuilder: (context) {
                //     //   return Text("gifts panel builder");
                //     // },
                //     ),
                data: TencentCloudAvChatRoomData(
                  isSubscribe: false,
                  notification:
                      TIM_t("欢迎来到直播间！严禁未成年人直播、打赏或向末成年人销售酒类商品。若主播销售酒类商品，请未成年人在监护人陪同下观看。直播间内严禁出现违法违规、低俗色情、吸烟酗酒、人身伤害等内容。如主播在直播中以不当方式诱导打赏私下交易请谨慎判断以防人身财产损失购买商品请点击下方购物车按钮，请勿私下交易，请大家注意财产安全，谨防网络诈骗。"),
                  anchorInfo: AnchorInfo(
                      subscribeNum: 200,
                      fansNum: 5768,
                      nickName: TIM_t("风雨人生"),
                      avatarUrl:
                          "https://qcloudimg.tencent-cloud.cn/raw/9c6b6806f88ee33b3685f0435fe9a8b3.png"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PageViewWithOpacity extends StatefulWidget {
  // const PageViewWithOpacity({super.key, required this.child});
  final Widget child;

  const PageViewWithOpacity({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageViewWithOpacityState();
}

class _PageViewWithOpacityState extends State<PageViewWithOpacity> {
  final PageController _pageController = PageController(initialPage: 1);
  double _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _initPageControllerListener();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        itemCount: 2,
        allowImplicitScrolling: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              color: Colors.transparent,
            );
          } else {
            return Opacity(
              opacity: _currentPage,
              child: widget.child,
            );
          }
        });
  }

  _initPageControllerListener() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 1.0;
      });
    });
  }
}
