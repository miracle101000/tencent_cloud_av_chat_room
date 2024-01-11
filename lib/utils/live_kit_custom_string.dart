import 'dart:convert';

class LiveKitCustomString {
  static bool isLiveKitCloudCustomData(String? cloudCustomData) {
    if (cloudCustomData == null) {
      return false;
    }
    try {
      final customData = jsonDecode(cloudCustomData) as Map;
      final haveCorrectBusinessID = customData.containsKey('businessID') &&
          customData['businessID'] == 'flutter_live_kit';
      final haveData = customData.containsKey('data');
      return haveCorrectBusinessID && haveData;
    } catch (error) {
      return false;
    }
  }

  static String getCmd(String cloudCustomData) {
    try {
      final customData = jsonDecode(cloudCustomData) as Map;
      final data = customData['data'] as Map;
      return data['cmd'];
    } catch (error) {
      return "";
    }
  }

  static Map getCmdInfo(String cloudCustomData) {
    try {
      final customData = jsonDecode(cloudCustomData) as Map;
      final data = customData['data'] as Map;
      return data['cmdInfo'] as Map;
    } catch (error) {
      return {};
    }
  }
}
