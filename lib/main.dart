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
  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);
  final authService = AuthService(prefs);
  final connectivityService = ConnectivityService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => connectivityService),
      ],
      child: MyApp(
        settingsService: settingsService,
        authService: authService,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SettingsService settingsService;
  final AuthService authService;

  const MyApp({
    Key? key, 
    required this.settingsService,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globals.navigatorKey,
      title: globals.appName,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF9800),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9800)),
      ),
      initialRoute: authService.isLoggedIn() ? '/' : '/login',
      onGenerateRoute: (settings) {
        // List of routes that require authentication
        const authRoutes = [
          '/profile',
          '/settings',
          '/leaderboard',
          '/quiz',
        ];

        if (authRoutes.contains(settings.name)) {
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<bool>(
              future: RouteGuard.checkAuth(context, authService),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  switch (settings.name) {
                    case '/profile':
                      return ProfileScreen(authService: authService);
                    case '/settings':
                      return SettingsScreen(settingsService: settingsService);
                    case '/leaderboard':
                      return LeaderboardScreen(authService: authService);
                    case '/quiz':
                      return QuizScreen(authService: authService);
                    default:
                      return HomeScreen(authService: authService);
                  }
                }
                return const LoadingScreen();
              },
            ),
          );
        }

        // Public routes
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(authService: authService),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (context) => LoginScreen(authService: authService),
            );
          case '/instructions':
            return MaterialPageRoute(
              builder: (context) => const InstructionsScreen(),
            );
          case '/which-church':
            return MaterialPageRoute(
              builder: (context) => const WhichChurchScreen(),
            );
          case '/gospel':
            return MaterialPageRoute(
              builder: (context) => const GospelScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const NotFoundScreen(),
            );
        }
      },
    );
  }
}
