import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Bible Fun Quiz'),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thank you message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Color(0xFFFF9800),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Thank you for your support!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your generosity helps us keep Bible Fun Quiz ad-free and growing, sharing God\'s Word with kids everywhere!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF424242),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Patreon Section
              _buildDonationSection(
                'Join Our Patreon Family',
                'Support us monthly and get exclusive benefits!',
                Icons.pets,
                () => _launchUrl('https://patreon.com/AdriaanBotha'),
              ),
              const SizedBox(height: 16),

              // Payment Options
              _buildDonationSection(
                'One-Time Donation',
                'Choose your preferred payment method',
                Icons.payment,
                () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildPaymentOptions(context),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Crypto Donations
              _buildDonationSection(
                'Crypto Donations',
                'Support us with cryptocurrency',
                Icons.currency_bitcoin,
                () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildCryptoOptions(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationSection(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFFF9800),
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF757575),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Payment Method',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            'PayPal',
            Icons.payment,
            () => _launchUrl('https://paypal.me/biblequest'),
          ),
          _buildPaymentOption(
            'Stripe',
            Icons.credit_card,
            () => _launchUrl('https://stripe.com/biblequest'),
          ),
          _buildPaymentOption(
            'Google Pay',
            Icons.payment,
            () => _launchUrl('https://pay.google.com/biblequest'),
          ),
          _buildPaymentOption(
            'Apple Pay',
            Icons.apple,
            () => _launchUrl('https://applepay.biblequest'),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Crypto Payment Options',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            'BitPay',
            Icons.currency_bitcoin,
            () => _launchUrl('https://bitpay.com/biblequest'),
          ),
          _buildPaymentOption(
            'NOWPayments',
            Icons.payment,
            () => _launchUrl('https://nowpayments.io/payment-tools'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF9800)),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF212121),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFF757575),
        size: 16,
      ),
      onTap: onTap,
    );
  }
} 