import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmcappclean/core/common/secrets/app_secrets.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/core/utils/version_utils.dart';

class VersionChecker {
  static Future<bool> check(BuildContext context,
      {bool notifyIfLatest = false}) async {
    const String url =
        'https://${AppSecrets.ip}:${AppSecrets.port}/api/version-info';
    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final currentVersion = await VersionUtils.getCurrentVersion();

        final requiredVersion = data['required_version'] ?? '1.0.0';
        final latestVersion = data['latest_version'] ?? requiredVersion;
        final changelog = data['changelog'] ?? '';
        final apkUrl = data['latest_apk_url'] ?? '';
        final message = data['message'] ?? 'يرجى تحديث التطبيق';

        if (VersionUtils.isVersionLower(currentVersion, requiredVersion)) {
          VersionUtils.showForceUpdateDialog(
              context, apkUrl, message, changelog);
          return false;
        } else if (VersionUtils.isVersionLower(currentVersion, latestVersion)) {
          final shouldUpdate = await VersionUtils.showOptionalUpdateDialog(
              context, apkUrl, message, changelog);
          return !shouldUpdate;
        } else {
          if (notifyIfLatest) {
            Navigator.pop(context);
            showSnackBar(
              context: context,
              content: 'أنت تستخدم أحدث إصدار من التطبيق.',
              failure: false,
            );
          }
          return true;
        }
      } else {
        showSnackBar(
            context: context, content: 'فشل التحقق من الإصدار.', failure: true);
        return false;
      }
    } catch (e) {
      showSnackBar(
          context: context, content: 'فشل التحقق من الإصدار.', failure: true);
      return false;
    }
  }
}
