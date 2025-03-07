import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const BibleQuestApp());
}

class BibleQuestApp extends StatelessWidget {
  const BibleQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Quest',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int playerLevel = 1;
  String playerTitle = 'Disciple';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool useLives = true;

  String _getTitle(int level) {
    if (level >= 20) return 'Sage';
    if (level >= 10) return 'Scribe';
    return 'Disciple';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDifficultyButton(String difficulty, BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => QuizScreen(
                      difficulty: difficulty.toLowerCase(),
                      useLives: useLives,
                    ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
          ),
          child: Text(
            '$difficulty Quest',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.orangeAccent),
            ),
            backgroundColor: Colors.grey[900],
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Use Lives',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Switch(
                      value: useLives,
                      activeColor: Colors.orangeAccent,
                      onChanged: (value) {
                        setDialogState(() => useLives = value);
                        setState(() => useLives = value);
                      },
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Quest'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 4,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'instructions') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InstructionsScreen(),
                  ),
                );
              } else if (value == 'settings') {
                _showSettingsDialog();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'instructions',
                    child: Text('Instructions'),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                ],
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.book, size: 60, color: Colors.orangeAccent),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    'Welcome, $playerTitle!',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Level: $playerLevel',
                style: const TextStyle(fontSize: 24, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              _buildDifficultyButton('Beginner', context),
              const SizedBox(height: 20),
              _buildDifficultyButton('Intermediate', context),
              const SizedBox(height: 20),
              _buildDifficultyButton('Advanced', context),
              const SizedBox(height: 25),
              const Text(
                'Answer questions, earn scrolls, and rise in faith!',
                style: TextStyle(fontSize: 16, color: Colors.white60),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Instructions Screen
class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        backgroundColor: Colors.orangeAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Bible Quest!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Objective:',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Test your Bible knowledge, earn points, and level up from Disciple to Sage in this epic trivia adventure!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                'How to Play:',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '1. Choose a difficulty: Beginner, Intermediate, or Advanced.\n'
                '2. Answer multiple-choice questions within 20 seconds each or skip them.\n'
                '3. Optional: Use 5 lives—lose one for each wrong answer, timeout, or skip (toggle in Settings).\n'
                '   - Note: Skipping a question will cause you to lose one life if lives are enabled.\n'
                '4. Use hints (50 scrolls) to reveal the answer—earn 10 scrolls per correct answer.\n'
                '5. Finish a level (10 questions) with 70% correct to advance.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scoring:',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '- Beginner: 10 points per correct answer.\n'
                '- Intermediate: 20 points per correct answer.\n'
                '- Advanced: 30 points per correct answer.\n'
                '- Speed Bonus: +50% points if answered in 10 seconds.\n'
                '- Streak Bonus: Double points after 5 correct in a row.\n'
                '- Perfect Level: 100 bonus points for 10/10.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                'Progression:',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '- Earn XP equal to your score.\n'
                '- Level up: Beginner (100 XP/level), Intermediate (250 XP/level), Advanced (500 XP/level).\n'
                '- Titles: Disciple (1-9), Scribe (10-19), Sage (20+).',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tips for Gamers:',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '- Go for streaks to rack up points fast!\n'
                '- Use hints (50 scrolls) if stuck—earn scrolls by playing.\n'
                '- Check the leaderboard to compete with friends!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Quiz Screen
class QuizScreen extends StatefulWidget {
  final String difficulty;
  final bool useLives;

  const QuizScreen({
    super.key,
    required this.difficulty,
    required this.useLives,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int score = 0;
  int lives = 5;
  int scrolls = 0; // New: Scroll currency
  List<Map<String, dynamic>> questions = [];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Timer _timer;
  int _secondsRemaining = 20;
  int _correctStreak = 0;
  String _bonusMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    if (!widget.useLives) lives = -1;
    loadQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> loadQuestions() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/questions.json',
      );
      final Map<String, dynamic> data = jsonDecode(response);
      setState(() {
        questions = List<Map<String, dynamic>>.from(data[widget.difficulty]);
        _animationController.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading questions: $e')));
    }
  }

  void _startTimer() {
    _secondsRemaining = 20;
    _bonusMessage = '';
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _handleWrongAnswer();
        }
      });
    });
  }

  void _handleWrongAnswer() {
    setState(() {
      if (widget.useLives) {
        lives--;
        _correctStreak = 0;
        _bonusMessage = 'Oops! Lost a life';
        if (lives <= 0) {
          _showGameOverDialog();
          return;
        }
      } else {
        _correctStreak = 0;
        _bonusMessage = 'Wrong!';
      }
      _nextQuestion();
    });
  }

  void _handleSkipQuestion() {
    if (widget.useLives) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text(
                'Skip Question',
                style: TextStyle(color: Colors.orangeAccent),
              ),
              backgroundColor: Colors.grey[900],
              content: const Text(
                'Warning: Skipping this question will cause you to lose one life if lives are enabled. Proceed?',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _skipQuestion();
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              ],
            ),
      );
    } else {
      _skipQuestion();
    }
  }

  void _skipQuestion() {
    _timer.cancel();
    setState(() {
      if (widget.useLives) {
        lives--;
        _correctStreak = 0;
        _bonusMessage = 'Skipped! Lost a life';
        if (lives <= 0) {
          _showGameOverDialog();
          return;
        }
      } else {
        _correctStreak = 0;
        _bonusMessage = 'Skipped!';
      }
      _nextQuestion();
    });
  }

  void _useHint() {
    _timer.cancel();
    if (scrolls >= 50) {
      setState(() {
        scrolls -= 50;
        _bonusMessage =
            'Hint: The answer is "${questions[currentQuestionIndex]['answer']}"';
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _bonusMessage = '';
            _startTimer();
          });
        }
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Game Over',
              style: TextStyle(color: Colors.orangeAccent),
            ),
            backgroundColor: Colors.grey[900],
            content: const Text(
              'Apologies for this, but you have run out of lives, I am returning back to the main screen.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _endQuiz('');
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
        _endQuiz('');
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        _animationController.reset();
        _animationController.forward();
        _startTimer();
      } else {
        _endQuiz('Quiz Complete!');
      }
    });
  }

  void _endQuiz(String message) {
    _timer.cancel();
    Navigator.pop(context);
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$message Score: $score')));
    }
  }

  void checkAnswer(String selectedAnswer) {
    _timer.cancel();
    if (questions.isEmpty) return;

    int basePoints =
        widget.difficulty == 'beginner'
            ? 10
            : widget.difficulty == 'intermediate'
            ? 20
            : 30;
    bool isCorrect =
        selectedAnswer == questions[currentQuestionIndex]['answer'];

    setState(() {
      if (isCorrect) {
        _correctStreak++;
        scrolls += 10; // Earn 10 scrolls per correct answer
        int points = basePoints;
        String bonusText = '';

        if (_secondsRemaining > 10) {
          points = (points * 1.5).round();
          bonusText += 'Speed Bonus! ';
        }
        if (_correctStreak >= 5) {
          points *= 2;
          bonusText += 'Streak Bonus! ';
        }
        score += points;
        _bonusMessage = bonusText.isNotEmpty ? bonusText : 'Correct!';

        if ((currentQuestionIndex + 1) % 10 == 0 && _correctStreak == 10) {
          score += 100;
          _bonusMessage += ' Perfect Level!';
          _correctStreak = 0;
        }
      } else {
        _handleWrongAnswer();
        return;
      }

      _nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.difficulty[0].toUpperCase()}${widget.difficulty.substring(1)} Quiz',
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              questions.isEmpty
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                  : SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${currentQuestionIndex + 1}/${questions.length}',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            if (widget.useLives)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    size: 24,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Lives: $lives',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  size: 24,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '$_secondsRemaining s',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.receipt_long,
                                  size: 24,
                                  color: Colors.yellow,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Scrolls: $scrolls',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_bonusMessage.isNotEmpty)
                          Text(
                            _bonusMessage,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.greenAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            questions[currentQuestionIndex]['question'],
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ...questions[currentQuestionIndex]['options']
                            .map<Widget>((option) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: ElevatedButton(
                                    onPressed: () => checkAnswer(option),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 6,
                                    ),
                                    child: Text(
                                      option,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              );
                            })
                            .toList(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _handleSkipQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                'Skip Question',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: scrolls >= 50 ? _useHint : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    scrolls >= 50
                                        ? Colors.yellow[700]
                                        : Colors.grey[800],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                'Use Hint (50)',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Score: $score',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
