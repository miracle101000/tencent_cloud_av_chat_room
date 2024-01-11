import 'package:flutter/material.dart';

import 'package:example/pages/login/tim_webview.dart'
    if (dart.library.html) 'package:example/pages/login/tim_webview_web_implement.dart';

enum CaptchaStatus { unReady, loading, ready }

class WebLoginCaptcha extends StatefulWidget {
  const WebLoginCaptcha(
      {Key? key, required this.onSuccess, required this.onClose})
      : super(key: key);
  final void Function(dynamic obj) onSuccess;
  final void Function() onClose;

  @override
  _WebLoginCaptchaState createState() => _WebLoginCaptchaState();
}

class _WebLoginCaptchaState extends State<WebLoginCaptcha> {
  CaptchaStatus captchaStatus = CaptchaStatus.unReady;
  bool isClose = false;
  double width = 360;
  double height = 360;

  double getWidth() {
    switch (captchaStatus) {
      case CaptchaStatus.unReady:
        return 0;
      case CaptchaStatus.loading:
        return 130;
      case CaptchaStatus.ready:
        return width;
    }
  }

  double getHeight() {
    switch (captchaStatus) {
      case CaptchaStatus.unReady:
        return 0;
      case CaptchaStatus.loading:
        return 130;
      case CaptchaStatus.ready:
        return height;
    }
  }

  @override
  build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Center(
          child: SizedBox(
            width: getWidth(),
            height: getHeight(),
            child: TIMWebView(
              initialUrl: 'https://comm.qq.com/login/captcha/index.html',
              width: getWidth(),
              height: getHeight(),
              webEventHandler: (name, body) {
                switch (name) {
                  case 'onLoading':
                    setState(() {
                      captchaStatus = CaptchaStatus.loading;
                    });
                    break;
                  case "onCaptchaReady":
                    final sdkView = body["opts"]["sdkView"];
                    width = sdkView["width"];
                    height = sdkView["height"];
                    setState(() {
                      captchaStatus = CaptchaStatus.ready;
                    });
                    break;
                  case "messageHandler":
                    try {
                      widget.onSuccess(body);
                      setState(() {
                        captchaStatus = CaptchaStatus.unReady;
                      });
                      if (!isClose) {
                        isClose = true;
                        widget.onClose();
                      }
                    } catch (err) {}

                    break;
                  case "capClose":
                    setState(() {
                      captchaStatus = CaptchaStatus.unReady;
                    });
                    if (!isClose) {
                      isClose = true;
                      widget.onClose();
                    }
                    break;
                }
              },
            ),
          ),
        ));
  }
}
