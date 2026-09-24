import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B0F14);
  static const Color sidebar = Color(0xFF10161D);
  static const Color card = Color(0xFF151C24);
  static const Color primaryAccent = Color(0xFF4F7CFF);
  static const Color success = Color(0xFF3CCB8E);
  static const Color warning = Color(0xFFE5A84B);
  static const Color danger = Color(0xFFE05D6F);
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF98A2B3);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        secondary: primaryAccent,
        surface: card,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        titleTextStyle: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
