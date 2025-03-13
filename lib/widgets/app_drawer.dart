import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String? nickname;

  const AppDrawer({Key? key, this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                _buildMenuItem(
                  icon: Icons.leaderboard,
                  title: 'Leaderboard',
                  onTap: () => Navigator.pushNamed(context, '/leaderboard'),
                ),
                _buildMenuItem(
                  icon: Icons.help,
                  title: 'Instructions',
                  onTap: () => Navigator.pushNamed(context, '/instructions'),
                ),
                _buildMenuItem(
                  icon: Icons.church,
                  title: 'Which Church',
                  onTap: () => Navigator.pushNamed(context, '/which-church'),
                ),
                _buildMenuItem(
                  icon: Icons.book,
                  title: 'Gospel',
                  onTap: () => Navigator.pushNamed(context, '/gospel'),
                ),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: 'Donate',
                  onTap: () => Navigator.pushNamed(context, '/donate'),
                ),
                const Divider(),
                _buildMenuItem(
                  icon: Icons.offline_bolt,
                  title: 'Offline Mode',
                  onTap: () => _toggleOfflineMode(context),
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // Add logout logic here
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
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