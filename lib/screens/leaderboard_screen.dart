import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Leaderboard'),
      body: Column(
        children: [
          _buildLeaderboardHeader(),
          Expanded(
            child: _buildLeaderboardList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFFFF9800),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text('Rank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Player', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      itemCount: 20, // Example count
      itemBuilder: (context, index) {
        return _buildLeaderboardItem(index + 1, 'Player ${index + 1}', (1000 - index * 50));
      },
    );
  }

  Widget _buildLeaderboardItem(int rank, String name, int score) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rank <= 3 ? const Color(0xFFFF9800) : Colors.grey[300],
          child: Text(
            rank.toString(),
            style: TextStyle(
              color: rank <= 3 ? Colors.white : Colors.black,
            ),
          ),
        ),
        title: Text(name),
        trailing: Text(
          score.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
