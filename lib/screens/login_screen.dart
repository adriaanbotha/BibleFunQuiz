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
        final username = userData[1]; // Email is at index 1
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
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
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
                      'Welcome to Bible Quest',
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
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()),
                      ),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.orange[200]),
                      child: const Text('Register'),
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
