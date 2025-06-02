// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gmcappclean/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalDataSource {
  Future<bool> saveSession({required UserModel user});
  Future<bool> clearSession();
  UserModel? get getUserTokens;
}

class SharedPrefsDataSourceImpl implements LocalDataSource {
  final SharedPreferences prefs;
  SharedPrefsDataSourceImpl(this.prefs);

  @override
  UserModel? get getUserTokens {
    if (prefs.getBool('savedUser') ?? false) {
      final accessToken = _loadAccessToken();
      final refreshToken = _loadRefreshToken();
      final firstName = prefs.getString('firstName');
      final lastName = prefs.getString('lastName');
      final groups = prefs.getStringList('groups');
      if (accessToken is String && refreshToken is String) {
        print('f local data sourece ${firstName}');
        return UserModel(
          accessToken: accessToken,
          refreshToken: refreshToken,
          firstName: firstName,
          lastName: lastName,
          groups: groups,
        );
      }
    }
    return null;
  }

  String? _loadAccessToken() {
    return prefs.getString('access');
  }

  String? _loadRefreshToken() {
    return prefs.getString('refresh');
  }

  Future<bool> _saveAccessToken({required String token}) async {
    try {
      await prefs.setString('access', token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _saveRefreshToken({required String token}) async {
    try {
      await prefs.setString('refresh', token);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveSession({required UserModel user}) async {
    try {
      await _saveAccessToken(token: user.accessToken);
      await _saveRefreshToken(token: user.refreshToken);
      await prefs.setString('firstName', user.firstName ?? '%');
      await prefs.setString('lastName', user.lastName ?? '%');
      await prefs.setStringList('groups', user.groups ?? []);
      await prefs.setBool('savedUser', true);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearSession() async {
    try {
      await prefs.setBool('savedUser', false);
      await prefs.remove('access');
      await prefs.remove('refresh');
      await prefs.remove('firstName');
      await prefs.remove('lastName');
      await prefs.remove('groups');
      return true;
    } catch (e) {
      return false;
    }
  }
}
