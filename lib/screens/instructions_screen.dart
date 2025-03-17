import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        backgroundColor: const Color(0xFFFF9800),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to Bible Quest!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Choosing Your Journey\n\n'
              'Begin your biblical adventure by selecting one of three carefully designed difficulty levels, each offering unique challenges and rewards:\n\n'
              '   • Beginner: Perfect for those starting their journey, featuring fundamental biblical questions and earning 10 points per correct answer.\n'
              '   • Intermediate: Designed for those familiar with Scripture, offering more challenging questions and 20 points per correct answer.\n'
              '   • Advanced: Created for biblical scholars, presenting complex theological questions and rewarding 30 points per correct answer.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '2. Understanding the Game Mechanics\n\n'
              'Your quest begins with three precious lives, representing your chances to explore and learn. Each question presents a unique challenge:\n\n'
              '   • You\'ll start your journey with 3 lives, symbolizing your opportunities to learn and grow.\n'
              '   • Every question gives you 30 seconds to ponder and answer, encouraging both thoughtful consideration and quick thinking.\n'
              '   • Incorrect answers or running out of time will cost you one life, teaching valuable lessons about patience and wisdom.\n'
              '   • Your journey concludes when all lives are depleted, but remember - every ending is a chance for a new beginning.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '3. Earning Your Rewards\n\n'
              'Bible Quest features a comprehensive scoring system that rewards both knowledge and strategy:\n\n'
              '   • Your base points are determined by the difficulty level you\'ve chosen, reflecting your courage to face greater challenges.\n'
              '   • Additional bonus points are awarded for each life preserved, encouraging careful and thoughtful gameplay.\n'
              '   • Your achievements are immortalized on our global leaderboard, where you can compare your biblical knowledge with fellow questers.\n'
              '   • Special achievements and milestones unlock as you progress, marking your growth in biblical understanding.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '4. Personalizing Your Experience\n\n'
              'Bible Quest can be tailored to your preferences through various settings:\n\n'
              '   • Customize your audio experience with optional sound effects that celebrate your victories and gentle reminders for incorrect answers.\n'
              '   • Choose whether to display biblical references alongside questions, perfect for those wanting to deepen their study.\n'
              '   • Adjust the number of lives to match your comfort level and learning style.\n'
              '   • Modify the time allowed for each question, allowing for a more relaxed or challenging experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Pro Tips for Success\n\n'
              'Here are some valuable strategies to enhance your Bible Quest journey:\n\n'
              '• Take time to carefully read and understand each question - the answer often lies in the details.\n'
              '• Manage your time wisely, but don\'t let the timer rush your thoughtful consideration of each answer.\n'
              '• If you\'re new to Bible study, start with the beginner level to build a strong foundation of knowledge.\n'
              '• Regularly visit your Profile screen to track your progress and identify areas for growth.\n'
              '• Remember that every question, whether answered correctly or not, is an opportunity to learn and grow in your biblical knowledge.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
