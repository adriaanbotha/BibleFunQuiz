import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        centerTitle: true,
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 60,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),
                const Text(
                  'How to Play Bible Quest',
                  style: TextStyle(
                    fontSize: 28,
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
                const SizedBox(height: 20),
                const Text(
                  '1. Start the Game:\n'
                  '   - Choose a difficulty: Beginner, Intermediate, or Advanced from the home screen.\n'
                  '   - Enter your name (optional) when prompted to personalize your leaderboard entry.\n\n'
                  '2. Answer Questions:\n'
                  '   - Each quiz consists of multiple-choice questions (set in Settings: 10, 25, 50, or 100).\n'
                  '   - Select an answer by tapping one of the four options displayed.\n'
                  '   - Correct answers earn points and scrolls; wrong answers may cost lives or reset streaks.\n\n'
                  '3. Time Limit (Optional):\n'
                  '   - Enable "Use Time" in Settings (default: on) to set a per-question time limit (10, 15, 20, 25, 30, 45, or 60 seconds).\n'
                  '   - Answer before the timer runs out to avoid penalties (e.g., losing a life if enabled).\n'
                  '   - Answering in less than half the time earns a Speed Bonus (1.5x points).\n\n'
                  '4. Lives (Optional):\n'
                  '   - Enable "Use Lives" in Settings (default: on) to limit mistakes (1-10 lives, default: 5).\n'
                  '   - Lose a life for each wrong answer, timeout, or skip. If lives reach 0, the quiz ends with "Game Over!"\n'
                  '   - Disable lives for unlimited attempts, with no penalty beyond losing streaks.\n\n'
                  '5. Skipping Questions:\n'
                  '   - Tap "Skip" to move to the next question.\n'
                  '   - Costs one life if lives are enabled; no cost if disabled, but resets your streak.\n\n'
                  '6. Using Hints:\n'
                  '   - Tap "Hint (50)" to reveal the answer (costs 50 scrolls, disabled if you have fewer).\n'
                  '   - Earn scrolls (10 per correct answer) to use hints—hint pauses the timer briefly.\n\n'
                  '7. Question Randomization:\n'
                  '   - Enable "Randomize Questions" in Settings (default: on) to shuffle questions each time you start a quiz.\n'
                  '   - Disable to use a consistent order (based on the initial load from the question bank).\n\n'
                  '8. Scoring and Bonuses:\n'
                  '   - Points per correct answer: Beginner (10), Intermediate (20), Advanced (30).\n'
                  '   - Bonuses:\n'
                  '     - Speed Bonus: Answer in less than half the time limit (1.5x points, e.g., 15, 30, 45).\n'
                  '     - Streak Bonus: 5+ correct answers in a row (2x points, e.g., 20, 40, 60).\n'
                  '     - Perfect Level: Answer all questions correctly (extra 100 points).\n'
                  '   - Wrong answers or skips reset the streak but don’t deduct points.\n\n'
                  '9. Completing a Level:\n'
                  '   - Achieve 70% correct to pass (e.g., 7/10, 18/25, 35/50, 70/100) and see "Level Complete!"\n'
                  '   - Below 70% ends with "Quiz Ended!"—all scores still count toward XP and leaderboard.\n\n'
                  '10. Progression and Rewards:\n'
                  '    - Earn XP equal to your score to increase your level.\n'
                  '    - XP per level: Beginner (100), Intermediate (250), Advanced (500).\n'
                  '    - Titles: Disciple (Levels 1-9), Scribe (10-19), Sage (20+).\n'
                  '    - Scrolls persist across quizzes for hints; XP and levels save your progress.\n\n'
                  '11. Navigation:\n'
                  '    - After the quiz, view your score and ranking on the Leaderboard.\n'
                  '    - Return to the home screen from the Leaderboard to start a new quiz.\n'
                  '    - Access Settings from the home screen (gear icon) to adjust options.\n'
                  '    - Invite friends or submit feedback/suggestions from the home screen buttons.',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.left,
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
                    'Back',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
