import 'package:example/pages/home/home.dart';
import 'package:example/pages/login/login.dart';
import 'package:example/utils/sms_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _sdkAppID = const int.fromEnvironment("sdk_app_id");
  bool isLoginsuccess = false;
  bool loading = true;
  String loginUserID = "";

  removeLocalSetting() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.remove("smsLoginToken");
    prefs.remove("smsLoginPhone");
    prefs.remove("smsLoginUserID");
  }

  @override
  void initState() {
    super.initState();
    _initSDK();
  }

  directToHomePage() {
    loading = false;
    isLoginsuccess = true;
    setState(() {});
  }

  directToLoginPage() {
    loading = false;
    isLoginsuccess = false;
    setState(() {});
  }

  checkLogin() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.setStringList('guidedPage', prefs.getStringList('guidedPage') ?? []);
    String? token = prefs.getString("smsLoginToken");
    String? phone = prefs.getString("smsLoginPhone");
    String? userId = prefs.getString("smsLoginUserID");

    if (token != null && phone != null && userId != null) {
      Map<String, dynamic> response = await SmsLogin.smsTokenLogin(
        userId: userId,
        token: token,
      );
      int errorCode = response['errorCode'];
      String errorMessage = response['errorMessage'];

      if (errorCode == 0) {
        Map<String, dynamic> datas = response['data'];
        String userId = datas['userId'];
        String userSig = datas['sdkUserSig'];
        print(userSig);
        print(userId);
        V2TimCallback data = await TencentImSDKPlugin.v2TIMManager
            .login(userID: userId, userSig: userSig);

        if (data.code != 0) {
          removeLocalSetting();
          directToLoginPage();
          return;
        }
        loginUserID = userId;
        directToHomePage();
      } else {
        directToLoginPage();
      }
    } else {
      directToLoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text(widget.title),
        // ),
        body: loading
            ? const Center(
                child: Text("loading...."),
              )
            : isLoginsuccess
                ? Home(
                    loginUserID: loginUserID,
                  )
                : const LoginPage());
  }

  _initSDK() async {
    final res = await TencentImSDKPlugin.v2TIMManager.initSDK(
        sdkAppID: _sdkAppID,
        loglevel: LogLevelEnum.V2TIM_LOG_ALL,
        listener: V2TimSDKListener());
    if (res.code == 0) {
      checkLogin();
    }
    // if (res.code == 0) {
    //   final response = await GenerateUserSig.generateUserSig(loginUserID);
    //   if (response.containsKey("userSig")) {
    //     await TencentImSDKPlugin.v2TIMManager
    //         .login(userID: loginUserID, userSig: response['userSig']);
    //     // await TencentImSDKPlugin.v2TIMManager
    //     //     .getMessageManager()
    //     //     .addAdvancedMsgListener(listener: V2TimAdvancedMsgListener(
    //     //   onRecvNewMessage: (msg) {
    //     //     print("recv new message");
    //     //   },
    //     // ));
    //   }
    // }
  }
}
