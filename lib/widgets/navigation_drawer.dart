import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/instructions_screen.dart';
import '../screens/unification_screen.dart';
import '../theme/theme.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: const Text(
              'Bible Funz Quiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Instructions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InstructionsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Unification of the Church'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UnificationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
} 