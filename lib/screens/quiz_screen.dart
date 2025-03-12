import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class QuizScreen extends StatefulWidget {
  final String? difficulty; // Added difficulty parameter
  const QuizScreen({super.key, this.difficulty});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the first book of the Bible?',
      'options': ['Exodus', 'Genesis', 'Leviticus'],
      'answer': 'Genesis',
    },
    {
      'question': 'Who built the ark?',
      'options': ['Moses', 'Noah', 'Abraham'],
      'answer': 'Noah',
    },
  ];

  void _submitAnswer(String selectedOption) {
    if (selectedOption == questions[currentQuestionIndex]['answer']) {
      score++;
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _endQuiz();
    }
  }

  void _endQuiz() {
    globals.currentScore = score; // Updated to use variable
    globals.updateHighScore(score); // Updated to use defined method

    // Show polite completion message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Well done! You’ve completed the quiz. See how you rank on the leaderboard!'),
        backgroundColor: globals.primaryColor, // Fixed reference
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to leaderboard after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      globals.navigatorKey.currentState
          ?.pushReplacementNamed('/leaderboard'); // Fixed reference
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestionIndex >= questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentQuestion = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Quiz'),
        backgroundColor: globals.primaryColor, // Fixed reference
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ...currentQuestion['options'].map<Widget>((option) {
              return ListTile(
                title: Text(option),
                onTap: () => _submitAnswer(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
