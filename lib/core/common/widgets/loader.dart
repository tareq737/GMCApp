import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.blue
            : Colors.orange;
    return Center(child: SpinKitChasingDots(color: color, size: 50.0));
  }
}
