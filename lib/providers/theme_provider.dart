import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Color _seedColor = Colors.green;
  ThemeMode _themeMode = ThemeMode.light;


  Color get currentColor => _seedColor;
  ThemeMode get themeMode => _themeMode;

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

  void changeThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    // TODO: Lưu lựa chọn vào SharedPreferences
    notifyListeners();
  }

  String get currentThemeModeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Sáng';
      case ThemeMode.dark:
        return 'Tối';
      case ThemeMode.system:
        return 'Theo hệ thống';
      }
  }
}