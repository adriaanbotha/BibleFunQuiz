import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RouteGuard {
  static Future<bool> checkAuth(BuildContext context, AuthService authService) async {
    if (!authService.isLoggedIn()) {
      // Show a message and redirect to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to access this feature'),
          backgroundColor: Colors.orange,
        ),
      );
      
      await Navigator.pushNamed(context, '/login');
      return false;
    }
    return true;
  }
} 