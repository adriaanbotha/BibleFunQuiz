import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar.dart';

class QuizScreen extends StatelessWidget {
  final AuthService authService;

  const QuizScreen({
    Key? key,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Quiz'),
      body: const Center(
        child: Text('Quiz Screen - Coming Soon!'),
      ),
    );
  }
}
