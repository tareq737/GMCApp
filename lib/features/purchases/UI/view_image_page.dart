import 'dart:typed_data';

import 'package:flutter/material.dart';

class ViewImagePage extends StatelessWidget {
  final Uint8List imageData;
  const ViewImagePage({super.key, required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(1),
            minScale: 1,
            maxScale: 5,
            child: Image.memory(
              imageData,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
