import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/profanity_filter.dart';
import 'login_screen.dart';
import '../services/upstash_service.dart';
import '../globals.dart' as globals;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  late final _upstashService = UpstashService();

  @override
  void dispose() {
    _upstashService.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim().toLowerCase();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => _errorMessage = 'Invalid email format');
      return;
    }

    if (!ProfanityFilter.isValidUsername(username)) {
      setState(() => _errorMessage =
          'Username must be 3-20 characters, alphanumeric, and no profanity');
      return;
    }

    try {
      print('Testing Upstash connectivity');
      await _upstashService.testConnectivity();
      print('Connectivity test passed');

      print('Registering user: $email');
      final token = await _upstashService.register(email, password);
      print('Registration token: $token');
      if (token != null) {
        print('Setting username: $username');
        await _upstashService
            .sendRequest('hset', ['user:$email', 'username', username]);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        await prefs.setString('authToken', token);
        globals.Globals.currentUsername = username;
        globals.Globals.currentEmail = email;
        globals.Globals.authToken = token;
        await globals.Globals.savePlayerData();
        print('Navigating to LoginScreen');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        setState(() =>
            _errorMessage = 'Email already registered or registration failed');
        print('Registration failed: Token is null');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
      print('Registration error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[700],
      ),
      backgroundColor: Colors.grey[900], // Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.grey[800], // Dark card background
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Join Bible Quest',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.orange[200]),
                        filled: true,
                        fillColor: Colors.grey[700],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
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
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.orange[200]),
                        filled: true,
                        fillColor: Colors.grey[700],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(_errorMessage,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      ),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.orange[200]),
                      child: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
