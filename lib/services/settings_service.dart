import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferences _prefs;
  bool _initialized = false;

  // Default settings
  static const bool DEFAULT_SOUND_ENABLED = true;
  static const bool DEFAULT_LIVES_ENABLED = true;
  static const int DEFAULT_NUMBER_OF_LIVES = 5;
  static const bool DEFAULT_TIMER_ENABLED = true;
  static const int DEFAULT_TIME_PER_QUESTION = 30;
  static const bool DEFAULT_SHOW_REFERENCES = true;
  static const bool DEFAULT_RANDOMIZE_QUESTIONS = true;
  static const int DEFAULT_QUESTION_COUNT = 25;
  static const String DEFAULT_DIFFICULTY = 'beginner';

  // Keys for SharedPreferences
  static const String KEY_SOUND_ENABLED = 'sound_enabled';
  static const String KEY_LIVES_ENABLED = 'lives_enabled';
  static const String KEY_NUMBER_OF_LIVES = 'number_of_lives';
  static const String KEY_TIMER_ENABLED = 'timer_enabled';
  static const String KEY_TIME_PER_QUESTION = 'time_per_question';
  static const String KEY_SHOW_REFERENCES = 'show_references';
  static const String KEY_RANDOMIZE_QUESTIONS = 'randomize_questions';
  static const String KEY_QUESTION_COUNT = 'question_count';
  static const String KEY_DIFFICULTY = 'difficulty';

  // Initialize SharedPreferences
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Sound settings
  Future<bool> getSoundEnabled() async {
    await init();
    return _prefs.getBool(KEY_SOUND_ENABLED) ?? DEFAULT_SOUND_ENABLED;
  }

  Future<void> setSoundEnabled(bool value) async {
    await init();
    await _prefs.setBool(KEY_SOUND_ENABLED, value);
  }

  // Lives settings
  Future<bool> getLivesEnabled() async {
    await init();
    return _prefs.getBool(KEY_LIVES_ENABLED) ?? DEFAULT_LIVES_ENABLED;
  }

  Future<void> setLivesEnabled(bool value) async {
    await init();
    await _prefs.setBool(KEY_LIVES_ENABLED, value);
  }

  Future<int> getNumberOfLives() async {
    await init();
    return _prefs.getInt(KEY_NUMBER_OF_LIVES) ?? DEFAULT_NUMBER_OF_LIVES;
  }

  Future<void> setNumberOfLives(int value) async {
    await init();
    await _prefs.setInt(KEY_NUMBER_OF_LIVES, value);
  }

  // Timer settings
  Future<bool> getTimerEnabled() async {
    await init();
    return _prefs.getBool(KEY_TIMER_ENABLED) ?? DEFAULT_TIMER_ENABLED;
  }

  Future<void> setTimerEnabled(bool value) async {
    await init();
    await _prefs.setBool(KEY_TIMER_ENABLED, value);
  }

  Future<int> getTimePerQuestion() async {
    await init();
    return _prefs.getInt(KEY_TIME_PER_QUESTION) ?? DEFAULT_TIME_PER_QUESTION;
  }

  Future<void> setTimePerQuestion(int value) async {
    await init();
    await _prefs.setInt(KEY_TIME_PER_QUESTION, value);
  }

  // Reference settings
  Future<bool> getShowReferences() async {
    await init();
    return _prefs.getBool(KEY_SHOW_REFERENCES) ?? DEFAULT_SHOW_REFERENCES;
  }

  Future<void> setShowReferences(bool value) async {
    await init();
    await _prefs.setBool(KEY_SHOW_REFERENCES, value);
  }

  // Question settings
  Future<bool> getRandomizeQuestions() async {
    await init();
    return _prefs.getBool(KEY_RANDOMIZE_QUESTIONS) ?? DEFAULT_RANDOMIZE_QUESTIONS;
  }

  Future<void> setRandomizeQuestions(bool value) async {
    await init();
    await _prefs.setBool(KEY_RANDOMIZE_QUESTIONS, value);
  }

  Future<int> getQuestionCount() async {
    await init();
    return _prefs.getInt(KEY_QUESTION_COUNT) ?? DEFAULT_QUESTION_COUNT;
  }

  Future<void> setQuestionCount(int value) async {
    await init();
    await _prefs.setInt(KEY_QUESTION_COUNT, value);
  }

  // Difficulty settings
  Future<String> getDifficulty() async {
    await init();
    return _prefs.getString(KEY_DIFFICULTY) ?? DEFAULT_DIFFICULTY;
  }

  Future<void> setDifficulty(String value) async {
    await init();
    await _prefs.setString(KEY_DIFFICULTY, value);
  }

  // Reset all settings to defaults
  Future<void> resetToDefaults() async {
    await init();
    await setSoundEnabled(DEFAULT_SOUND_ENABLED);
    await setLivesEnabled(DEFAULT_LIVES_ENABLED);
    await setNumberOfLives(DEFAULT_NUMBER_OF_LIVES);
    await setTimerEnabled(DEFAULT_TIMER_ENABLED);
    await setTimePerQuestion(DEFAULT_TIME_PER_QUESTION);
    await setShowReferences(DEFAULT_SHOW_REFERENCES);
    await setRandomizeQuestions(DEFAULT_RANDOMIZE_QUESTIONS);
    await setQuestionCount(DEFAULT_QUESTION_COUNT);
    await setDifficulty(DEFAULT_DIFFICULTY);
  }

  Future<int> getQuestionsPerQuiz() async {
    return getQuestionCount();
  }

  Future<void> setQuestionsPerQuiz(int value) async {
    await setQuestionCount(value);
  }
} 