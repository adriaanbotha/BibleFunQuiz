import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/gospel_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/instructions_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/which_screen_church.dart';
import 'globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globals.navigatorKey,
      title: globals.appName,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/gospel': (context) => const GospelScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/instructions': (context) => const InstructionsScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/whichchurch': (context) => const WhichScreenChurch(),
      },
    );
  }
}
