import 'package:flutter/material.dart';
import 'package:pdpa/app/config/themes/pdpa_theme_data.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = PdpaThemeData.lightThemeData;

  ThemeData get currentTheme => _currentTheme;

  void setLightTheme() {
    _currentTheme = PdpaThemeData.lightThemeData;
    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = PdpaThemeData.darkThemeData;
    notifyListeners();
  }

  void toggleTheme() {
    _currentTheme = (_currentTheme == PdpaThemeData.lightThemeData)
        ? PdpaThemeData.darkThemeData
        : PdpaThemeData.lightThemeData;
    notifyListeners();
  }
}
