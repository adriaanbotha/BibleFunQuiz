import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'quiz_screen.dart';
import 'instructions_screen.dart';
import 'gospel_screen.dart';
import 'which_screen_church.dart';
import 'leaderboard_screen.dart';
import '../globals.dart' as globals;

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
  int livesCount = 5;
  bool useTime = true;
  int timeLimit = 20;
  String playerName = 'Player';
  bool muteSound = false;
  int questionCount = 10;
  bool randomizeQuestions = true;

  String _getTitle(int level) {
    if (level >= 20) return 'Sage';
    if (level >= 10) return 'Scribe';
    return 'Disciple';
  }

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  Future<void> _loadPlayerData() async {
    await globals.Globals.loadPlayerData();
    if (mounted) {
      setState(() {
        playerLevel = globals.Globals.playerLevel;
        playerTitle = _getTitle(globals.Globals.playerLevel);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNameDialog(String difficulty) {
    TextEditingController nameController =
        TextEditingController(text: playerName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Your Name',
            style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: Colors.grey[900],
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white70),
          decoration: const InputDecoration(
            hintText: 'Your Name',
            hintStyle: TextStyle(color: Colors.white54),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.orangeAccent)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                playerName = nameController.text.trim().isEmpty
                    ? 'Player'
                    : nameController.text.trim();
              });
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    difficulty: difficulty.toLowerCase(),
                    useLives: useLives,
                    livesCount: livesCount,
                    useTime: useTime,
                    timeLimit: timeLimit,
                    playerName: playerName,
                    muteSound: muteSound,
                    questionCount: questionCount,
                    randomizeQuestions: randomizeQuestions,
                  ),
                ),
              );
            },
            child: const Text('Start',
                style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(String difficulty) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: 300,
          height: 60,
          child: ElevatedButton(
            onPressed: () => _showNameDialog(difficulty),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: Text('$difficulty Quest'),
          ),
        ),
      ),
    );
  }

  void _inviteFriend() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '',
      queryParameters: {
        'subject': 'Join Me in Bible Quest!',
        'body': '''Hey there!

I’m having a blast playing Bible Quest, a fun Bible trivia game, and I’d love for you to join me! I’m currently a $playerTitle at Level $playerLevel—think you can beat my progress? It’s a great way to test your Bible knowledge and rise through the ranks together.

Download it here: [Insert App Link or Store URL] and let’s see who can earn the most scrolls! Ready for the challenge?

Looking forward to crushing it,
$playerName''',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app')),
      );
    }
  }

  void _shareContent(String text, String url, {String? imagePath}) {
    if (imagePath != null) {
      Share.shareFiles(
        [imagePath],
        text: '$text\n$url',
        subject: 'Check out my Bible Quest journey!',
      );
    } else {
      Share.share(
        '$text\n$url',
        subject: 'Check out my Bible Quest journey!',
      );
    }
  }

  void _showSuggestionsDialog() {
    TextEditingController nameController =
        TextEditingController(text: playerName);
    TextEditingController suggestionController = TextEditingController();
    FocusNode nameFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
      nameController.selection =
          TextSelection(baseOffset: 0, extentOffset: playerName.length);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggestions',
            style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: Colors.grey[900],
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                focusNode: nameFocusNode,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  hintText: 'Your Name (optional)',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: suggestionController,
                style: const TextStyle(color: Colors.white70),
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Your Suggestion',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.orangeAccent)),
          ),
          TextButton(
            onPressed: () async {
              String name = nameController.text.trim().isEmpty
                  ? 'A Friend'
                  : nameController.text.trim();
              String suggestion = suggestionController.text.trim();
              if (suggestion.isNotEmpty) {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'your.email@example.com',
                  queryParameters: {
                    'subject': 'Bible Quest Suggestion',
                    'body': 'From: $name\nSuggestion: $suggestion',
                  },
                );
                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                  Navigator.pop(context);
                  _showThankYouDialog(name);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open email app')),
                  );
                }
              }
            },
            child: const Text('Submit',
                style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    TextEditingController nameController =
        TextEditingController(text: playerName);
    TextEditingController feedbackController = TextEditingController();
    FocusNode nameFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
      nameController.selection =
          TextSelection(baseOffset: 0, extentOffset: playerName.length);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feedback',
            style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: Colors.grey[900],
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                focusNode: nameFocusNode,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  hintText: 'Your Name (optional)',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: feedbackController,
                style: const TextStyle(color: Colors.white70),
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Your Feedback',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.orangeAccent)),
          ),
          TextButton(
            onPressed: () async {
              String name = nameController.text.trim().isEmpty
                  ? 'A Friend'
                  : nameController.text.trim();
              String feedback = feedbackController.text.trim();
              if (feedback.isNotEmpty) {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'your.email@example.com',
                  queryParameters: {
                    'subject': 'Bible Quest Feedback',
                    'body': 'From: $name\nFeedback: $feedback',
                  },
                );
                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                  Navigator.pop(context);
                  _showThankYouDialog(name);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open email app')),
                  );
                }
              }
            },
            child: const Text('Submit',
                style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  void _showThankYouDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank You!',
            style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: Colors.grey[900],
        content: Text(
          'Thank you, $name, for your input! We really appreciate your help in making Bible Quest even better.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('OK', style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings',
            style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: Colors.grey[900],
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Use Lives',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      Switch(
                        value: useLives,
                        activeColor: Colors.orangeAccent,
                        onChanged: (value) {
                          setDialogState(() => useLives = value);
                          setState(() => useLives = value);
                        },
                      ),
                    ],
                  ),
                  if (useLives)
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        children: [
                          const Text('Lives:',
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(width: 8),
                          DropdownButton<int>(
                            value: livesCount,
                            dropdownColor: Colors.grey[900],
                            style: const TextStyle(color: Colors.white70),
                            items: List.generate(10, (index) => index + 1)
                                .map((count) => DropdownMenuItem<int>(
                                    value: count, child: Text('$count')))
                                .toList(),
                            onChanged: (value) {
                              setDialogState(() => livesCount = value!);
                              setState(() => livesCount = value!);
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.timer,
                          size: 20, color: Colors.orangeAccent),
                      const SizedBox(width: 8),
                      const Text('Use Time',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      Switch(
                        value: useTime,
                        activeColor: Colors.orangeAccent,
                        onChanged: (value) {
                          setDialogState(() => useTime = value);
                          setState(() => useTime = value);
                        },
                      ),
                    ],
                  ),
                  if (useTime)
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        children: [
                          const Text('Time:',
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(width: 8),
                          DropdownButton<int>(
                            value: timeLimit,
                            dropdownColor: Colors.grey[900],
                            style: const TextStyle(color: Colors.white70),
                            items: [10, 15, 20, 25, 30, 45, 60]
                                .map((seconds) => DropdownMenuItem<int>(
                                    value: seconds, child: Text('$seconds s')))
                                .toList(),
                            onChanged: (value) {
                              setDialogState(() => timeLimit = value!);
                              setState(() => timeLimit = value!);
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.volume_up,
                          size: 20, color: Colors.white70),
                      const SizedBox(width: 8),
                      const Text('Sound',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      Switch(
                        value: !muteSound,
                        activeColor: Colors.orangeAccent,
                        onChanged: (value) {
                          setDialogState(() => muteSound = !value);
                          setState(() => muteSound = !value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.question_answer,
                          size: 20, color: Colors.orangeAccent),
                      const SizedBox(width: 8),
                      const Text('Questions:',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: questionCount,
                        dropdownColor: Colors.grey[900],
                        style: const TextStyle(color: Colors.white70),
                        items: [10, 25, 50, 100]
                            .map((count) => DropdownMenuItem<int>(
                                value: count, child: Text('$count')))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() => questionCount = value!);
                          setState(() => questionCount = value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.shuffle,
                          size: 20, color: Colors.orangeAccent),
                      const SizedBox(width: 8),
                      const Text('Randomize Questions',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      Switch(
                        value: randomizeQuestions,
                        activeColor: Colors.orangeAccent,
                        onChanged: (value) {
                          setDialogState(() => randomizeQuestions = value);
                          setState(() => randomizeQuestions = value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: Colors.orangeAccent)),
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
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: _showSettingsDialog,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen(
                    latestScore: 0,
                    message: 'Leaderboard',
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'instructions') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InstructionsScreen()),
                );
              } else if (value == 'gospel') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GospelScreen()),
                );
              } else if (value == 'which_church') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WhichChurchScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'instructions', child: Text('Instructions')),
              const PopupMenuItem(value: 'gospel', child: Text('The Gospel')),
              const PopupMenuItem(
                  value: 'which_church', child: Text('Which Church')),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/faithful_journey_banner.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 200, color: Colors.red),
                ),
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
                              blurRadius: 4)
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
                _buildDifficultyButton('Beginner'),
                const SizedBox(height: 20),
                _buildDifficultyButton('Intermediate'),
                const SizedBox(height: 20),
                _buildDifficultyButton('Advanced'),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _inviteFriend,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 174, 246, 162),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Invite a Friend'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _shareContent(
                            'Join me on Bible Quest to grow in faith!',
                            'https://biblequestapp.com/$playerName',
                            imagePath:
                                'assets/images/faithful_journey_banner.jpg',
                          );
                        },
                        icon: const Icon(Icons.share, color: Colors.black),
                        label: const Text('Share My Journey'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "'Answer questions, rise in knowledge, get to know the Word so you can hear and know Him, and rise in faith!, Jesus does really love you!!'",
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Romans 10:17 NKJV\nSo then faith comes by hearing, and hearing by the word of God.",
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: SizedBox(
                          width: 300,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _showSuggestionsDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 8,
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Suggestions'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: SizedBox(
                          width: 300,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _showFeedbackDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 8,
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Feedback'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
