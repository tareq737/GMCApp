import 'package:flutter/material.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';

class AuthGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? child;

  const AuthGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.child,
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
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparentColor,
          shadowColor: AppColors.transparentColor,
          fixedSize: const Size(395, 55),
        ),
        child: child ??
            Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.whiteColor : Colors.black,
              ),
            ),
      ),
    );
  }
}
