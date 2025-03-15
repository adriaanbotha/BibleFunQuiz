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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome message with nickname
                FutureBuilder<String?>(
                  future: Future.value(widget.authService.getNickname()),
                  builder: (context, snapshot) {
                    final nickname = snapshot.data ?? 'Friend';
                    return Column(
                      children: [
                        Text(
                          'Welcome, $nickname! 🌟',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9800),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready to explore the Word? Choose your level and let\'s grow in faith together!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
                // Quiz level description
                const Text(
                  'Select Your Journey:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                // Quiz buttons
                ElevatedButton(
                  onPressed: _startBeginnerQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Beginner Quiz'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startIntermediateQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Intermediate Quiz'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startAdvancedQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Advanced Quiz'),
                ),
                const SizedBox(height: 40),
                // Encouraging message
                const Text(
                  'Answer questions, rise in knowledge, get to know the Word so you can hear and know Him, and rise in faith!\nJesus does really love you! ❤️',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Romans 10:17 message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '"So then faith comes by hearing, and hearing by the word of God."\n- Romans 10:17 (NKJV)',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
