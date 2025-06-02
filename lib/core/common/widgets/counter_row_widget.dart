import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CounterRow extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterRow({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          side: const BorderSide(
            color: Colors.grey, // Stroke color (border)
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 12,
                child: Text(label,
                    style: const TextStyle(
                      fontSize: 10,
                    )),
              ),
              Row(
                spacing: 8,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onIncrement,
                      icon: const Icon(
                        Icons.add_circle,
                        size: 20,
                      ),
                    ),
                  ),
                  AutoSizeText('$value',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10)),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onDecrement,
                      icon: const Icon(
                        Icons.remove_circle,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
