import 'package:control_style/control_style.dart';
import 'package:flutter/material.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';

class AnimatedShadowButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const AnimatedShadowButton({super.key, required this.text, this.onPressed});

  @override
  State<AnimatedShadowButton> createState() => _AnimatedShadowButtonState();
}

class _AnimatedShadowButtonState extends State<AnimatedShadowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<double> tween;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    tween = Tween<double>(begin: 0, end: 359);
    animation = controller.drive(tween);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
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
          height: 40,
          width: 150,
          child: TextButton(
            onPressed: widget.onPressed,
            style: TextButton.styleFrom(
              fixedSize: const Size(300, 50),
              shape: DecoratedOutlinedBorder(
                shadow: [
                  GradientShadow(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: _generateGradientColors(animation.value),
                      stops: _generateGradientStops(),
                    ),
                    offset: const Offset(-4, 4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
                child: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> _generateGradientColors(double offset) {
    List<Color> colors = [];
    const int divisions = 10;
    for (int i = 0; i < divisions; i++) {
      double hue = (360 / divisions) * i + offset;
      hue %= 360; // Ensure hue stays within 0-360
      colors.add(HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor());
    }
    colors.add(colors[0]);
    return colors;
  }

  List<double> _generateGradientStops() {
    return List.generate(11, (i) => i / 10);
  }
}
