<br>

<p align="center">
  <a href="https://www.tencentcloud.com/products/im">
    <img src="https://qcloudimg.tencent-cloud.cn/raw/429a2f58678a1f5b150c6ae04aa0b569.png" width="288px" alt="Tencent Chat Logo" />
  </a>
</p>

<h1 align="center">Tencent Cloud AV Chat Room</h1>

<p align="center">
  A room where users can join and leave freely, with no limit on the number of users, and without storing historical messages.
</p>

<p align="center">
More languages:
  <a href="https://cloud.tencent.com/document/product/269/86726">简体中文</a>
</p>

<br>

<p align="center">
    <img src="https://qcloudimg.tencent-cloud.cn/raw/609ef69a95153a435e8c57e8d72530fd.jpg">
</p>
<br>

## Experience DEMO

You can experience our Chat and Live modules via the following demos.

**Those following versions of demo have been built by the same Flutter project with our SDKs and extensions.**

![](https://qcloudimg.tencent-cloud.cn/raw/89234f5032d4f6f8d89a8b439ca97ca2.png)

## Introduction

`Tencent Cloud AV Chat Room` is a UI component based on [Tencent Cloud Chat SDK](https://pub.dev/packages/tencent_cloud_chat_sdk) and implemented around the business of live streaming scenarios. It includes features such as on-screen comment chat, gift giving, likes, number of people online, etc.

You can use this UI component to quickly implement a live streaming application.

## Get started

### What needs to be done before we start

- [Signed up](https://www.tencentcloud.com/document/product/378/17985?from=pub) for a Tencent Cloud account and completed [identity verification](https://www.tencentcloud.com/document/product/378/3629?from=pub).
- Created a chat application as instructed in [Creating and Upgrading an Application](https://www.tencentcloud.com/document/product/1047/34577?from=pub) and recorded the SDKAppID.
- Select [Auxiliary Tools](https://console.tencentcloud.com/im-detail/tool-usersig?from=pub) > UserSig Generation and Verification on the left sidebar. Generate "UserID" and the corresponding "UserSig", and copy the "key" information. [Refer to here](https://www.tencentcloud.com/document/product/1047/34580?from=pub#usersig-generation-and-verification).
- Create a Flutter application.
- Add `tencent_cloud_av_chat_room` to dependencies in pubspec.yaml file. Or by executing the following commands.

```
/// step 1:
flutter pub add tencent_cloud_av_chat_room

/// step 2:
flutter pub get
```

### Step 1: Initialize and login to [Chat](https://pub.dev/packages/tencent_cloud_chat_sdk)

There are two ways to initialize and log in to Chat:

- **outside the component**: Initialize and log in once in your flutter app.
- **inside the component**: Parameters are passed into the component through configuration.

If you are integrating this component in an existing [Chat](https://pub.dev/packages/tencent_cloud_chat_sdk) flutter project, you can skip this step.

#### Outside the component(recommend)

Initialize Chat in the flutter app you created, note that the Chat app only needs to be initialized once. This step can be skipped if integrating in an existing Chat project.

```dart
import 'package:tencent_av_chat_room_kit/tencent_cloud_chat_sdk_type.dart';

class _MyHomePageState extends State<MyHomePage> {
    final int _sdkAppID = 0; // Created in the preconditions
    final String _loginUserID = ""; // UserID in preconditions
    final String _userSig = ""; // UserSig in preconditions

	@override
	void initState() {
		super.initState();
		_initAndLoginIm();
	  }

	_initAndLoginIm() async {
		await TencentImSDKPlugin.v2TIMManager.initSDK(
			sdkAppID: _sdkAppID,
			loglevel: LogLevelEnum.V2TIM_LOG_ALL,
			listener: V2TimSDKListener());
		TencentImSDKPlugin.v2TIMManager
          .login(userID: _loginUserID, userSig: _userSig);
	}
}
```

#### Inside the component

You can also pass `SDKAppID`, `UserSig`, `UserID` into the component through configuration to initialize and log in Chat.

```dart
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room.dart';

class _TencentAVChatRoomKitState extends State<TencentCloudAVChatRoom> {
	final int _sdkAppID = 0; // Created in the preconditions
    final String _loginUserID = ""; // UserID in preconditions
    final String _userSig = ""; // UserSig in preconditions
	@override
  	Widget build(BuildContext context) {
		return TencentCloudAVChatRoom(
			config: TencentCloudAvChatRoomConfig(
				loginUserID: _loginUserID, sdkAppID: _sdkAppID, userSig: _userSig));
	}
}
```

### Step 2: Use component

Use this component in your appropriate module usually, we will integrate with [Tencent Cloud Live](https://pub.dev/packages/live_flutter_plugin) to build a live room.

```dart
import 'package:tencent_cloud_av_chat_room/tencent_cloud_av_chat_room.dart';
...
class _TencentAVChatRoomKitState extends State<TencentCloudAVChatRoom> {
	final int _sdkAppID = 0; // Created in the preconditions
    final String _loginUserID = ""; // UserID in preconditions
    final String _userSig = ""; // UserSig in preconditions
	@override
  	Widget build(BuildContext context) {
		return TencentCloudAVChatRoom(
			data: TencentCloudAvChatRoomData(anchorInfo: AnchorInfo()),
			config: TencentCloudAvChatRoomConfig(
				loginUserID: _loginUserID, sdkAppID: _sdkAppID, userSig: _userSig, avChatRoomID: ''));
	}
}
```

## API Docs

### TencentCloudAvChatRoomData

The data that the component needs to use, such as `anchor information`, `live streaming room announcements`, etc.

```dart
TencentCloudAvChatRoomData(
    anchorInfo: AnchorInfo(), // anchor info
    isSubscribe: false, // whether to subscribe
    notification: "notification" // live streaming room announcements
)
```

### TencentCloudAvChatRoomConfig

Component configuration information.

```dart
TencentCloudAvChatRoomConfig(
	avChatRoomID: '', //  Audio-Video group ID [https://www.tencentcloud.com/document/product/1047/48169?lang=en&pg=]
	loginUserID: '', // login user id
	sdkAppID: 0, // sdk app id
	userSig: '', // user sig[https://www.tencentcloud.com/document/product/1047/34580?from=pub#usersig-generation-and-verification].
	barrageMaxCount: 200, // The maximum number of messages on the screen. The default is 200. When the number is exceeded, older messages will be cleared.
	giftHttpBase: '', // http base of gift message.
	displayConfig: DisplayConfig() // Control the display and hiding of some components on the screen.
)
```

### TencentCloudAvChatRoomController

Component controller, which can be called outside the component to update data, send messages, etc.

```dart
final controller = TencentCloudAvChatRoomController();
final _needUpdateData = TencentCloudAvChatRoomData(
        anchorInfo: AnchorInfo(),
		isSubscribe: false,
		notification: "notification"
	);
final _textString = "This is a text mesasge";

final customInfoRocket = {
	"version": 1.0,
	"businessID": "flutter_live_kit", // command
	"data": {
		"cmd":
			"send_gift_message", // send_gift_message
		"cmdInfo": {
		"type": 3, // gift type
		"giftUrl": "1e8913f8c6d804972887fc179fa1fbd7.png",
		"giftCount": 1,
		"giftSEUrl": "assets/live/rocket.json",
		"giftName": "rocket",
		},
	}
};

final customInfoPlane = {
    "version": 1.0,
    "businessID": "flutter_live_kit",
    "data": {
      "cmd":
          "send_gift_message", // command
      "cmdInfo": {
        "type": 2,
        "giftUrl": "5e175b792cd652016aa87327b278402b.png",
        "giftCount": 1,
        "giftName": "plane",
      },
    }
};

final customInfoFlower = {
    "version": 1.0,
    "businessID": "flutter_live_kit",
    "data": {
      "cmd":
          "send_gift_message",
      "cmdInfo": {
        "type": 1,
        "giftUrl": "8f25a2cdeae92538b1e0e8a04f86841a.png",
        "giftCount": 1,
        "giftName": "flower",
        "giftUnits": "",
      },
    }
};

// Update the data information of the incoming component.
controller.updateData(_needUpdateData);

// Send text message.
controller.sendTextMessage(_textString);

// To send a gift message, the gift message needs to follow the specific format above. There are three types of gifts: [1]: Normal gifts [2]: Gifts without special effects [3]: Gifts with special effects
controller.sendGiftMessage(jsonEncode(customInfoFlower));

// Send any message, [message] should be created by yourself.
controller.sendMessage(message);

// Play gift animation(Lottie, SVGA).
controller.playAnimation("assets/live/rocket.json"):
```

### TencentCloudAvChatRoomCallback

Event Callback of room.

```dart
TencentCloudAvChatRoomCallback(
	onMemberEnter: (memberInfo) {}, // on member enter room.
	onRecvNewMessage: (message) {} // recv message.
)
```

### TencentCloudAvChatRoomCustomWidgets

Custom component.

```dart
TencentCloudAvChatRoomCustomWidgets(
	roomHeaderAction: Container(), // The area custom component is displayed in the upper right corner of the screen, and the default display is the number of people online in the live streaming room.
	roomHeaderLeading: Container(), // The area custom component is displayed in the upper left corner of the screen, and the anchor information is displayed by default.
	roomHeaderTag: Container(), // Below roomHeaderAction and roomHeaderLeading, it is generally used to display leaderboards, popularity, etc.
	onlineMemberListPanelBuilder: (context, id) { // Customize the panel that expands after clicking on the number of online users in the live streaming room.
		return Container();
	},
	anchorInfoPanelBuilder: (context, id) { // Customize the panel that expands after the anchor's avatar is clicked.
		return Container();
	},
	giftsPanelBuilder: (context) { // Customize the gifs panel.
		return Container();
	},
	messageItemBuilder: (context, message, child) { // Customize screen message.
		return Container();
	},
	messageItemPrefixBuilder: (context, message) { // Customize the prefix of the message.
		return Container();
	},
	giftMessageBuilder: (context, message) { // Gift message customization, gift message sliding in from the left side of the screen.
		return Container();
	},
	textFieldActionBuilder: ( // Customize the lower right area of the screen
		context,
	) {
		return [Container()];
	},
	textFieldDecoratorBuilder: (context) { // Customize the input box at the bottom left of the screen
		return Container();
	}
)
```

### TencentCloudAvChatRoomTheme

Customize background color etc.

```dart
TencentCloudAvChatRoomTheme(
    backgroundColor: Colors.black, // The widget's background color,
    hintColor: Colors.red, // hint text color
    highlightColor: Colors.orange,
    accentColor: Colors.white,
    textTheme: TencentCloudAvChatRoomTextTheme(),
    secondaryColor: Colors.grey,
    inputDecorationTheme: InputDecorationTheme()
)
```

### TencentCloudAvChatRoomTextTheme

Text theme.

```dart
TencentCloudAvChatRoomTextTheme(
    giftBannerSubTitleStyle: TextStyle(),
    giftBannerTitleStyle: TextStyle(),
    anchorTitleStyle: TextStyle(),
    anchorSubTitleStyle: TextStyle(),
    barrageTitleStyle: TextStyle(),
    barrageTextStyle: TextStyle()
)
```

## Contact Us

Please do not hesitate to contact us in the following place, if you have any further questions or tend to learn more about the use cases.

- Telegram Group: https://t.me/+1doS9AUBmndhNGNl
- WhatsApp Group: https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A
- QQ Group: 788910197, chat in Chinese

Our Website: https://www.tencentcloud.com/products/im?from=pub
