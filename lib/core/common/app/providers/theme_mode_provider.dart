import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode? get themeMode => _themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void initThemeMode() {
    _themeMode = ThemeMode.light;
  }

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
