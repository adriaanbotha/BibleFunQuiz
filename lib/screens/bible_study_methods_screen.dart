import 'package:flutter/material.dart';

class BibleStudyMethodsScreen extends StatelessWidget {
  const BibleStudyMethodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible Study Methods'),
        backgroundColor: const Color(0xFFFF9800),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kids Section
            _buildSection(
              'For Kids',
              const Color(0xFFFF6B35),
              Icons.child_care,
              [
                _buildMethodCard(
                  'Inductive Bible Study',
                  'Observe, interpret, apply—start with the text, understand its meaning, and connect it to life.',
                  'Example: "What did Noah do?" "Why did God save Noah?" "How can we obey God like Noah?"',
                ),
                _buildMethodCard(
                  'Topical Study',
                  'Explore a theme (like love or faith) across the Bible.',
                  'Example: "What does the Bible say about helping others?" "What does the rainbow mean?"',
                ),
                _buildMethodCard(
                  'Character Study',
                  'Focus on a person\'s life, actions, and lessons.',
                  'Example: "Who was David?" "What did David do to Goliath?" "Why did David trust God?"',
                ),
                _buildMethodCard(
                  'Narrative Study',
                  'Treat the Bible as a story with plot, characters, and outcomes.',
                  'Example: "What happened when Jonah ran from God?" "What made the walls fall?" "How did they feel?"',
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Adults Section
            _buildSection(
              'For Adults',
              const Color(0xFFFF9800),
              Icons.book,
              [
                _buildMethodCard(
                  'Verse-by-Verse Study',
                  'Analyze each verse in a passage for deeper understanding.',
                  'Example: Study John 11:35 verse by verse, understanding the context and meaning.',
                ),
                _buildMethodCard(
                  'Word Study',
                  'Explore the meaning of specific words in their original context.',
                  'Example: Study the meaning of "faith" in Hebrews 11.',
                ),
                _buildMethodCard(
                  'Devotional Method',
                  'Reflect on Scripture for personal growth and application.',
                  'Example: Read Daniel 6 and reflect on personal application.',
                ),
                _buildMethodCard(
                  'Historical-Cultural Method',
                  'Study the historical and cultural context of passages.',
                  'Example: Understand the cultural context of Matthew 23.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Color color, IconData icon, List<Widget> methods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...methods,
      ],
    );
  }

  Widget _buildMethodCard(String title, String description, String example) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      example,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 