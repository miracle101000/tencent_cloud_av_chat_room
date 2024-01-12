//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_keyboard_visibility/FlutterKeyboardVisibilityPlugin.h>)
#import <flutter_keyboard_visibility/FlutterKeyboardVisibilityPlugin.h>
#else
@import flutter_keyboard_visibility;
#endif

#if __has_include(<fluttertoast/FluttertoastPlugin.h>)
#import <fluttertoast/FluttertoastPlugin.h>
#else
@import fluttertoast;
#endif

#if __has_include(<live_flutter_plugin/TencentLiveCloudPlugin.h>)
#import <live_flutter_plugin/TencentLiveCloudPlugin.h>
#else
@import live_flutter_plugin;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<tencent_cloud_chat_sdk/TencentImSDKPlugin.h>)
#import <tencent_cloud_chat_sdk/TencentImSDKPlugin.h>
#else
@import tencent_cloud_chat_sdk;
#endif

#if __has_include(<webview_flutter_wkwebview/FLTWebViewFlutterPlugin.h>)
#import <webview_flutter_wkwebview/FLTWebViewFlutterPlugin.h>
#else
@import webview_flutter_wkwebview;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterKeyboardVisibilityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterKeyboardVisibilityPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [TencentLiveCloudPlugin registerWithRegistrar:[registry registrarForPlugin:@"TencentLiveCloudPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [TencentImSDKPlugin registerWithRegistrar:[registry registrarForPlugin:@"TencentImSDKPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
