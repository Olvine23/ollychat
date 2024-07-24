import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String _key = 'themeMode';

  Future<void> saveThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mode = prefs.getString(_key);
    if (mode != null) {
      return ThemeMode.values.firstWhere((e) => e.toString() == mode);
    }
    return ThemeMode.system;
  }
}
