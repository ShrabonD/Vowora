import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/vowora_theme.dart';

class GuestGateDialog extends StatelessWidget {
  final VoidCallback onCreateAccount;

  const GuestGateDialog({
    super.key,
    required this.onCreateAccount,
  });

  static void show(BuildContext context, {required VoidCallback onCreateAccount}) {
    showDialog(
      context: context,
      builder: (context) => GuestGateDialog(onCreateAccount: onCreateAccount),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1917),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VoworaColors.champagneGold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: VoworaColors.champagneGold,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create your Vowora account',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Save your wedding plans, budget, guests and ideas by creating a free account.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onCreateAccount();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: VoworaColors.champagneGold,
                  foregroundColor: const Color(0xFF141210),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Create Account →',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Continue Exploring',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
