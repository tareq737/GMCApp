// import 'package:flutter/material.dart';
// import 'package:gmcappclean/core/theme/app_colors.dart';

// class AppTheme {
//   static const EdgeInsets inputPadding = EdgeInsets.all(27);
//   static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));

//   static OutlineInputBorder _border({
//     Color color = AppColors.borderColor,
//     double width = 3.0,
//   }) =>
//       OutlineInputBorder(
//         borderRadius: borderRadius,
//         borderSide: BorderSide(
//           color: color,
//           width: width,
//         ),
//       );
//   static TextTheme customTextTheme(Color textColor) => TextTheme(
//         bodyLarge: TextStyle(
//           fontFamily: 'CustomFont',
//           fontSize: 16,
//           color: textColor,
//         ),
//         bodyMedium: TextStyle(
//           fontFamily: 'CustomFont',
//           fontSize: 14,
//           color: textColor,
//         ),
//         titleLarge: TextStyle(
//           fontFamily: 'CustomFont',
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: textColor,
//         ),
//       );
//   static final darkThemeMode = ThemeData.dark().copyWith(
//       scaffoldBackgroundColor: AppColors.backgroundColor,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: AppColors.backgroundColor,
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         contentPadding: inputPadding,
//         enabledBorder: _border(),
//         focusedBorder: _border(color: AppColors.gradient2),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.gradient2,
//         ),
//       ),
//       textTheme: customTextTheme(Colors.white));

//   static final lightThemeMode = ThemeData.light().copyWith(
//     scaffoldBackgroundColor: const Color(0xFFF0F0F0),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFFF0F0F0),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       contentPadding: inputPadding,
//       enabledBorder: _border(),
//       focusedBorder: _border(color: AppColors.gradient2),
//     ),
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: AppColors.gradient2,
//       ),
//     ),
//     textTheme: customTextTheme(Colors.black),
//   );
// }

import 'package:flutter/material.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';

class AppTheme {
  static const EdgeInsets inputPadding = EdgeInsets.all(27);
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));

  static OutlineInputBorder _border({
    Color color = AppColors.borderColor,
    double width = 3.0,
  }) =>
      OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );

  static TextTheme customTextTheme(Color textColor) => TextTheme(
        displayLarge: TextStyle(fontFamily: 'CustomFont', color: textColor),
        displayMedium: TextStyle(fontFamily: 'CustomFont', color: textColor),
        displaySmall: TextStyle(fontFamily: 'CustomFont', color: textColor),
        headlineLarge: TextStyle(fontFamily: 'CustomFont', color: textColor),
        headlineMedium: TextStyle(fontFamily: 'CustomFont', color: textColor),
        headlineSmall: TextStyle(fontFamily: 'CustomFont', color: textColor),
        titleLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titleMedium: TextStyle(fontFamily: 'CustomFont', color: textColor),
        titleSmall: TextStyle(fontFamily: 'CustomFont', color: textColor),
        bodyLarge: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 16,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 14,
          color: textColor,
        ),
        bodySmall: TextStyle(fontFamily: 'CustomFont', color: textColor),
        labelLarge: TextStyle(fontFamily: 'CustomFont', color: textColor),
        labelMedium: TextStyle(fontFamily: 'CustomFont', color: textColor),
        labelSmall: TextStyle(fontFamily: 'CustomFont', color: textColor),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: inputPadding,
      enabledBorder: _border(),
      focusedBorder: _border(color: AppColors.gradient2),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gradient2,
      ),
    ),
    textTheme: customTextTheme(Colors.white),
    // Apply font to all text widgets that might not use TextTheme
    primaryTextTheme: customTextTheme(Colors.white),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: const Color(0xFFF0F0F0),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF0F0F0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: inputPadding,
      enabledBorder: _border(),
      focusedBorder: _border(color: AppColors.gradient2),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gradient2,
      ),
    ),
    textTheme: customTextTheme(Colors.black),
    // Apply font to all text widgets that might not use TextTheme
    primaryTextTheme: customTextTheme(Colors.black),
  );
}
