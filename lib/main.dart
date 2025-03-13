import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/instructions_screen.dart';
import 'screens/which_church_screen.dart';
import 'screens/gospel_screen.dart';
import 'screens/donate_screen.dart';
import 'screens/login_screen.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);

  runApp(MyApp(settingsService: settingsService));
}

class MyApp extends StatelessWidget {
  final SettingsService settingsService;

  const MyApp({Key? key, required this.settingsService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globals.navigatorKey,
      title: globals.appName,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF9800),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9800)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => SettingsScreen(settingsService: settingsService),
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/instructions': (context) => const InstructionsScreen(),
        '/which-church': (context) => const WhichChurchScreen(),
        '/gospel': (context) => const GospelScreen(),
        '/donate': (context) => const DonateScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
