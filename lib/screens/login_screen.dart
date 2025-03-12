import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../services/upstash_service.dart' as upstash; // Added import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final data =
        await upstash.UpstashService.loadPlayerData(_emailController.text);
    print('Retrieved login data: $data');

    if (data != null) {
      print('Stored password: ${data['password']}');
      print('Entered password: ${_passwordController.text}');

      if (data['password'] == _passwordController.text) {
        String username = data['username'];
        String email = data['email'];
        String token = 'token-${DateTime.now().millisecondsSinceEpoch}';

        globals.currentUsername = username;
        globals.currentEmail = email;
        globals.authToken = token;
        globals.isLoggedIn = true;

        await globals.savePlayerData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Removed const
            content: const Text(
                'Welcome back! You’ve successfully logged in. Enjoy your journey!'),
            backgroundColor: Colors.orange[700],
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        globals.navigatorKey.currentState?.pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Removed const
            content: const Text(
                'Oops! It seems your email or password is incorrect. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // Removed const
          content: const Text(
              'Oops! It seems your email or password is incorrect. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
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
              ElevatedButton(
                onPressed: _login,
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
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  globals.navigatorKey.currentState?.pushNamed('/registration');
                },
                child: Text(
                  // Removed const
                  'Don’t have an account? Register here',
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
