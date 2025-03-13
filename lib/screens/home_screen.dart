import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  final String? nickname;

  const HomeScreen({Key? key, this.nickname}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    globals.currentUserId = null;
    globals.currentUsername = null;
    globals.currentEmail = null;
    globals.currentNickname = null;
    globals.authToken = null;
    globals.isLoggedIn = false;
    globals.currentScore = 0;
    globals.highScore = 0;
    globals.completedQuizzes.clear();

    if (globals.navigatorKey.currentState != null) {
      globals.navigatorKey.currentState!.pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Bible Quiz',
        showLeading: true,
      ),
      drawer: AppDrawer(nickname: nickname),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDifficultyButton('Beginner', Colors.green),
              const SizedBox(height: 16),
              _buildDifficultyButton('Intermediate', Colors.orange),
              const SizedBox(height: 16),
              _buildDifficultyButton('Advanced', Colors.red),
              const SizedBox(height: 32),
              _buildKidsModeButton(),
              const Spacer(),
              _buildScriptureOfTheDay(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (globals.isLoggedIn) {
                    globals.navigatorKey.currentState?.pushNamed('/leaderboard');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please log in to continue.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Leaderboard'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (globals.isLoggedIn) {
                    globals.navigatorKey.currentState
                        ?.pushNamed('/whichchurch');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please log in to continue.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Which Church?'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (globals.isLoggedIn) {
                    globals.navigatorKey.currentState?.pushNamed('/profile');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please log in to continue.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Profile'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String difficulty, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Handle difficulty selection
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: Text(
        difficulty,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildKidsModeButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle kids mode selection
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: const Text(
        'Kids Mode',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildScriptureOfTheDay() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Romans 10:17 NKJV\n"So then faith comes by hearing, and hearing by the word of God."',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
