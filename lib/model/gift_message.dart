class LiveKitCustomMessagee {
  LiveKitCustomMessagee({
    required this.businessID,
    required this.data,
    this.platform,
    this.version,
  });

  double? version;
  String? platform;
  late String businessID;
  late LiveKitCustomMessageData data;

  LiveKitCustomMessagee.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('version')) {
      version = json['version'];
    }
    if (json.containsKey('platform')) {
      platform = json['platform'];
    }
    if (json.containsKey('businessID')) {
      businessID = json['businessID'];
    }
    if (json.containsKey('data')) {
      data = LiveKitCustomMessageData.fromJson(json['data']);
    }
  }

  toJson() {
    final Map<String, dynamic> responseData = <String, dynamic>{};
    if (version != null) {
      responseData['version'] = version;
    }
    if (platform != null) {
      responseData['platform'] = platform;
    }
    responseData['businessID'] = businessID;
    responseData['data'] = data.toJson();
    return responseData;
  }
}

class LiveKitCustomMessageData {
  LiveKitCustomMessageData({required this.cmd, required this.cmdInfo});

  late String cmd;
  late Object cmdInfo;

  LiveKitCustomMessageData.fromJson(Map<String, dynamic> json) {
    cmd = json['cmd'];
    cmdInfo = json['cmdInfo'];
  }

  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cmd'] = cmd;
    data['cmdInfo'] = cmdInfo;
    return data;
  }
}
