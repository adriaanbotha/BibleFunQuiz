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

  // Add these new methods
  Future<int> getQuestionsPerQuiz() async {
    return _prefs.getInt('questions_per_quiz') ?? 10; // Default to 10 questions
  }

  Future<bool> getShowReferences() async {
    return _prefs.getBool('show_references') ?? true; // Default to showing references
  }

  Future<void> setQuestionsPerQuiz(int value) async {
    await _prefs.setInt('questions_per_quiz', value);
  }

  Future<void> setShowReferences(bool value) async {
    await _prefs.setBool('show_references', value);
  }

  Future<bool> getSoundEnabled() async {
    return _prefs.getBool('sound_enabled') ?? true;
  }

  Future<void> setSoundEnabled(bool value) async {
    await _prefs.setBool('sound_enabled', value);
  }

  // Add these methods for lives settings
  Future<bool> getLivesEnabled() async {
    return _prefs.getBool('lives_enabled') ?? true;
  }

  Future<void> setLivesEnabled(bool value) async {
    await _prefs.setBool('lives_enabled', value);
  }

  Future<int> getNumberOfLives() async {
    return _prefs.getInt('number_of_lives') ?? 3;
  }

  Future<void> setNumberOfLives(int value) async {
    await _prefs.setInt('number_of_lives', value);
  }

  // Add timer settings
  Future<int> getTimePerQuestion() async {
    return _prefs.getInt('time_per_question') ?? 30; // Default 30 seconds
  }

  Future<void> setTimePerQuestion(int value) async {
    await _prefs.setInt('time_per_question', value);
  }
} 