import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularPercentage extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const CircularPercentage({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  Future<void> _showValueDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController(
      text: value.round().toString(),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('حدد قيمة $label'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'القيمة (0-100)',
              suffixText: '%',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onSubmitted: (value) {
              final newValue = double.tryParse(value);
              if (newValue != null && newValue >= 0 && newValue <= 100) {
                Navigator.pop(context, newValue);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  final newValue = double.tryParse(text);
                  if (newValue != null && newValue >= 0 && newValue <= 100) {
                    Navigator.pop(context, newValue);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please enter a valid number between 0 and 100'),
                      ),
                    );
                  }
                }
              },
              child: const Text('موافق'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Using InkWell for better visual feedback
        InkWell(
          onTap: () => _showValueDialog(context),
          borderRadius: BorderRadius.circular(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularPercentIndicator(
              progressColor: color,
              radius: 50,
              lineWidth: 8,
              percent: (value / 100).clamp(0, 1),
              center: Text(
                "${value.round()}%",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          label: "${value.round()}%",
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }
}
