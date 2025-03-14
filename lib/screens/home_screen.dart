import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService authService;

  const HomeScreen({
    Key? key,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final ScaffoldState? scaffold = Scaffold.maybeOf(context);
        if (scaffold?.isDrawerOpen ?? false) {
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        appBar: const CustomAppBar(),
        drawer: AppDrawer(authService: authService),
        body: Padding(
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
