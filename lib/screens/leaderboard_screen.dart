import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LeaderboardScreen extends StatefulWidget {
  final AuthService authService;

  const LeaderboardScreen({
    Key? key, 
    required this.authService,
  }) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>>? _leaderboard;
  bool _isLoading = true;
  String _selectedDifficulty = 'beginner'; // Default difficulty

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final leaderboard = await widget.authService.getLeaderboard(_selectedDifficulty);
      
      setState(() {
        _leaderboard = leaderboard;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading leaderboard: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color(0xFFFF9800),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Difficulty selector
          DropdownButton<String>(
            value: _selectedDifficulty,
            dropdownColor: const Color(0xFFFF9800),
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedDifficulty = newValue;
                });
                _loadLeaderboard();
              }
            },
            items: <String>['beginner', 'intermediate', 'advanced']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value[0].toUpperCase() + value.substring(1),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _leaderboard == null || _leaderboard!.isEmpty
              ? const Center(
                  child: Text(
                    'No scores yet. Be the first to play!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _leaderboard!.length,
                  itemBuilder: (context, index) {
                    final entry = _leaderboard![index];
                    
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFF9800),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          entry['nickname'] ?? 'Unknown',
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text('Score: ${entry['score']}'),
                        trailing: Text(
                          '${entry['score']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// Add this extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
