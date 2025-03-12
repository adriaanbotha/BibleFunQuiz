import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class GospelScreen extends StatelessWidget {
  const GospelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Gospel Journey', style: TextStyle(color: Colors.white)),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Removed const
              const Text(
                'Gospel of John Chapter 1 (NIV)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '1 In the beginning was the Word, and the Word was with God, and the Word was God. 2 He was with God in the beginning. 3 Through him all things were made; without him nothing was made that has been made...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Continue reading the Gospel to deepen your understanding of Jesus\' life and teachings!',
                style: TextStyle(
                  color: Colors.orange[200],
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
