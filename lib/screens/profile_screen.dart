import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../utils/profanity_filter.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _email = '';
  String _nickname = '';
  String _errorMessage = '';
  String _successMessage = '';
  final _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await globals.loadPlayerData();
    setState(() {
      _email = globals.currentEmail ?? 'Not logged in';
      _nickname = globals.currentNickname ?? '';
      _nicknameController.text = _nickname;
    });
  }

  Future<void> _updateNickname() async {
    final newNickname = _nicknameController.text.trim();

    if (newNickname.isEmpty) {
      setState(() => _errorMessage = 'Nickname cannot be empty');
      return;
    }

    if (!ProfanityFilter.isValidUsername(newNickname)) {
      setState(() => _errorMessage =
          'Nickname must be 3-20 characters, alphanumeric, and no profanity');
      return;
    }

    try {
      final email = globals.currentEmail;
      if (email == null) throw Exception('No user logged in');

      globals.currentNickname = newNickname;
      await globals.savePlayerData();

      setState(() {
        _nickname = newNickname;
        _errorMessage = '';
        _successMessage = 'Nickname updated successfully!';
      });
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    }
  }

  Future<void> _logout() async {
    globals.currentUserId = null;
    globals.currentUsername = null;
    globals.currentEmail = null;
    globals.currentNickname = null;
    globals.authToken = null;
    globals.isLoggedIn = false;

    if (globals.navigatorKey.currentState != null) {
      globals.navigatorKey.currentState!.pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[700],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email: $_email',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(color: Colors.orange[200]),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateNickname,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Update Nickname'),
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (_successMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _successMessage,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
