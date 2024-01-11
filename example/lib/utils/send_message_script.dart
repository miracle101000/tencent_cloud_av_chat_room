import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:example/utils/request.dart';

const messageCount = 5;
const textMessageCount = 10;

class SendGroupMessageRestApi {
  static Timer? _timer;

  static run() async {
    // _timer = Timer.periodic(const Duration(seconds: 1), (t) {
    // for (var i = 0; i < 2; i++) {
    //   SendGroupMessageRestApi.sendMessage(1);
    // }
    // await Future.delayed(const Duration(seconds: 1));
    // for (var i = 0; i < 2; i++) {
    //   SendGroupMessageRestApi.sendMessage(2);
    // }
    // SendGroupMessageRestApi.sendMessage(1);
    for (var i = 0; i < 5; i++) {
      SendGroupMessageRestApi.sendMessage(0);
    }
    // SendGroupMessageRestApi.sendMessage(2);
    // for (var i = 0; i < messageCount; i++) {
    //   SendGroupMessageRestApi.sendMessage(0);
    // }
    // SendGroupMessageRestApi.sendMessage(3);
    // for (var i = 0; i < messageCount; i++) {
    //   SendGroupMessageRestApi.sendMessage(0);
    // }
    // SendGroupMessageRestApi.sendMessage(4);
    // });
  }

  static stop() {
    _timer?.cancel();
    _timer = null;
  }

  static final customInfoRocket = {
    "version": 1.0, // 协议版本号
    "businessID": "flutter_live_kit", // 业务标识字段
    "data": {
      "cmd":
          "send_gift_message", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
      "cmdInfo": {
        "type": 3,
        "giftUrl": "1e8913f8c6d804972887fc179fa1fbd7.png",
        "giftCount": 1,
        "giftSEUrl": "assets/live/rocket.json",
        "giftName": "超级火箭",
      },
    }
  };

  static final customInfoPlane = {
    "version": 1.0, // 协议版本号
    "businessID": "flutter_live_kit", // 业务标识字段
    "data": {
      "cmd":
          "send_gift_message", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
      "cmdInfo": {
        "type": 2,
        "giftUrl": "5e175b792cd652016aa87327b278402b.png",
        "giftCount": 1,
        "giftName": "飞机",
      },
    }
  };

  static final customInfoFlower = {
    "version": 1.0, // 协议版本号
    "businessID": "flutter_live_kit", // 业务标识字段
    "data": {
      "cmd":
          "send_gift_message", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
      "cmdInfo": {
        "type": 1,
        "giftUrl": "8f25a2cdeae92538b1e0e8a04f86841a.png",
        "giftCount": 1,
        "giftName": "花",
        "giftUnits": "朵",
      },
    }
  };

  static final customInfoThumbsUp = {
    "version": 1.0, // 协议版本号
    "businessID": "flutter_live_kit", // 业务标识字段
    "data": {
      "cmd":
          "thumbs_up", // send_gift_message: 发送礼物消息, update_online_member: 更新在线人数
    }
  };

  static sendMessage(int type) async {
    final random = Random().nextInt(1000000);
    var messageMap = {
      "MsgType": "TIMTextElem",
      "MsgContent": {"Text": "测试文本消息 $random"}
    }; // 礼物消息带特效
    if (type == 1) {
      messageMap = {
        "MsgType": "TIMCustomElem",
        "MsgContent": {"Data": jsonEncode(customInfoRocket)}
      };
    }
    // 礼物消息不带特效
    if (type == 2) {
      messageMap = {
        "MsgType": "TIMCustomElem",
        "MsgContent": {"Data": jsonEncode(customInfoPlane)}
      };
    }
    // 普通礼物消息
    if (type == 3) {
      messageMap = {
        "MsgType": "TIMCustomElem",
        "MsgContent": {"Data": jsonEncode(customInfoFlower)}
      };
    }
    // 点赞消息
    if (type == 4) {
      messageMap = {
        "MsgType": "TIMCustomElem",
        "MsgContent": {"Data": jsonEncode(customInfoThumbsUp)}
      };
    }

    await appRequest(
        baseUrl: "https://console.tim.qq.com",
        path: "/v4/group_open_http_svc/send_group_msg",
        params: {
          "sdkappid": 1400187352,
          "identifier": "admin",
          "usersig":
              "eJwtzEsLgkAUhuH-MuuQ48ycMYQWIlGJdDE3LgdmqlNo3rrTf8-U5fd88H5YGu*du62Zz7gDbNJvMrZo6UA9a5NTMR6NueiyJMN8VwK4U08gHx77LKm2nSMiB4BBW8r-pjzkElHJsULHrhulQbLdCF1VjZDL03wdZgvUq937esYXKKuC5HGL4tQU2Yx9fxjXMRo_",
          "contenttype": "json"
        },
        method: "post",
        data: {
          "GroupId": "@TGS#aCWHGJ3LC",
          "Random": random,
          "MsgBody": [
            messageMap
            // {
            //   "MsgType": "TIMTextElem",
            //   "MsgContent": {"Text": "测试文本消息 $random"}
            // },
            // {
            //   "MsgType": "TIMCustomElem",
            //   "MsgContent": {"Data": jsonEncode(customInfoRocket)}
            // },
            // {
            //   "MsgType": "TIMTextElem",
            //   "MsgContent": {"Text": "red packet2"}
            // }
          ]
        });
  }
}
