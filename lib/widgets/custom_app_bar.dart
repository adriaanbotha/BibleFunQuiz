import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showActions;
  final bool showLeading;
  final List<Widget>? additionalActions;

  const CustomAppBar({
    Key? key,
    this.title = 'Bible Quiz',
    this.showActions = true,
    this.showLeading = true,
    this.additionalActions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => AppBar(
        backgroundColor: const Color(0xFFFF9800),
        elevation: 4,
        leading: showLeading ? _buildLeadingButton(context) : null,
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            _buildConnectivityIndicator(),
          ],
        ),
        actions: showActions ? _buildActions(context) : null,
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        final ScaffoldState? scaffold = Scaffold.maybeOf(context);
        if (scaffold != null) {
          scaffold.openDrawer();
        }
      },
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }

  Widget _buildConnectivityIndicator() {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, child) {
        return Tooltip(
          message: connectivity.isOnline ? 'Online' : 'Offline',
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: connectivity.isOnline ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              connectivity.isOnline ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      // Share Button
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.share),
          tooltip: 'Share App',
          onPressed: () {
            _showShareDialog(context);
          },
        ),
      ),

      // Invite Button
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.person_add),
          tooltip: 'Invite Friends',
          onPressed: () {
            _showInviteDialog(context);
          },
        ),
      ),

      // Optional additional actions
      if (additionalActions != null) ...additionalActions!,

      // Overflow Menu
      Builder(
        builder: (context) => PopupMenuButton<String>(
          onSelected: (value) => _handleMenuSelection(context, value),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'offline_mode',
              child: ListTile(
                leading: Icon(Icons.offline_bolt),
                title: Text('Offline Mode'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'about',
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'offline_mode':
        _toggleOfflineMode(context);
        break;
      case 'about':
        _showAboutDialog(context);
        break;
    }
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Bible Quiz'),
          content: const Text(
            'Share this app with your friends and family to help spread God\'s Word!',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Share'),
              onPressed: () {
                // Implement share functionality
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invite Friends'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter room code to join a game:'),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room Code',
                  hintText: 'Enter 4-digit code',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Join'),
              onPressed: () {
                // Implement join room functionality
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleOfflineMode(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Offline Mode'),
          content: const Text(
            'Would you like to download questions for offline use?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Download'),
              onPressed: () {
                // Implement offline mode functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Questions downloaded for offline use'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Bible Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Version: 1.0.0'),
              SizedBox(height: 8),
              Text('A fun and educational Bible quiz app for all ages!'),
              SizedBox(height: 16),
              Text('Made with ❤️ for God\'s glory'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
} 