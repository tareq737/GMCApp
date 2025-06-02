import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
  required bool failure,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: failure
                  ? [
                      Colors.red.shade800,
                      Colors.red.shade400,
                      Colors.red.shade800
                    ] // أحمر غامق - أحمر فاتح - أحمر غامق
                  : [
                      Colors.green.shade800,
                      Colors.green.shade400,
                      Colors.green.shade800
                    ], // أخضر غامق - أخضر فاتح - أخضر غامق
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [
                0.0,
                0.5,
                1.0
              ], // تحديد موقع الألوان (الأطراف غامقة، المنتصف فاتح)
            ),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.25,
          right: MediaQuery.of(context).size.width * 0.25,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        backgroundColor:
            Colors.transparent, // إزالة اللون الافتراضي للسماح بالتدرج
        elevation: 0, // إزالة الظل للحصول على مظهر أنظف
      ),
    );
}
