import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

void showSnackBar(String message) {
  scaffoldMessengerKey.currentState.removeCurrentSnackBar();
  scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
  ));
}