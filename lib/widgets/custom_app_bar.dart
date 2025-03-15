import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import 'package:flutter/foundation.dart';
import '../screens/leaderboard_screen.dart';
import 'dart:io';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AuthService? authService;
  final SettingsService? settingsService;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.authService,
    this.settingsService,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
                  Scaffold.of(context).openDrawer();
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
          // Only show connectivity status and menu on screens that need it
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
            
            // Connectivity Status
            Builder(
              builder: (context) => FutureBuilder<bool>(
                future: checkInternetConnection(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Icon(
                      snapshot.data! ? Icons.wifi : Icons.wifi_off,
                      color: snapshot.data! ? Colors.green : Colors.red,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(width: 8),

            // Popup Menu
            PopupMenuButton<String>(
              onSelected: (String choice) async {
                if (choice == 'Offline Mode') {
                  // Handle offline mode
                } else if (choice == 'About') {
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
                    value: 'Offline Mode',
                    child: Text('Offline Mode'),
                  ),
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

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
} 