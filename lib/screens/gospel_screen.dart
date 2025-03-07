import 'package:flutter/material.dart';

class GospelScreen extends StatelessWidget {
  const GospelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Gospel of Jesus Christ'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/cross.jpg', // Updated path
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'The Good News of Jesus Christ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'The Gospel, or "Good News," is the message of God’s love and plan for humanity:\n\n'
                  '1. God Loves You:\n'
                  '   - God created you and loves you deeply (John 3:16). He desires a relationship with you.\n\n'
                  '2. Sin Separates Us:\n'
                  '   - All have sinned and fall short of God’s glory (Romans 3:23). Sin separates us from Him, leading to spiritual death (Romans 6:23).\n\n'
                  '3. Jesus Paid the Price:\n'
                  '   - God sent His Son, Jesus Christ, to live a sinless life, die on the cross for our sins, and rise again on the third day (1 Corinthians 15:3-4). His sacrifice bridges the gap between us and God.\n\n'
                  '4. Salvation Through Faith:\n'
                  '   - By believing in Jesus and accepting Him as your Savior, you receive forgiveness and eternal life (John 1:12, Ephesians 2:8-9). It’s a free gift—trust in Him today!\n\n'
                  'How to Respond:\n'
                  '   - Pray: Admit your need for Jesus, believe He died and rose for you, and ask Him to be your Lord and Savior.\n'
                  '   - "If you confess with your mouth, “Jesus is Lord,” and believe in your heart that God raised Him from the dead, you will be saved" (Romans 10:9).\n\n'
                  'This is the heart of Bible Quest—knowing Jesus and growing in faith through His Word!',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
