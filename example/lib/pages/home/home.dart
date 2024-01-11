import 'package:example/pages/home/live_room.dart';
import 'package:example/utils/config.dart';
import 'package:example/utils/send_message_script.dart';
import 'package:flutter/material.dart';
import 'package:live_flutter_plugin/v2_tx_live_premier.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class Home extends StatefulWidget {
  // const Home({super.key, required this.loginUserID});
  final String loginUserID;

  const Home({Key? key, required this.loginUserID}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final avChatRoomID = '@TGS#aCWHGJ3LC';

  String groupName = "";
  String backgroundUrl = "";

  @override
  void initState() {
    super.initState();
    _getAvChatRoomInfo();
    // setupLicense();
  }

  @override
  Widget build(BuildContext context) {
    final showList = groupName.isEmpty && backgroundUrl.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text("直播列表"),
      ),
      body: showList
          ? Container()
          : Wrap(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveRoom(
                                  loginUserID: widget.loginUserID,
                                  playUrl:
                                      'webrtc://114289.liveplay.myqcloud.com/live/teststream',
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(backgroundUrl))),
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          groupName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("start send message"),
                  onPressed: () {
                    SendGroupMessageRestApi.run();
                  },
                ),
                ElevatedButton(
                  child: Text("stop send message"),
                  onPressed: () {
                    SendGroupMessageRestApi.stop();
                  },
                )
              ],
            ),
    );
  }

  _getAvChatRoomInfo() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final responst = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupsInfo(groupIDList: [avChatRoomID]);
    if (responst.code == 0) {
      final responseList = responst.data;
      final info = responseList!.first.groupInfo;
      groupName = info!.groupName ?? "";
      backgroundUrl = info.faceUrl ?? "";
      setState(() {});
    }
  }

  setupLicense() {
    final licenseUrl = Config.licenseUrl;
    final licenseKey = Config.licenseKey;
    V2TXLivePremier.setObserver(onPremierObserver);
    V2TXLivePremier.setLicence(licenseUrl, licenseKey);
  }

  onPremierObserver(V2TXLivePremierObserverType type, param) {
    debugPrint("==premier listener type= ${type.toString()}");
    debugPrint("==premier listener param= $param");
  }
}
