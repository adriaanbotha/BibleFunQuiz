import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  // Game Settings
  bool get showLives => _prefs.getBool('show_lives') ?? true;
  bool get showTimer => _prefs.getBool('show_timer') ?? true;
  bool get soundEnabled => _prefs.getBool('sound_enabled') ?? true;
  bool get darkTheme => _prefs.getBool('dark_theme') ?? false;
  bool get randomizeQuestions => _prefs.getBool('randomize') ?? true;
  int get questionQuantity => _prefs.getInt('question_quantity') ?? 10;
  bool get offlineMode => _prefs.getBool('offline_mode') ?? false;
  
  // Kids Mode Settings
  String get kidsAgeGroup => _prefs.getString('kids_age_group') ?? '8-11';
  bool get kidsMode => _prefs.getBool('kids_mode') ?? false;

  // Quiz Categories
  List<String> get selectedCategories {
    return _prefs.getStringList('selected_categories') ?? 
        ['Old Testament', 'New Testament'];
  }

  // Add this method to safely get settings
  dynamic getSetting(String key) {
    return _prefs.get(key);
  }

  // Setters
  Future<void> updateSetting(String key, dynamic value) async {
    if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }
} 