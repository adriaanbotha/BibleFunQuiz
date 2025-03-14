import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';

class ConnectivityIndicator extends StatelessWidget {
  final double size;
  final bool showLabel;

  const ConnectivityIndicator({
    Key? key,
    this.size = 16,
    this.showLabel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: connectivity.isOnline ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                connectivity.isOnline ? Icons.wifi : Icons.wifi_off,
                size: size,
                color: Colors.white,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: 4),
              Text(
                connectivity.isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: size * 0.875,
                  color: connectivity.isOnline ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
} 