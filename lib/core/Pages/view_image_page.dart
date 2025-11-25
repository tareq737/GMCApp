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
      const String defaultName = 'image.jpg';

      final FileSaveLocation? location = await getSaveLocation(
        suggestedName: defaultName,
        acceptedTypeGroups: [
          const XTypeGroup(label: 'Images', extensions: ['jpg', 'png']),
        ],
      );

      if (location == null) return;

      String path = location.path;

      // التحقق من وجود الامتداد
      if (!path.toLowerCase().endsWith('.jpg') &&
          !path.toLowerCase().endsWith('.png')) {
        path = '$path.jpg'; // إضافة الامتداد الافتراضي
      }

      final savedFile = File(path);
      await savedFile.writeAsBytes(imageData);

      showSnackBar(
        context: context,
        content: 'تم حفظ الصورة في: $path',
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
        body: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(1),
          minScale: 1,
          maxScale: 5,
          child: SizedBox.expand(
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
