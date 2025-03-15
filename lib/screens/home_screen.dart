import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import '../screens/quiz_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final SettingsService settingsService;

  const HomeScreen({
    Key? key,
    required this.authService,
    required this.settingsService,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _startBeginnerQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          authService: widget.authService,
          settingsService: widget.settingsService,
          difficulty: 'beginner',
        ),
      ),
    );
  }

  void _startIntermediateQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          authService: widget.authService,
          settingsService: widget.settingsService,
          difficulty: 'intermediate',
        ),
      ),
    );
  }

  void _startAdvancedQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          authService: widget.authService,
          settingsService: widget.settingsService,
          difficulty: 'advanced',
        ),
      ),
    );
  }

  void _closeDrawer() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          _closeDrawer();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: 'Home',
          authService: widget.authService,
          settingsService: widget.settingsService,
        ),
        drawer: AppDrawer(
          authService: widget.authService,
          settingsService: widget.settingsService,
          onClose: () async {
            _closeDrawer();
            // Wait for the drawer to close before proceeding
            await Future.delayed(const Duration(milliseconds: 300));
          },
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startBeginnerQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Beginner Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startIntermediateQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Intermediate Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startAdvancedQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Advanced Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
