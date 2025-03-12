import 'package:flutter/material.dart';
import '../services/upstash_service.dart' as upstash;

const Color primaryColor = Color(0xFF2E7D32);
const Color accentColor = Color(0xFFFFC107);
const String appName = 'Bible Quest';

String? currentUserId;
String? currentUsername;
String? currentEmail;
String? currentNickname;
String? authToken;
bool isLoggedIn = false;

int currentScore = 0;
int highScore = 0;
List<String> completedQuizzes = [];
const int maxQuizQuestions = 10;

const String baseApiUrl = 'https://relative-bison-60370.upstash.io';
const String upstashRedisUrl = 'https://relative-bison-60370.upstash.io';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void resetGameState() {
  currentScore = 0;
  completedQuizzes.clear();
}

void updateHighScore(int score) {
  if (score > highScore) {
    highScore = score;
  }
}

Future<void> loadPlayerData() async {
  if (currentEmail != null) {
    final data = await upstash.UpstashService.loadPlayerData(currentEmail!);
    if (data != null) {
      currentUsername = data['username'];
      currentEmail = data['email'];
      currentNickname = data['nickname'];
      authToken = data['authToken'];
      isLoggedIn = true;
    }
  }
}

Future<void> savePlayerData() async {
  if (currentUsername != null && currentEmail != null && authToken != null) {
    // Fetch existing data to preserve the password
    final existingData =
        await upstash.UpstashService.loadPlayerData(currentEmail!);
    String? existingPassword = existingData?['password'];

    await upstash.UpstashService.savePlayerData(
      username: currentUsername!,
      email: currentEmail!,
      authToken: authToken!,
      nickname: currentNickname,
      password: existingPassword, // Preserve the existing password
    );
  } else {
    print('Error: Missing player data to save');
  }
}

Future<void> loadLeaderboard() async {
  await upstash.UpstashService.loadLeaderboard();
}
