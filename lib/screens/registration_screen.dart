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
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_errorMessage,
                    style: const TextStyle(color: Colors.red)),
              ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
