import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF9800);
  
  static final TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static final TextStyle subtitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static final TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.5,
  );
} 