import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_ecosystem_provider.dart';
import '../../routes/app_routes.dart';

class JoinWeddingScreen extends StatefulWidget {
  const JoinWeddingScreen({super.key});

  @override
  State<JoinWeddingScreen> createState() => _JoinWeddingScreenState();
}

class _JoinWeddingScreenState extends State<JoinWeddingScreen> {
  final TextEditingController _codeCtrl = TextEditingController(text: 'WED-8F42K9');

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verifyAndJoin() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid Secret Wedding Code')),
      );
      return;
    }

    final WeddingEcosystemProvider provider = Provider.of<WeddingEcosystemProvider>(context, listen: false);
    final bool isJoined = (await provider.joinWeddingByCode(code)) == true;

    if (!mounted) return;

    if (isJoined) {
      Navigator.pushReplacementNamed(context, AppRoutes.guestWeddingPage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Secret Code "$code". No wedding found in Supabase for this code.'),
          backgroundColor: VoworaColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VoworaColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Join Wedding Event 💌',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wedding_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.75),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: VoworaColors.champagneGold.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: VoworaColors.champagneGold, width: 2),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: VoworaColors.champagneGold,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      'Enter Secret Event Code 🔐',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Enter the Secret Event Code (e.g. WED-8F42K9) provided by the host to unlock the upcoming event details, schedule, venue map, gallery & RSVP.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: VoworaColors.champagneGold,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Event Code Input Box
                  TextField(
                    controller: _codeCtrl,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. WED-8F42K9',
                      hintStyle: GoogleFonts.playfairDisplay(
                        color: Colors.white38,
                        fontSize: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: VoworaColors.champagneGold.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick Demo Code Chips with Responsive Wrap
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      Text('Sample Codes: ', style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 11)),
                      ActionChip(
                        label: const Text('WED-8F42K9', style: TextStyle(color: VoworaColors.champagneGold, fontSize: 11, fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.white10,
                        side: const BorderSide(color: VoworaColors.champagneGold),
                        onPressed: () {
                          setState(() => _codeCtrl.text = 'WED-8F42K9');
                        },
                      ),
                      ActionChip(
                        label: const Text('WED-2026-0001', style: TextStyle(color: VoworaColors.champagneGold, fontSize: 11, fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.white10,
                        side: const BorderSide(color: VoworaColors.champagneGold),
                        onPressed: () {
                          setState(() => _codeCtrl.text = 'WED-2026-0001');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _verifyAndJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VoworaColors.champagneGold,
                        foregroundColor: const Color(0xFF141210),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Text(
                        'Verify & Join Event',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Alternative QR Code Simulation Button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _codeCtrl.text = 'WED-8F42K9';
                        _verifyAndJoin();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.qr_code, size: 18),
                      label: const Text('Scan QR Code Demo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
