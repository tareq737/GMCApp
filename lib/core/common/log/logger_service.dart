import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(), // Use PrettyPrinter for formatted logs
    level: kReleaseMode
        ? Level.warning
        : Level.debug, // Set the log level (debug, info, warning, error, etc.)
  );
  static final Queue<String> _logQueue = Queue<String>();
  static bool _isWriting = false;

  static void debug(String message) {
    _logger.d(message);
    _writeLogToFile("[DEBUG] $message");
  }

  static void info(String message) {
    _logger.i(message);
    _writeLogToFile("[INFO] $message");
  }

  static void warning(String message) {
    _logger.w(message);
    _writeLogToFile("[WARNING] $message");
  }

  static void error(String message, [dynamic error]) {
    _logger.e(message, error: error);
    _writeLogToFile(
        "[ERROR] $message${error != null ? '\nError: $error' : ''}");
  }

  static Future<File> getLogFile() async {
    Directory directory; // External storage
    if (Platform.isAndroid) {
      // Use external storage for Android
      directory = (await getExternalStorageDirectory())!;
    } else if (Platform.isIOS ||
        Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isWindows) {
      // Use application documents directory for iOS, Linux, macOS, and Windows
      directory = await getApplicationDocumentsDirectory();
    } else {
      // Fallback for other platforms
      throw UnsupportedError("Platform not supported for file logging.");
    }
    return File('${directory!.path}/app_logs.txt');
  }

  static Future<void> _writeLogToFile(String message) async {
    _logQueue.add(message);
    if (!_isWriting) {
      _isWriting = true;
      await _processQueue();
    }
  }

  static Future<void> _processQueue() async {
    while (_logQueue.isNotEmpty) {
      final message = _logQueue.removeFirst();
      try {
        final file = await getLogFile();
        await file.writeAsString('${DateTime.now()}: $message\n',
            mode: FileMode.append);
      } catch (e) {
        _logger.e("Failed to write log to file", error: e);
      }
    }
    _isWriting = false;
  }

  static void redirectPrint() {
    debugPrint = (String? message, {int? wrapWidth}) {
      LoggerService.info("PRINT: $message"); // Log print statements as INFO
    };
  }

  // try {
  //     final file = await getLogFile();
  //     const chunkSize = 1000;
  //     for (var i = 0; i < message.length; i += chunkSize) {
  //       final chunk = message.substring(
  //           i, i + chunkSize > message.length ? message.length : i + chunkSize);
  //       await file.writeAsString('${DateTime.now()}: $chunk\n',
  //           mode: FileMode.append);
  //     }
  //   } catch (e) {
  //     _logger.e("Failed to write log to file", error: e);
  //   }
  // }
}

class FileLogOutput extends LogOutput {
  final File file;

  FileLogOutput(this.file);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      file.writeAsStringSync('$line\n', mode: FileMode.append);
    }
  }
}
