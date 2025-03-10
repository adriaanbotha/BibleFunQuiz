import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Globals {
  static int playerLevel = 1;
  static int playerXP = 0;
  static int scrolls = 0;
  static List<Map<String, dynamic>> leaderboard = [];
  static String? currentUsername;
  static String? currentEmail;
  static String? authToken;

  static Future<void> loadPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    playerLevel = prefs.getInt('playerLevel') ?? 1;
    playerXP = prefs.getInt('playerXP') ?? 0;
    scrolls = prefs.getInt('scrolls') ?? 0;
    currentUsername = prefs.getString('username');
    currentEmail = prefs.getString('email');
    authToken = prefs.getString('authToken');
  }

  static Future<void> savePlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('playerLevel', playerLevel);
    await prefs.setInt('playerXP', playerXP);
    await prefs.setInt('scrolls', scrolls);
    if (currentUsername != null)
      await prefs.setString('username', currentUsername!);
    if (currentEmail != null) await prefs.setString('email', currentEmail!);
    if (authToken != null) await prefs.setString('authToken', authToken!);
  }

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static Future<void> loadLeaderboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final leaderboardData = prefs.get('leaderboard');
      if (leaderboardData is List<dynamic>) {
        final leaderboardString = leaderboardData.cast<String>();
        leaderboard = leaderboardString.map((e) {
          final parts = e.split(':');
          return {
            'name': parts[0],
            'score': int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
          };
        }).toList();
      } else if (leaderboardData is String) {
        final parts = leaderboardData.split(':');
        leaderboard = [
          {
            'name': parts[0],
            'score': int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
          }
        ];
        await saveLeaderboard();
      } else {
        leaderboard = [];
      }
    } catch (e, stackTrace) {
      print('Error loading leaderboard: $e');
      print('Stack trace: $stackTrace');
      leaderboard = [];
    }
  }

  static Future<void> saveLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboardString =
        leaderboard.map((e) => '${e['name']}:${e['score']}').toList();
    await prefs.setStringList('leaderboard', leaderboardString);
  }

  static void updateLeaderboard(String name, int score) {
    leaderboard.add({'name': name, 'score': score});
    leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
    if (leaderboard.length > 10) leaderboard = leaderboard.sublist(0, 10);
  }
}
