import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../services/upstash_service.dart' as upstash;

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
        const SnackBar(
          content: Text('Passwords do not match. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
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

      // Pass the password to savePlayerData to preserve it
      await upstash.UpstashService.savePlayerData(
        username: username,
        email: email,
        authToken: token,
        nickname: username, // Initialize nickname
        password: _passwordController.text, // Preserve password
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Thank you! Your account has been created. Please log in to proceed.'),
          backgroundColor: globals.primaryColor,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      globals.navigatorKey.currentState?.pushReplacementNamed('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'We apologize, registration failed. This email may already be in use.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: globals.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                globals.navigatorKey.currentState?.pushNamed('/login');
              },
              child: const Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}
