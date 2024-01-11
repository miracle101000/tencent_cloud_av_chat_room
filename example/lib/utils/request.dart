import 'package:dio/dio.dart';

Future<Response<Map<String, dynamic>>> appRequest({
  String? method = 'get',
  Map<String, dynamic>? params,
  required String path,
  dynamic data,
  required String baseUrl,
}) async {
  BaseOptions options = BaseOptions(
    baseUrl: baseUrl,
    method: method,
    sendTimeout: 6000,
    queryParameters: params,
  );
  try {
    return await Dio(options).request<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: params,
    );
  } on DioError catch (e) {
    // Server error 服务端问题
    if (e.response != null) {
      final option8 = e.message;
      return Response(data: {
        'errorCode': -99,
        'errorMessage': "服务器错误：$option8",
      }, requestOptions: e.requestOptions);
    } else {
      // Request error 请求时的问题
      final option8 = e.message;
      return Response(data: {
        'errorCode': -9,
        'errorMessage': "请求错误：$option8",
      }, requestOptions: e.requestOptions);
    }
  }
}
