import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/profanity_filter.dart';
import 'login_screen.dart';
import '../services/upstash_service.dart';
import '../globals.dart' as globals;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
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
      _usernameController.text = globals.Globals.currentUsername ?? '';
    });
  }

  Future<void> _updateProfile() async {
    final newUsername = _usernameController.text.trim();

    if (!ProfanityFilter.isValidUsername(newUsername)) {
      setState(() => _errorMessage =
          'Username must be 3-20 characters, alphanumeric, and no profanity');
      return;
    }

    try {
      final email = globals.Globals.currentEmail;
      if (email == null) throw Exception('No user logged in');
      await _upstashService
          .sendRequest('hset', ['user:$email', 'username', newUsername]);
      globals.Globals.currentUsername = newUsername;
      await globals.Globals.savePlayerData();
      setState(() {
        _errorMessage = '';
        _successMessage = 'Profile updated successfully!';
      });
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    }
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
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $_email', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
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
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
