import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/instructions_screen.dart';
import '../screens/login_screen.dart';
import '../screens/which_church_screen.dart';
import '../screens/gospel_screen.dart';

class AppDrawer extends StatelessWidget {
  final AuthService authService;
  final SettingsService settingsService;
  final VoidCallback onClose;

  const AppDrawer({
    Key? key,
    required this.authService,
    required this.settingsService,
    required this.onClose,
  }) : super(key: key);

  Future<void> _handleNavigation(BuildContext context, Widget screen) async {
    onClose(); // Close the drawer
    // Wait for the drawer animation to complete
    await Future.delayed(const Duration(milliseconds: 300));
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFFF9800),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Bible Quest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<String>(
                  future: Future.value(authService.getNickname()),
                  builder: (context, snapshot) {
                    return Text(
                      'Welcome, ${snapshot.data ?? 'User'}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => _handleNavigation(
              context,
              ProfileScreen(
                authService: authService,
                settingsService: settingsService,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.church),
            title: const Text('Which Church?'),
            onTap: () => _handleNavigation(
              context,
              const WhichChurchScreen(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('The Gospel'),
            onTap: () => _handleNavigation(
              context,
              const GospelScreen(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => _handleNavigation(
              context,
              SettingsScreen(
                settingsService: settingsService,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Instructions'),
            onTap: () => _handleNavigation(
              context,
              const InstructionsScreen(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              onClose();
              await authService.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      authService: authService,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _toggleOfflineMode(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Offline Mode'),
          content: const Text(
            'Would you like to download questions for offline use?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Download'),
              onPressed: () {
                // Implement offline mode functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Questions downloaded for offline use'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
} 