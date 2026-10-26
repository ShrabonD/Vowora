import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/vowora_theme.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Terms & Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vowora Terms of Service',
              style: GoogleFonts.playfairDisplay(
                color: VoworaColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Welcome to VOWORA ("Plan beautifully. Celebrate endlessly."). By using our smart wedding planner application, you agree to comply with and be bound by the following terms of service.',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('1. User Account & Data Privacy'),
            _buildSectionBody(
              'Your privacy is deeply important to us. Account profile information, wedding guest lists, budget details, and vendor contacts are stored securely in Supabase PostgreSQL database schemas with Row Level Security (RLS) enforcement.',
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('2. Guest Mode & Authentication'),
            _buildSectionBody(
              'Vowora allows guest mode exploration. Data created in guest mode is cached locally. To ensure permanent data persistence across devices, users must register a free account.',
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('3. Support & Project Ownership'),
            _buildSectionBody(
              'This software product was constructed as a university final project demonstration. For support inquiries, contact support@vowora.app.',
            ),
            const SizedBox(height: 28),
            Text(
              'Privacy Policy',
              style: GoogleFonts.playfairDisplay(
                color: VoworaColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildSectionBody(
              'Vowora does not sell, rent, or distribute personal information to third parties. OAuth login integrations (Google, Apple, Facebook) process authentication securely through Supabase Auth.',
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: VoworaColors.champagneGold,
                  foregroundColor: const Color(0xFF141210),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        color: VoworaColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionBody(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: VoworaColors.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}
