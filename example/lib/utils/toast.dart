import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 20,
      backgroundColor: Colors.black,
    );
  }

  static void toastError(int code, String desc) {
    Fluttertoast.showToast(
      msg: "code:$code,desc:$desc",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 20,
      backgroundColor: Colors.black,
    );
  }

  static void log(Object? data) {
    bool prod =
        const bool.fromEnvironment('ISPRODUCT_ENV', defaultValue: false);
    if (!prod) {
      // ignore: avoid_print
      print("===================================");
      // ignore: avoid_print
      print("IM_DEMO_PRINT:$data");
      // ignore: avoid_print
      print("===================================");
    } else {}
  }
}
