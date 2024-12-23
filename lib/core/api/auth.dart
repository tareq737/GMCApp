// auth_config.dart
import 'dart:convert';

const String apiUsername = 'gmc.org';
const String apiPassword = 'm7@Wx^zK#Q9T!gV8r^L3*pJd^bY1U&eF5(4NtX)';
final basicAuth =
    'Basic ${base64Encode(utf8.encode('$apiUsername:$apiPassword'))}';
