import 'package:shared_preferences/shared_preferences.dart';

class SettingsUtil {
  static Future<Map<String, dynamic>> loadSettings() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    return await prefs.getAll();
  }

  static Future<List<String>?> loadHomeApps() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    return await prefs.getStringList('homeApps');
  }
}