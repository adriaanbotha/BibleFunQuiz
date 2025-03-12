import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class WhichScreenChurch extends StatelessWidget {
  const WhichScreenChurch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Which Church?', style: TextStyle(color: Colors.white)),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Select a Church to Learn More',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              // Add church selection logic here
            ],
          ),
        ),
      ),
    );
  }
}
