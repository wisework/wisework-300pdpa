import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<SharedPreferences> getInstance() async {
    return SharedPreferences.getInstance();
  }

  static Future<void> setBool(String key, bool value) async {
    final pref = await getInstance();
    pref.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final pref = await getInstance();
    return pref.getBool(key);
  }

  static Future<void> setDouble(String key, double value) async {
    final pref = await getInstance();
    pref.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final pref = await getInstance();
    return pref.getDouble(key);
  }

  static Future<void> setInt(String key, int value) async {
    final pref = await getInstance();
    pref.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final pref = await getInstance();
    return pref.getInt(key);
  }

  static Future<void> setString(String key, String value) async {
    final pref = await getInstance();
    pref.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final pref = await getInstance();
    return pref.getString(key);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    final pref = await getInstance();
    pref.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    final pref = await getInstance();
    return pref.getStringList(key);
  }
}
