import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/upstash_service.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // Comment out for production
  await globals.Globals.loadLeaderboard();
  await globals.Globals.loadPlayerData();
  final upstashService = UpstashService();
  final token = prefs.getString('authToken');
  final isLoggedIn =
      token != null && await upstashService.validateToken(token) != null;
  runApp(BibleQuestApp(
      initialRoute: isLoggedIn ? const HomeScreen() : const LoginScreen()));
}

class BibleQuestApp extends StatelessWidget {
  final Widget initialRoute;

  const BibleQuestApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Quest',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: initialRoute,
    );
  }
}
