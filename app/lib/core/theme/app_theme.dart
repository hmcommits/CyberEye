import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFCC), // Cyber Green / High Contrast
        secondary: Color(0xFFFF0055), // Alert Red
        surface: Color(0xFF121212),
        background: Color(0xFF0A0A0A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(fontFamily: 'Inter', color: Colors.white70),
      ),
    );
  }
}
