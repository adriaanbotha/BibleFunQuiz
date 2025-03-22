import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/connectivity_service.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import 'package:flutter/foundation.dart';
import '../screens/leaderboard_screen.dart';
import '../widgets/connectivity_indicator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AuthService? authService;
  final SettingsService? settingsService;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.authService,
    this.settingsService,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _shareApp(BuildContext context) {
    Share.share(
      'Check out Bible Quest! A fun way to learn and grow in faith through Bible quizzes. Download now!',
      subject: 'Join me on Bible Quest!',
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'We\'d love to hear your thoughts! Your feedback helps us make Bible Quest even better.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Share your suggestions, ideas, or report issues...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (feedbackController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your feedback'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final success = await authService?.submitFeedback(
                  feedbackController.text.trim(),
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success == true
                            ? 'Thank you for your feedback!'
                            : 'Failed to send feedback. Please try again.',
                      ),
                      backgroundColor: success == true ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
              ),
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFF9800),
        leading: title == 'Home'
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  if (scaffoldKey?.currentState?.isDrawerOpen ?? false) {
                    Navigator.of(context).pop();
                  } else {
                    scaffoldKey?.currentState?.openDrawer();
                  }
                },
              )
            : title != 'Login' && title != 'Register'
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : null,
        actions: [
          if (title != 'Login' && title != 'Register') ...[
            // Leaderboard Button
            if (title == 'Home')
              IconButton(
                icon: const Icon(Icons.leaderboard),
                onPressed: () {
                  if (authService != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardScreen(
                          authService: authService!,
                        ),
                      ),
                    );
                  }
                },
              ),
            // Share Button
            if (title == 'Home')
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareApp(context),
              ),
            // Feedback Button
            if (title == 'Home')
              IconButton(
                icon: const Icon(Icons.feedback),
                onPressed: () => _showFeedbackDialog(context),
              ),
            
            // Connectivity Status
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ConnectivityIndicator(),
            ),
            const SizedBox(width: 8),

            // Popup Menu
            PopupMenuButton<String>(
              onSelected: (String choice) async {
                if (choice == 'About') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('About'),
                        content: const Text('Quiz App\nVersion 1.0.0'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'About',
                    child: Text('About'),
                  ),
                ];
              },
            ),
          ],
        ],
      ),
    );
  }
} 