import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final AuthService authService;

  const AppDrawer({
    Key? key,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = authService.isLoggedIn();
    final nickname = authService.getNickname();

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(nickname),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                ),
                if (isLoggedIn) ...[
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context); // Close drawer first
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.leaderboard,
                    title: 'Leaderboard',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/leaderboard');
                    },
                  ),
                ],
                _buildMenuItem(
                  icon: Icons.help,
                  title: 'Instructions',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/instructions');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.church,
                  title: 'Which Church',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/which-church');
                  },
                ),
                _buildMenuItem(
                  icon: Icons.book,
                  title: 'Gospel',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/gospel');
                  },
                ),
                const Divider(),
                if (isLoggedIn)
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () async {
                      await authService.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                  )
                else
                  _buildMenuItem(
                    icon: Icons.login,
                    title: 'Login',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(String? nickname) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color(0xFFFF9800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 35,
              color: Color(0xFFFF9800),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Welcome${nickname != null ? ", $nickname" : ""}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Bible Quiz App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF9800)),
      title: Text(title),
      onTap: onTap,
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