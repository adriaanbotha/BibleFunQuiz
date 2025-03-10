import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import '../services/upstash_service.dart';
import '../globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  final _upstashService = UpstashService();

  Future<void> _login() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    try {
      print('Attempting login for $email');
      final token = await _upstashService.login(email, password);
      if (token != null) {
        print('Login successful, token: $token');
        final prefs = await SharedPreferences.getInstance();
        final userData =
            await _upstashService.sendRequest('hgetall', ['user:$email']);
        print('User data: $userData');
        final username = userData[3]; // Correct index for username
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        await prefs.setString('authToken', token);
        globals.Globals.currentUsername = username;
        globals.Globals.currentEmail = email;
        globals.Globals.authToken = token;
        await globals.Globals.savePlayerData();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        setState(() => _errorMessage = 'Invalid email or password');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Connection error: $e');
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
              onPressed: _login, // Corrected from '_login'
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationScreen()),
              ),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
