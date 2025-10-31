import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';

class ViewImagePage extends StatelessWidget {
  final Uint8List imageData;
  const ViewImagePage({super.key, required this.imageData});

  Future<void> _saveImage(BuildContext context) async {
    try {
      const String fileName = 'image.jpg';

      final FileSaveLocation? file = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: [
          const XTypeGroup(label: 'Images', extensions: ['jpg', 'png']),
        ],
      );

      if (file == null) return;

      final savedFile = File(file.path);
      await savedFile.writeAsBytes(imageData);

      showSnackBar(
        context: context,
        content: 'تم حفظ الصورة في: ${file.path}',
        failure: false,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: 'حدث خطأ أثناء حفظ الصورة: $e',
        failure: true,
      );
    }
  }

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
        floatingActionButton: Platform.isWindows
            ? FloatingActionButton(
                onPressed: () => _saveImage(context),
                tooltip: 'حفظ الصورة',
                child: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }
}
