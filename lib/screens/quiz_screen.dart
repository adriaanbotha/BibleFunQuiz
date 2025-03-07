import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'leaderboard_screen.dart';
import '../globals.dart' as globals;

class QuizScreen extends StatefulWidget {
  final String difficulty;
  final bool useLives;
  final int livesCount;
  final bool useTime;
  final int timeLimit;
  final String playerName;
  final bool muteSound;
  final int questionCount;
  final bool randomizeQuestions;

  const QuizScreen({
    super.key,
    required this.difficulty,
    required this.useLives,
    required this.livesCount,
    required this.useTime,
    required this.timeLimit,
    required this.playerName,
    required this.muteSound,
    required this.questionCount,
    required this.randomizeQuestions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int score = 0;
  late int lives;
  int scrolls = 0; // Local copy, synced with globals.scrolls
  List<Map<String, dynamic>> questions = [];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  Timer? _timer;
  late int _secondsRemaining;
  int _correctStreak = 0;
  int _correctAnswers = 0;
  String _bonusMessage = '';
  late AudioPlayer _audioPlayer;
  int xp = 0; // Local XP tracker

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    lives = widget.useLives ? widget.livesCount : -1;
    _secondsRemaining = widget.useTime ? widget.timeLimit : -1;
    scrolls = globals.Globals.scrolls; // Sync with global state
    _loadQuestions();
    if (widget.useTime) _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      final String response =
          await rootBundle.loadString('assets/questions.json');
      final Map<String, dynamic> data = jsonDecode(response);
      if (mounted) {
        setState(() {
          List<Map<String, dynamic>> allQuestions =
              List<Map<String, dynamic>>.from(
                  data[widget.difficulty.toLowerCase()]);
          if (widget.randomizeQuestions) {
            allQuestions.shuffle(Random()); // Shuffle questions if enabled
          }
          questions = allQuestions
              .take(widget.questionCount)
              .toList(); // Take specified number
          _animationController.forward();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading questions: $e')));
      }
    }
  }

  void _startTimer() {
    _secondsRemaining = widget.timeLimit;
    _bonusMessage = '';
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          _handleWrongAnswer();
        }
      });
    });
  }

  void _playSound(String assetPath) {
    if (!widget.muteSound) {
      _audioPlayer.play(AssetSource(assetPath));
    }
  }

  void _handleWrongAnswer() {
    _playSound('sounds/wrong.mp3');
    setState(() {
      if (widget.useLives) {
        lives--;
        _correctStreak = 0;
        _bonusMessage = 'Oops! Lost a life';
        if (lives <= 0) {
          _endQuiz('Game Over!');
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
        builder: (context) => AlertDialog(
          title: const Text('Skip Question',
              style: TextStyle(color: Colors.orangeAccent)),
          backgroundColor: Colors.grey[900],
          content: const Text(
              'Warning: Skipping this question will cost you one life. Proceed?',
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No',
                  style: TextStyle(color: Colors.orangeAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _skipQuestion();
              },
              child: const Text('Yes',
                  style: TextStyle(color: Colors.orangeAccent)),
            ),
          ],
        ),
      );
    } else {
      _skipQuestion();
    }
  }

  void _skipQuestion() {
    _timer?.cancel();
    _playSound('sounds/wrong.mp3');
    setState(() {
      if (widget.useLives) {
        lives--;
        _correctStreak = 0;
        _bonusMessage = 'Skipped! Lost a life';
        if (lives <= 0) {
          _endQuiz('Game Over!');
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
    _timer?.cancel();
    if (scrolls >= 50) {
      setState(() {
        scrolls -= 50;
        _bonusMessage =
            'Hint: The answer is "${questions[currentQuestionIndex]['answer']}"';
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && widget.useTime) {
          setState(() {
            _bonusMessage = '';
            _startTimer();
          });
        }
      });
    }
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.questionCount - 1) {
        currentQuestionIndex++;
        _animationController.reset();
        _animationController.forward();
        if (widget.useTime) _startTimer();
      } else {
        double passThreshold = widget.questionCount * 0.7; // 70% pass threshold
        _endQuiz(_correctAnswers >= passThreshold
            ? 'Level Complete!'
            : 'Quiz Ended!');
      }
    });
  }

  Future<void> _endQuiz(String message) async {
    _timer?.cancel();
    globals.Globals.scrolls = scrolls; // Sync local scrolls to global
    xp = score; // Assign score to XP
    globals.Globals.playerXP += xp; // Update global XP
    int xpPerLevel = widget.difficulty.toLowerCase() == 'beginner'
        ? 100
        : widget.difficulty.toLowerCase() == 'intermediate'
            ? 250
            : 500;
    globals.Globals.playerLevel =
        (globals.Globals.playerXP / xpPerLevel).floor() +
            1; // Update global level
    await globals.Globals.savePlayerData(); // Save player data
    globals.Globals.updateLeaderboard(
        widget.playerName, score); // Update leaderboard
    await globals.Globals.saveLeaderboard(); // Save leaderboard
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LeaderboardScreen(latestScore: score, message: message),
        ),
      );
    }
  }

  void checkAnswer(String selectedAnswer) {
    _timer?.cancel();
    if (questions.isEmpty) return;

    int basePoints = widget.difficulty.toLowerCase() == 'beginner'
        ? 10
        : widget.difficulty.toLowerCase() == 'intermediate'
            ? 20
            : 30;
    bool isCorrect =
        selectedAnswer == questions[currentQuestionIndex]['answer'];

    setState(() {
      if (isCorrect) {
        _playSound('sounds/correct.mp3');
        _correctStreak++;
        _correctAnswers++;
        scrolls += 10; // Update local scrolls
        int points = basePoints;
        String bonusText = '';

        if (widget.useTime && _secondsRemaining > widget.timeLimit ~/ 2) {
          points = (points * 1.5).round();
          bonusText += 'Speed Bonus! ';
        }
        if (_correctStreak >= 5) {
          points *= 2;
          bonusText += 'Streak Bonus! ';
        }
        score += points;
        if (_correctAnswers == widget.questionCount) {
          score += 100;
          bonusText += 'Perfect Level! ';
          _correctStreak = 0;
        }
        _bonusMessage = bonusText.isNotEmpty ? bonusText : 'Correct!';
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
            '${widget.difficulty[0].toUpperCase()}${widget.difficulty.substring(1)} Quiz'),
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
        child: questions.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orange))
            : SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${currentQuestionIndex + 1}/${widget.questionCount}',
                          style: const TextStyle(
                              fontSize: 22, color: Colors.orangeAccent),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.useLives)
                              Row(
                                children: [
                                  const Icon(Icons.favorite,
                                      size: 20, color: Colors.red),
                                  const SizedBox(width: 5),
                                  Text('Lives: $lives',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white70)),
                                ],
                              ),
                            Row(
                              children: [
                                const Icon(Icons.score,
                                    size: 20, color: Colors.greenAccent),
                                const SizedBox(width: 5),
                                Text('Score: $score',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white70)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.useTime)
                          Row(
                            children: [
                              const Icon(Icons.timer,
                                  size: 24, color: Colors.orangeAccent),
                              const SizedBox(width: 5),
                              Text('$_secondsRemaining s',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white70)),
                            ],
                          ),
                        Row(
                          children: [
                            const Icon(Icons.receipt_long,
                                size: 24, color: Colors.yellow),
                            const SizedBox(width: 5),
                            Text('Scrolls: $scrolls',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_bonusMessage.isNotEmpty)
                      Text(
                        _bonusMessage,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.greenAccent),
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
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Text(
                        questions[currentQuestionIndex]['question'],
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ...questions[currentQuestionIndex]['options']
                        .map<Widget>((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ElevatedButton(
                            onPressed: () => checkAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                            ),
                            child: Text(option,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      );
                    }).toList(),
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
                                vertical: 18, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                          ),
                          child: const Text('Skip',
                              style: TextStyle(fontSize: 18)),
                        ),
                        ElevatedButton(
                          onPressed: scrolls >= 50 ? _useHint : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scrolls >= 50
                                ? Colors.yellow[700]
                                : Colors.grey[800],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                          ),
                          child: const Text('Hint (50)',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}
