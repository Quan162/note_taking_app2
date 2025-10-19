import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Color _seedColor = Colors.green;

  ThemeData get currentTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          foregroundColor: Colors.grey[800],
        ),
      );

  void changeThemeColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }
}