import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/instructions_screen.dart';
import 'screens/which_church_screen.dart';
import 'screens/gospel_screen.dart';
import 'screens/donate_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/not_found_screen.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'services/settings_service.dart';
import 'package:provider/provider.dart';
import 'services/connectivity_service.dart';
import 'utils/route_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService();
  await settingsService.init();
  
  final authService = AuthService(prefs);
  
  // Preload questions in the background
  authService.refreshQuestionCache().then((success) {
    if (success) {
      debugPrint('Questions cached successfully');
    } else {
      debugPrint('Failed to cache questions');
    }
  });
  
  runApp(MyApp(
    authService: authService,
    settingsService: settingsService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final SettingsService settingsService;

  const MyApp({
    Key? key,
    required this.authService,
    required this.settingsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globals.navigatorKey,
      title: globals.appName,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF9800),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          primary: const Color(0xFFFF9800),
          secondary: const Color(0xFFFFB300),
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          final isLoggedIn = snapshot.data ?? false;
          
          if (isLoggedIn) {
            return HomeScreen(
              authService: authService,
              settingsService: settingsService,
            );
          } else {
            return LoginScreen(
              authService: authService,
              settingsService: settingsService,
            );
          }
        },
      ),
    );
  }
}
