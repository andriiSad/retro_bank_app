import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode? get themeMode => _themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  // ignore: use_setters_to_change_properties
  void initThemeMode(ThemeMode themeMode) => _themeMode = themeMode;

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
