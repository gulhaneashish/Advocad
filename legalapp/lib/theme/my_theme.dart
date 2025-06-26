import 'package:flutter/material.dart';

class MyThemes {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.teal[800]!,
    ),
    textTheme: _lightTextTheme,
    appBarTheme: _lightAppBarTheme,
    elevatedButtonTheme: _buttonTheme(Colors.black),
    inputDecorationTheme: _inputDecorationTheme(Colors.black),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.teal[300]!,
    ),
    textTheme: _darkTextTheme,
    appBarTheme: _darkAppBarTheme,
    elevatedButtonTheme: _buttonTheme(Colors.white),
    inputDecorationTheme: _inputDecorationTheme(Colors.white),
  );

  // Light Text Theme
  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
  );

  // Dark Text Theme
  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
  );

  // Light AppBar Theme
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  );

  // Dark AppBar Theme
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  );

  // Button Theme
  static ElevatedButtonThemeData _buttonTheme(Color color) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  // Input Field Theme
  static InputDecorationTheme _inputDecorationTheme(Color color) {
    return InputDecorationTheme(
      filled: true,
      fillColor: color.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 2),
      ),
      hintStyle: TextStyle(color: color.withOpacity(0.7)),
    );
  }
}
