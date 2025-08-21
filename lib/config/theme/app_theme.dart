import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color greyText = Color(0xFFB8B8C6);
  static const Color primary = Color(0xFF13296A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF4D81E7);
  static const Color grey2 = Color.fromARGB(255, 221, 214, 214);
  static const Color darkBlue = Color(0xFF0A2A6E);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    textTheme: GoogleFonts.almaraiTextTheme(),
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      error: Colors.red,
      onError: AppColors.white,
      surface: AppColors.grey2,
      onSurface: AppColors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      hintStyle: TextStyle(color: AppColors.greyText),
    ),
  );
}
