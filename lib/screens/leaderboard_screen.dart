import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[700],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Removed const
            const Text(
              'Top Players',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title:
                  const Text('Player1', style: TextStyle(color: Colors.white)),
              trailing: Text(
                '100',
                style: TextStyle(color: Colors.orange[200]),
              ),
            ),
            ListTile(
              title:
                  const Text('Player2', style: TextStyle(color: Colors.white)),
              trailing: Text(
                '85',
                style: TextStyle(color: Colors.orange[200]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
