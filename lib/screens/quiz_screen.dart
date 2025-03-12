import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> questions = [
    {
      'question': 'Who is the Word according to John 1:1?',
      'options': ['Jesus', 'Moses', 'David', 'Paul'],
      'answer': 'Jesus',
    },
    // Add more questions as needed
  ];

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]['answer']) {
      setState(() {
        score++;
      });
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      globals.updateHighScore(score);
      globals.currentScore = score;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz completed! Score: $score'),
          backgroundColor: Colors.orange[700],
        ),
      );
      globals.navigatorKey.currentState?.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Quiz', style: TextStyle(color: Colors.white)),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1}/${questions.length}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                questions[currentQuestionIndex]['question'],
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ...questions[currentQuestionIndex]['options']
                  .map<Widget>((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(option),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
