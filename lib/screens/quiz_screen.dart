import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import '../widgets/custom_app_bar.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../screens/leaderboard_screen.dart';

class QuizScreen extends StatefulWidget {
  final AuthService authService;
  final SettingsService settingsService;
  final String difficulty; // 'beginner', 'intermediate', or 'advanced'

  const QuizScreen({
    Key? key,
    required this.authService,
    required this.settingsService,
    required this.difficulty,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _questionsPerQuiz;
  bool _showReferences = true;
  String? _lastAnswerFeedback;
  bool? _lastAnswerCorrect;
  String? _lastQuestionReference;
  
  // Add new variables for lives and timer
  int _lives = 3;  // Default lives
  int _timeLeft = 30;  // Default time per question in seconds
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  int _currentScore = 0;  // Add this to track the actual score
  bool _livesEnabled = true;
  int _timePerQuestion = 30;  // Default value
  bool _isTimerInitialized = false;  // Add this flag

  @override
  void initState() {
    super.initState();
    _loadSettings().then((_) {
      _loadQuestions();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    _soundEnabled = await widget.settingsService.getSoundEnabled();
    _livesEnabled = await widget.settingsService.getLivesEnabled();
    _lives = await widget.settingsService.getNumberOfLives();
    _questionsPerQuiz = await widget.settingsService.getQuestionsPerQuiz();
    _showReferences = await widget.settingsService.getShowReferences();
    _timePerQuestion = await widget.settingsService.getTimePerQuestion();
    
    setState(() {
      _isLoading = false;
      _timeLeft = _timePerQuestion;  // Initialize with setting value
    });
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    try {
      // Get questions for the specified difficulty
      final questions = await widget.authService.getQuestionsByDifficulty(widget.difficulty);
      
      if (questions.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No questions available. Please check your connection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Shuffle questions and limit to settings amount
      questions.shuffle();
      if (_questionsPerQuiz != null && _questionsPerQuiz! > 0) {
        questions.length = _questionsPerQuiz!.clamp(0, questions.length);
      }

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading questions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timeLeft = _timePerQuestion); // Reset to setting value
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _handleTimeUp();
        }
      });
    });
  }

  Future<void> _playSound(bool isCorrect) async {
    if (!_soundEnabled) return;

    try {
      await _audioPlayer.stop(); // Stop any currently playing sound
      await _audioPlayer.play(
        AssetSource(
          isCorrect ? 'sounds/correct.mp3' : 'sounds/incorrect.mp3',
        ),
      );
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _handleTimeUp() {
    _timer?.cancel();
    // Play incorrect sound for time up
    _playSound(false);

    setState(() {
      _lives--;
      _lastAnswerFeedback = 'Time\'s up! The correct answer was: ${_questions[_currentQuestionIndex]['answer']}';
      _lastAnswerCorrect = false;
      _lastQuestionReference = _questions[_currentQuestionIndex]['reference'];
      
      if (_lives <= 0) {
        _showGameOver();
      } else if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _startTimer();
      } else {
        _showFinalScore();
      }
    });
  }

  int _calculateBasePoints() {
    switch(widget.difficulty) {
      case 'beginner':
        return 10;
      case 'intermediate':
        return 20;
      case 'advanced':
        return 30;
      default:
        return 10;
    }
  }

  void _handleAnswer(String selectedAnswer) {
    _timer?.cancel();
    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = selectedAnswer == currentQuestion['answer'];

    _playSound(isCorrect);

    setState(() {
      if (isCorrect) {
        _score++;
        _currentScore += _calculateBasePoints();
      } else if (_livesEnabled) {
        _lives--;
      }

      _lastAnswerFeedback = 'Previous answer: ${currentQuestion['answer']}';
      _lastAnswerCorrect = isCorrect;
      _lastQuestionReference = currentQuestion['reference'];
      
      if (_livesEnabled && _lives <= 0) {
        _showGameOver();
      } else if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _startTimer();
      } else {
        _showFinalScore();
      }
    });
  }

  int _calculateFinalScore() {
    final baseScore = _currentScore;
    final livesBonus = _lives * 50;  // 50 points per life remaining
    return baseScore + livesBonus;
  }

  void _showGameOver() {
    final totalScore = _calculateFinalScore();
    
    // Update user stats and leaderboard
    final email = widget.authService.getCurrentEmail();
    if (email != null) {
      widget.authService.updateUserStats(
        email,
        totalScore,
        widget.difficulty,
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You ran out of lives!'),
            const SizedBox(height: 8),
            Text('Final Score: $totalScore points'),
            Text('Questions Completed: $_currentQuestionIndex of ${_questions.length}'),
            Text('Correct Answers: $_score'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _questions.shuffle();
                _currentQuestionIndex = 0;
                _score = 0;
                _currentScore = 0;  // Reset current score
                _lives = 3;
                _startTimer();
              });
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showFinalScore() {
    final int finalScore = _calculateFinalScore();
    
    // Update user stats and leaderboard
    final email = widget.authService.getCurrentEmail();
    if (email != null) {
      widget.authService.updateUserStats(
        email,
        finalScore,
        widget.difficulty,
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Final Score: $finalScore'),
            Text('Correct Answers: $_score/${_questions.length}'),
            Text('Percentage: ${(_score / _questions.length * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            Text('Base Points: $_currentScore'),
            Text('Lives Bonus: ${_calculateBasePoints() * (_livesEnabled ? 1 : 0)}'),
            const Divider(),
            Text(
              'Total Score: $finalScore',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              
              // Navigate to leaderboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaderboardScreen(
                    authService: widget.authService,
                  ),
                ),
              );
            },
            child: const Text('View Leaderboard'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to home screen
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty[0].toUpperCase()}${widget.difficulty.substring(1)} Quiz'),
        backgroundColor: const Color(0xFFFF9800),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading 
              ? null 
              : () async {
                  setState(() => _isLoading = true);
                  await widget.authService.clearQuestionCache();
                  await _loadQuestions();
                },
          ),
        ],
      ),
      body: _isLoading
          ? FutureBuilder<bool>(
              future: widget.authService.hasQuestionsInCache(widget.difficulty),
              builder: (context, snapshot) {
                final bool isFirstLoad = !snapshot.hasData || !snapshot.data!;
                
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                        ),
                        const SizedBox(height: 24),
                        if (isFirstLoad) ...[
                          const Text(
                            '📚 Preparing Your Bible Quest',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9800),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'We\'re downloading questions for the first time to ensure smooth gameplay, even without internet. This may take a moment, but it\'s a one-time process.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Get ready for an amazing journey through Scripture! 🙏',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else
                          const Text(
                            'Loading questions...',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
          : _questions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No questions available'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          await widget.authService.clearQuestionCache();
                          await _loadQuestions();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status Bar with Timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_livesEnabled)
                            Row(
                              children: [
                                const Icon(Icons.favorite, color: Colors.red),
                                const SizedBox(width: 4),
                                Text(
                                  'Lives: $_lives',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          // Timer
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: _timeLeft <= 10 ? Colors.red : Colors.grey[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Time: $_timeLeft s',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _timeLeft <= 10 ? Colors.red : null,
                                  fontWeight: _timeLeft <= 10 ? FontWeight.bold : null,
                                ),
                              ),
                            ],
                          ),
                          // Score - Updated to show current points
                          Row(
                            children: [
                              const Icon(Icons.stars, color: Color(0xFFFF9800)),
                              const SizedBox(width: 4),
                              Text(
                                'Score: $_currentScore',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Progress Bar
                      LinearProgressIndicator(
                        value: (_currentQuestionIndex + 1) / _questions.length,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                      ),
                      
                      // Question Counter
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Previous Answer Feedback
                      if (_lastAnswerFeedback != null) ...[
                        Card(
                          color: _lastAnswerCorrect == true 
                              ? Colors.green[50] 
                              : Colors.red[50],
        child: Padding(
                            padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                                Row(
                                  children: [
                                    Icon(
                                      _lastAnswerCorrect == true
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: _lastAnswerCorrect == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _lastAnswerFeedback!,
                                        style: TextStyle(
                                          color: _lastAnswerCorrect == true
                                              ? Colors.green[900]
                                              : Colors.red[900],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_showReferences && _lastQuestionReference != null) ...[
                                  const SizedBox(height: 4),
              Text(
                                    'Reference: $_lastQuestionReference',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _lastAnswerCorrect == true
                                          ? Colors.green[900]
                                          : Colors.red[900],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Current Question
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    _questions[_currentQuestionIndex]['question'],
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Answer Options
                              ..._questions[_currentQuestionIndex]['options']
                                  .map<Widget>((option) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: ElevatedButton(
                                          onPressed: () => _handleAnswer(option),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFF9800),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.all(16),
                                            textStyle: const TextStyle(fontSize: 16),
                                          ),
                                          child: Text(option),
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
        ),
      ),
    );
  }
}

// Add this extension
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
