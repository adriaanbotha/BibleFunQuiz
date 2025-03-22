import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../widgets/connectivity_indicator.dart';

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
  List<Map<String, dynamic>> _leaderboardData = [];
  bool _isLoading = true;
  String? _error;
  String _selectedDifficulty = 'children'; // Set default to children's quiz

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await widget.authService.getLeaderboard(_selectedDifficulty);
      setState(() {
        _leaderboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedDifficulty == 'children' 
          ? 'Children\'s Leaderboard'
          : '${_selectedDifficulty.capitalize()} Leaderboard'),
        backgroundColor: _selectedDifficulty == 'children' 
          ? const Color(0xFFFF6B35)  // Reddish-orange for children's
          : const Color(0xFFFF9800), // Regular orange for others
        actions: [
          // Difficulty selector
          DropdownButton<String>(
            value: _selectedDifficulty,
            dropdownColor: _selectedDifficulty == 'children' 
              ? const Color(0xFFFF6B35)  // Reddish-orange for children's
              : const Color(0xFFFF9800), // Regular orange for others
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
            items: <String>['children', 'beginner', 'intermediate', 'advanced']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    if (value == 'children') 
                      const Icon(Icons.child_care, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      value == 'children' 
                        ? 'Children\'s'
                        : value.capitalize(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
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
      body: Consumer<ConnectivityService>(
        builder: (context, connectivityService, child) {
          if (!connectivityService.isOnline) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Leaderboard Unavailable',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your internet connection to view the leaderboard.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const ConnectivityIndicator(
                      showLabel: true,
                      size: 24,
                    ),
                  ],
                ),
              ),
            );
          }

          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
              ),
            );
          }

          if (_error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error Loading Leaderboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadLeaderboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_leaderboardData.isEmpty) {
            return const Center(
              child: Text(
                'No leaderboard data available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: _leaderboardData.length,
            itemBuilder: (context, index) {
              final entry = _leaderboardData[index];
              return ListTile(
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
                  entry['nickname'] ?? 'Anonymous',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Score: ${entry['score'] ?? 0}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: Text(
                  '${entry['completedQuizzes'] ?? 0} quizzes',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              );
            },
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
