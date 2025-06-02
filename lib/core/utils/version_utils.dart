import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUtils {
  static Future<String> getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  static bool isVersionLower(String v1, String v2) {
    List<int> p1 = v1.split('.').map(int.parse).toList();
    List<int> p2 = v2.split('.').map(int.parse).toList();
    final length = max(p1.length, p2.length);

    for (int i = 0; i < length; i++) {
      final a = i < p1.length ? p1[i] : 0;
      final b = i < p2.length ? p2[i] : 0;
      if (a < b) return true;
      if (a > b) return false;
    }
    return false;
  }

  static void showForceUpdateDialog(
      BuildContext context, String apkUrl, String message, String changelog) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl, // This makes the content RTL
        child: AlertDialog(
          title: const Row(
            children: [
              FaIcon(FontAwesomeIcons.exclamationTriangle,
                  color: Colors.orange),
              SizedBox(width: 12),
              Text(
                'تحديث مطلوب',
                textDirection: TextDirection.rtl, // Explicit RTL for text
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align to end for RTL
            children: [
              const Text(
                'ما الجديد:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 5),
              Text(
                changelog,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(apkUrl))) {
                  await launchUrl(Uri.parse(apkUrl),
                      mode: LaunchMode.externalApplication);
                }
                SystemNavigator.pop(); // Exit app
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('حدث الآن', textDirection: TextDirection.rtl),
                  SizedBox(width: 8),
                  FaIcon(FontAwesomeIcons.download, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> showOptionalUpdateDialog(BuildContext context,
      String apkUrl, String message, String changelog) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Row(
            children: [
              FaIcon(FontAwesomeIcons.bell, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'تحديث متاح',
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align to end for RTL
            children: [
              const Text(
                'ما الجديد:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 5),
              Text(
                changelog,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false for "Later"
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('لاحقاً', textDirection: TextDirection.rtl),
                  SizedBox(width: 8),
                  FaIcon(FontAwesomeIcons.clock, size: 16),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Return true for "Update"
                if (await canLaunchUrl(Uri.parse(apkUrl))) {
                  await launchUrl(Uri.parse(apkUrl),
                      mode: LaunchMode.externalApplication);
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('حدث الآن', textDirection: TextDirection.rtl),
                  SizedBox(width: 8),
                  FaIcon(FontAwesomeIcons.download, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((value) => value ?? false);
  }
}
