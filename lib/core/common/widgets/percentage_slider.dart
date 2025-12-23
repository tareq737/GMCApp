import 'package:flutter/material.dart';

class PercentageSlider extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<double> onChanged;

  const PercentageSlider({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Safely parse the value, falling back to 50.0 if empty/invalid.
    // 2. Ensure the value is at least 1.0 (the minimum slider value).
    final parsedValue = double.tryParse(controller.text) ?? 50.0;
    final value = parsedValue < 1.0 ? 1.0 : parsedValue; // <-- FIX applied here

    final text = controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $text%',
        ),
        Slider(
          value: value,
          min: 1,
          max: 100,
          divisions: 99,
          label: "${value.round()}%",
          onChanged: onChanged,
        ),
      ],
    );
  }
}
