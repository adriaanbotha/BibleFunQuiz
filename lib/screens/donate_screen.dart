import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Donate'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildThankYouCard(),
          const SizedBox(height: 16),
          _buildDonationOption(
            'Patreon',
            'Join our family!',
            Icons.favorite,
            'https://patreon.com/biblequizapp',
          ),
          _buildDonationOption(
            'PayPal',
            'Quick and secure donation',
            Icons.payment,
            'your-paypal-link',
          ),
          _buildDonationOption(
            'Google Pay',
            'Easy mobile payment',
            Icons.g_mobiledata,
            'your-googlepay-link',
          ),
          _buildDonationOption(
            'Apple Pay',
            'Seamless iOS payment',
            Icons.apple,
            'your-applepay-link',
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Icon(
              Icons.favorite,
              color: Color(0xFFFF9800),
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for your support!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Your generosity helps us keep this app ad-free and growing. '
              'Together, we can share God\'s Word with children everywhere!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationOption(
    String title,
    String subtitle,
    IconData icon,
    String link,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF9800), size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          onPressed: () {
            // Add donation link handling
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9800),
            foregroundColor: Colors.white,
          ),
          child: const Text('Donate'),
        ),
      ),
    );
  }
} 