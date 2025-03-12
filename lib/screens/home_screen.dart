import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String difficulty = 'easy'; // Example difficulty level, can be dynamic

  @override
  void initState() {
    super.initState();
    // Initialize any state if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Bible Quest'),
        backgroundColor: globals.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome! Your current score: ${globals.currentScore}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'High Score: ${globals.highScore}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to QuizScreen with difficulty
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizScreen(difficulty: difficulty.toLowerCase()),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: globals.primaryColor),
              child: const Text('Start Quiz'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                globals.navigatorKey.currentState?.pushNamed('/leaderboard');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: globals.primaryColor),
              child: const Text('View Leaderboard'),
            ),
            // Add more buttons or widgets as needed
          ],
        ),
      ),
    );
  }
}
