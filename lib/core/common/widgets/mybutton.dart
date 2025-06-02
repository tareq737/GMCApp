import 'package:flutter/material.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';

class Mybutton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final void Function(BuildContext context)? onPressedwithCtx;
  final Widget? icon; // Optional icon widget

  const Mybutton({
    super.key,
    required this.text,
    this.onPressed,
    this.onPressedwithCtx,
    this.icon, // Include the icon in the constructor
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.gradient1, AppColors.gradient2]
              : [AppColors.lightGradient1, AppColors.lightGradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else if (onPressedwithCtx != null) {
            onPressedwithCtx!(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparentColor,
          shadowColor: AppColors.transparentColor,
          padding: EdgeInsets.zero,
          fixedSize: const Size(100, 40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            if (icon != null) ...[
              const SizedBox(height: 5),
            ],
            if (icon != null) ...[
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}
