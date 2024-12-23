import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String content,
  required Color backgroundColor,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(color: Colors.white), // Optional: Set text style
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.2,
        right: MediaQuery.of(context).size.width * 0.2,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
    ),
  );
}
