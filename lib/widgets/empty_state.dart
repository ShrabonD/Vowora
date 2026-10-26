import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/vowora_theme.dart';

class VoworaEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData icon;

  const VoworaEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
    this.icon = Icons.favorite_border_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: VoworaColors.dustyRose.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: VoworaColors.champagneGold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                color: VoworaColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  buttonText!,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: VoworaColors.champagneGold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
