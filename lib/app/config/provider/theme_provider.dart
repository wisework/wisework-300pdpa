import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/config/themes/pdpa_theme_data.dart';
import 'package:pdpa/app/shared/utils/user_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = PdpaThemeData.lightThemeData;

  ThemeData get currentTheme => _currentTheme;

  ThemeProvider(bool isDarkMode) {
    _currentTheme =
        isDarkMode ? PdpaThemeData.darkThemeData : PdpaThemeData.lightThemeData;
  }

  void setLightTheme() {
    _currentTheme = PdpaThemeData.lightThemeData;
    UserPreferences.setBool(AppPreferences.isDarkMode, false);

    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = PdpaThemeData.darkThemeData;
    UserPreferences.setBool(AppPreferences.isDarkMode, true);

    notifyListeners();
  }

  void toggleTheme() {
    if (_currentTheme == PdpaThemeData.lightThemeData) {
      _currentTheme = PdpaThemeData.darkThemeData;
      UserPreferences.setBool(AppPreferences.isDarkMode, true);
    } else {
      _currentTheme = PdpaThemeData.lightThemeData;
      UserPreferences.setBool(AppPreferences.isDarkMode, false);
    }

    notifyListeners();
  }
}
