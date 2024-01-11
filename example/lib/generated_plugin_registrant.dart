//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_keyboard_visibility_web/flutter_keyboard_visibility_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:tencent_im_sdk_plugin_web/tencent_im_sdk_plugin_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FlutterKeyboardVisibilityPlugin.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  TencentImSDKPluginWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
