import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../services/upstash_service.dart' as upstash; // Added import

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // Removed const
          content: const Text('Passwords do not match. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool registrationSuccess = await upstash.UpstashService.registerUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _emailController.text.split('@')[0],
    );

    if (registrationSuccess) {
      String username = _emailController.text.split('@')[0];
      String email = _emailController.text;
      String token = 'token-${DateTime.now().millisecondsSinceEpoch}';

      globals.currentUsername = username;
      globals.currentEmail = email;
      globals.authToken = token;
      globals.isLoggedIn = true;

      await upstash.UpstashService.savePlayerData(
        username: username,
        email: email,
        authToken: token,
        nickname: username,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // Removed const
          content: const Text(
              'Thank you! Your account has been created. Please log in to proceed.'),
          backgroundColor: Colors.orange[700],
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      globals.navigatorKey.currentState?.pushReplacementNamed('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // Removed const
          content: const Text(
              'We apologize, registration failed. This email may already be in use.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white)),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  globals.navigatorKey.currentState?.pushNamed('/login');
                },
                child: Text(
                  // Removed const
                  'Already have an account? Login here',
                  style: TextStyle(color: Colors.orange[200]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
