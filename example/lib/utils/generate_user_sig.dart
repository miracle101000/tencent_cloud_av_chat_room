// ignore: file_names
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:example/utils/request.dart';

class GenerateUserSig {
  static Future<Map<String, dynamic>> generateUserSig(String userID) async {
    Response<Map<String, dynamic>> data = await appRequest(
        baseUrl:
            'https://service-nglrzmfe-1258710235.gz.apigw.tencentcs.com/release/',
        path: "",
        method: "post",
        data: <String, dynamic>{"userID": userID});
    Map<String, dynamic> res = data.data!;
    return res;
  }
}
