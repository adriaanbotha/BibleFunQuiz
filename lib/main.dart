import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/registration_screen.dart'; // Added import for RegistrationScreen
import 'globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globals.navigatorKey, // Set global navigator key
      title: globals.appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: globals.primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: globals.accentColor, // Moved to colorScheme
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/registration': (context) =>
            const RegistrationScreen(), // Added registration route
        // Add other routes as needed
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await globals.loadLeaderboard();
    await globals.loadPlayerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(globals.appName),
      ),
      body: const Center(
        child: Text('Welcome to Bible Quest!'),
      ),
    );
  }
}
