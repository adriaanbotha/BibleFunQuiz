import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../services/upstash_service.dart' as upstash;

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
          const SnackBar(
            content: Text(
                'Welcome back! You’ve successfully logged in. Enjoy your journey!'),
            backgroundColor: globals.primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        globals.navigatorKey.currentState?.pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Oops! It seems your email or password is incorrect. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Oops! It seems your email or password is incorrect. Please try again.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                globals.navigatorKey.currentState?.pushNamed('/registration');
              },
              child: const Text('Don’t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
