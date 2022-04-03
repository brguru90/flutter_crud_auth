import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void FlutterToastTemplate(
      {required msg, fg_color = Colors.white, bg_color = Colors.deepOrange}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: bg_color,
        textColor: fg_color,
        fontSize: 16.0);
  }

  static void error(msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.red);
  }

  static void info(msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.blueAccent[700]);
  }

  static void success(msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.green[700]);
  }

  static void warning(msg) {
    FlutterToastTemplate(msg: msg, bg_color: Colors.amber[500]);
  }
}
