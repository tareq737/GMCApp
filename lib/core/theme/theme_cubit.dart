import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gmcappclean/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeEvent { toggle }

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightThemeMode);

  void toggleTheme() async {
    emit(state.brightness == Brightness.dark
        ? AppTheme.lightThemeMode
        : AppTheme.darkThemeMode);
    final isDark = state.brightness == Brightness.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final theme = isDark ? AppTheme.darkThemeMode : AppTheme.lightThemeMode;
    emit(theme);
  }
}
