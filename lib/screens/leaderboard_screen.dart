import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: globals.primaryColor,
      ),
      body: const Center(
        child: Text('Leaderboard content will go here!'),
      ),
    );
  }
}
