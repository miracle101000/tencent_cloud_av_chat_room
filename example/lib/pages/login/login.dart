// ignore_for_file: avoid_relative_lib_imports, avoid_print, unused_import
import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:example/pages/home/home.dart';
import 'package:example/pages/login/login_captcha.dart';
import 'package:example/pages/login/web_login_captcha.dart';
import 'package:example/utils/sms_login.dart';
import 'package:example/utils/toast.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class LoginPage extends StatelessWidget {
  final Function? initIMSDK;
  const LoginPage({Key? key, this.initIMSDK}) : super(key: key);

  removeLocalSetting() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    prefs.remove("smsLoginToken");
    prefs.remove("smsLoginPhone");
    prefs.remove("smsLoginUserID");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: AppLayout(initIMSDK: initIMSDK),
          resizeToAvoidBottomInset: false,
        ));
  }
}

class AppLayout extends StatelessWidget {
  final Function? initIMSDK;
  const AppLayout({Key? key, this.initIMSDK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Stack(
        children: [
          const AppLogo(),
          LoginForm(
            initIMSDK: initIMSDK,
          ),
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [Color(0xFFC0E1FF), Color(0xFF147AFF)]),
            ),
            child: Image.asset("assets/hero_image.png")),
        Container(
          padding: EdgeInsets.only(top: height / 30, left: 24),
          margin: const EdgeInsets.only(top: 100),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 70,
                child: Image(
                  image: AssetImage("assets/logo_transparent.png"),
                ),
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(right: 5),
                height: 220,
                padding: const EdgeInsets.only(left: 12, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "Tencent Live Kit Demo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "欢迎使用本 APP 体验腾讯云 IM 产品服务",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        )
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  final Function? initIMSDK;
  const LoginForm({Key? key, required this.initIMSDK}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginFormState();

  // @override
  // _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userSigEtController.dispose();
    telEtController.dispose();
    super.dispose();
  }

  bool isGeted = false;
  String tel = '';
  int timer = 60;
  String sessionId = '';
  String code = '';
  bool isValid = false;
  TextEditingController userSigEtController = TextEditingController();
  TextEditingController telEtController = TextEditingController();
  String dialCode = "+86";
  String countryName = "中国大陆";

  initService() {
    if (widget.initIMSDK != null) {
      widget.initIMSDK!();
    }
    userSigEtController.addListener(checkIsValidForm);
    telEtController.addListener(checkIsValidForm);
    SmsLogin.initLoginService();
    setTel();
  }

  checkIsValidForm() {
    print(isValid);
    if (userSigEtController.text.isNotEmpty &&
        telEtController.text.isNotEmpty) {
      setState(() {
        isValid = true;
      });
    } else if (isValid) {
      setState(() {
        isValid = false;
      });
    }
  }

  setTel() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    String? phone = prefs.getString("smsLoginPhone");
    if (phone != null) {
      telEtController.value = TextEditingValue(
        text: phone,
      );
      setState(() {
        tel = phone;
      });
    }
  }

  timeDown() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        if (timer == 0) {
          setState(() {
            timer = 60;
            isGeted = false;
          });
          return;
        }
        setState(() {
          timer = timer - 1;
        });
        timeDown();
      }
    });
  }

  // 获取验证码
  getLoginCode(context) async {
    if (tel.isEmpty) {
      Utils.toast("请输入手机号");
      return;
    } else if (!RegExp(r"1[0-9]\d{9}$").hasMatch(tel)) {
      Utils.toast("手机号格式错误");
      return;
    } else {
      await _showMyDialog();
    }
  }

  // 验证验证码后台下发短信
  vervifyPicture(messageObj) async {
    // String captchaWebAppid =
    //     Provider.of<AppConfig>(context, listen: false).appid;
    String phoneNum = "$dialCode$tel";
    const sdkAppid = "1400187352";
    print("sdkAppID$sdkAppid");
    Map<String, dynamic> response = await SmsLogin.vervifyPicture(
      phone: phoneNum,
      ticket: messageObj['ticket'],
      randstr: messageObj['randstr'],
      appId: sdkAppid,
    );
    int errorCode = response['errorCode'];
    String errorMessage = response['errorMessage'];
    if (errorCode == 0) {
      Map<String, dynamic> res = response['data'];
      String sid = res['sessionId'];
      setState(() {
        isGeted = true;
        sessionId = sid;
      });
      timeDown();
      Utils.toast("验证码发送成功");
    } else {
      Utils.toast(errorMessage);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          content: SingleChildScrollView(
              child:
                  // WebLoginCaptcha(
                  //     onSuccess: vervifyPicture,
                  //     onClose: () {
                  //       Navigator.pop(context);
                  //     })
                  LoginCaptcha(
                      onSuccess: vervifyPicture,
                      onClose: () {
                        Navigator.pop(context);
                      })),
        );
      },
    );
  }

  directToHomePage(String userID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  loginUserID: userID,
                )));
  }

  smsFristLogin() async {
    if (tel == '') {
      Utils.toast("请输入手机号");
    }
    if (sessionId == '' || code == '') {
      Utils.toast("验证码异常");
      return;
    }
    String phoneNum = "$dialCode$tel";
    Map<String, dynamic> response = await SmsLogin.smsFirstLogin(
      sessionId: sessionId,
      phone: phoneNum,
      code: code,
    );
    int errorCode = response['errorCode'];
    String errorMessage = response['errorMessage'];

    if (errorCode == 0) {
      Map<String, dynamic> datas = response['data'];
      // userId, sdkAppId, sdkUserSig, token, phone:tel
      String userId = datas['userId'];
      String userSig = datas['sdkUserSig'];
      String token = datas['token'];
      String phone = datas['phone'];
      int sdkAppId = datas['sdkAppId'];

      var data = await TencentImSDKPlugin.v2TIMManager.login(
        userID: userId,
        userSig: userSig,
      );
      if (data.code != 0) {
        final option1 = data.desc;
        Utils.toast("登录失败$option1");
        return;
      }

      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      prefs.setString("smsLoginToken", token);
      prefs.setString("smsLoginPhone", phone.replaceFirst(dialCode, ""));
      prefs.setString("smsLoginUserID", userId);
      prefs.setString("sdkAppId", sdkAppId.toString());
      setState(() {
        tel = '';
        code = '';
        timer = 60;
        isGeted = false;
      });
      userSigEtController.clear();
      telEtController.clear();
      directToHomePage(userId);
    } else {
      Utils.toast(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            bottom: 350,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              decoration: const BoxDecoration(
                //背景
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                //设置四周边框
              ),
              // color: Colors.white,
              // height: MediaQuery.of(context).size.height - 600,

              width: MediaQuery.of(context).size.width,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "国家/地区",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    CountryListPick(
                      appBar: AppBar(
                        // backgroundColor: Colors.blue,
                        title: const Text("选择你的国家区号",
                            style: TextStyle(fontSize: 17)),
                        flexibleSpace: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: const [
                              Color(0xFFC0E1FF),
                              Color(0xFF147AFF)
                            ]),
                          ),
                        ),
                      ),

                      // if you need custome picker use this
                      pickerBuilder: (context, CountryCode? countryCode) {
                        return Row(
                          children: [
                            // 屏蔽伊朗 98
                            // 朝鲜 82 850
                            // 叙利亚 963
                            // 古巴 53
                            Text(
                                "${countryName == "China" ? "中国大陆" : countryName}(${countryCode?.dialCode})",
                                style: const TextStyle(
                                    color: Color.fromRGBO(17, 17, 17, 1),
                                    fontSize: 16)),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(17, 17, 17, 0.8),
                            ),
                          ],
                        );
                      },

                      // To disable option set to false
                      theme: CountryTheme(
                          isShowFlag: false,
                          isShowTitle: true,
                          isShowCode: true,
                          isDownIcon: true,
                          showEnglishName: true,
                          searchHintText: "请使用英文搜索",
                          searchText: "搜索"),
                      // Set default value
                      initialSelection: '+86',
                      onChanged: (code) {
                        setState(() {
                          dialCode = code?.dialCode ?? "+86";
                          countryName = code?.name ?? "中国大陆";
                        });
                      },
                      useUiOverlay: false,
                      // Whether the country list should be wrapped in a SafeArea
                      useSafeArea: false,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 34),
                      child: Text(
                        "手机号",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextField(
                      controller: telEtController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 14),
                        hintText: "请输入手机号",
                        hintStyle: TextStyle(fontSize: 16),
                        //
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) {
                        setState(() {
                          tel = v;
                        });
                      },
                    ),
                    Padding(
                        child: Text(
                          "验证码",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 17),
                        ),
                        padding: EdgeInsets.only(
                          top: 17,
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: userSigEtController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 5),
                              hintText: "请输入验证码",
                              hintStyle: TextStyle(fontSize: 16),
                            ),
                            keyboardType: TextInputType.number,
                            //校验密码
                            onChanged: (value) {
                              print(value);
                              if ('$code$code' == value && value.length > 5) {
                                //键入重复的情况
                                setState(() {
                                  userSigEtController.value = TextEditingValue(
                                    text: code, //不赋值新的 用旧的;
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: code.length),
                                    ), //  此处是将光标移动到最后,
                                  );
                                });
                              } else {
                                //第一次输入验证码
                                setState(() {
                                  userSigEtController.value = TextEditingValue(
                                    text: value,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: value.length),
                                    ), //  此处是将光标移动到最后,
                                  );
                                  code = value;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: isGeted
                                ? Text(timer.toString())
                                : Text(
                                    "获取验证码",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                            onPressed: isGeted
                                ? null
                                : () {
                                    //获取验证码
                                    FocusScope.of(context).unfocus();
                                    getLoginCode(context);
                                  },
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 23,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text("登录"),
                              onPressed: smsFristLogin,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
