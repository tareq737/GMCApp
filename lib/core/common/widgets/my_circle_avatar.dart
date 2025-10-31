// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  final String text;

  const MyCircleAvatar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return CircleAvatar(
      backgroundColor: isDark ? Colors.blue : Colors.white,
      foregroundColor: isDark ? Colors.white : Colors.orange, // Text color
      radius: 14,
      child: AutoSizeText(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white : Colors.orange,
        ),
        minFontSize: 8,
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
