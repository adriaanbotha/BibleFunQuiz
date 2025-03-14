import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../services/profanity_filter.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService;

  const ProfileScreen({
    Key? key,
    required this.authService,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nicknameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.authService.getNickname() ?? '';
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _updateNickname() async {
    final newNickname = _nicknameController.text.trim();
    if (newNickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nickname cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (ProfanityFilter.containsProfanity(newNickname)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose an appropriate nickname'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final email = widget.authService.getCurrentEmail();
    if (email != null) {
      final success = await widget.authService.updateNickname(email, newNickname);
      if (mounted) {
        if (success) {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nickname updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update nickname'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFFF9800),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildNicknameSection(),
              const SizedBox(height: 30),
              _buildProfileCard(
                title: 'Statistics',
                children: [
                  _buildStatItem('Total Quizzes', '0'),
                  _buildStatItem('Correct Answers', '0'),
                  _buildStatItem('High Score', '0'),
                ],
              ),
              const SizedBox(height: 20),
              _buildProfileCard(
                title: 'Achievements',
                children: [
                  _buildAchievement('First Quiz', 'Complete your first quiz'),
                  _buildAchievement('Perfect Score', 'Get all answers correct'),
                  _buildAchievement('Quiz Master', 'Complete 10 quizzes'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNicknameSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nickname',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.save : Icons.edit),
                  onPressed: () {
                    if (_isEditing) {
                      _updateNickname();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isEditing)
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter new nickname',
                ),
                maxLength: 20,
              )
            else
              Text(
                _nicknameController.text,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievement(String title, String description) {
    return ListTile(
      leading: const Icon(
        Icons.star_border,
        color: Color(0xFFFF9800),
      ),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}
