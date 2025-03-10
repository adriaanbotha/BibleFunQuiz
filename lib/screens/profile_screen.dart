import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import '../services/upstash_service.dart';
import '../globals.dart' as globals;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _email = '';
  String _errorMessage = '';
  String _successMessage = '';
  final _upstashService = UpstashService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await globals.Globals.loadPlayerData();
    setState(() {
      _email = globals.Globals.currentEmail ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    globals.Globals.currentUsername = null;
    globals.Globals.currentEmail = null;
    globals.Globals.authToken = null;
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[700],
      ),
      backgroundColor: Colors.grey[900], // Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: $_email',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_errorMessage,
                    style: const TextStyle(color: Colors.red)),
              ),
            if (_successMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_successMessage,
                    style: const TextStyle(color: Colors.green)),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
