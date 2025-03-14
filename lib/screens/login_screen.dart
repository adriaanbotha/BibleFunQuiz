import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isRegistering = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      debugPrint('Form submitted:');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Password: ${_passwordController.text}');
      debugPrint('Mode: ${_isRegistering ? 'Registration' : 'Login'}');
      
      try {
        bool success;
        if (_isRegistering) {
          debugPrint('Attempting registration...');
          success = await widget.authService.register(
            _emailController.text,
            _passwordController.text,
          );
          
          // Print debug info
          await widget.authService.printUserStatus(_emailController.text);
          
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful! Please log in.'),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {
              _isRegistering = false;
              _passwordController.clear();
            });
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Registration failed. Email might be already registered or network issues.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } else {
          debugPrint('Attempting login...');
          success = await widget.authService.login(
            _emailController.text,
            _passwordController.text,
          );
          
          // Print debug info
          await widget.authService.printUserStatus(_emailController.text);
          
          if (success && mounted) {
            debugPrint('Login successful, navigating to home screen');
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Login failed. Please check your credentials or network connection.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('Error during ${_isRegistering ? 'registration' : 'login'}: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      debugPrint('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Register' : 'Login'),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // App Logo or Icon
                const Icon(
                  Icons.quiz,
                  size: 100,
                  color: Color(0xFFFF9800),
                ),
                const SizedBox(height: 40),
                // Title
                Text(
                  _isRegistering ? 'Create Account' : 'Welcome Back!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if (!value!.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    if (_isRegistering && (value?.length ?? 0) < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isRegistering ? 'Register' : 'Login'),
                ),
                const SizedBox(height: 16),
                // Toggle Button
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isRegistering = !_isRegistering;
                          });
                        },
                  child: Text(
                    _isRegistering
                        ? 'Already have an account? Login'
                        : 'Don\'t have an account? Register',
                  ),
                ),
                // Debug Buttons (only in debug mode)
                if (kDebugMode) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const Text(
                    'Debug Options',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.authService.listAllUsers();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Debug: List Users'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await widget.authService.clearAllUsers();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Debug: Clear Users'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
