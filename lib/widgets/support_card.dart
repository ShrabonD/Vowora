import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/vowora_constants.dart';
import '../core/theme/vowora_theme.dart';

class SupportCard extends StatelessWidget {
  final bool isDark;

  const SupportCard({
    super.key,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : VoworaColors.textPrimary;
    final subColor = isDark ? Colors.white70 : VoworaColors.textSecondary;
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : VoworaColors.champagneGold.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.12) : VoworaColors.champagneGold.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: VoworaColors.champagneGold,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Need Help?',
                style: GoogleFonts.playfairDisplay(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Our support team is here to help you with your wedding-planning journey.',
            style: GoogleFonts.plusJakartaSans(
              color: subColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.email_outlined, VoworaConstants.supportEmail, textColor),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone_outlined, VoworaConstants.supportPhone, textColor),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, VoworaConstants.supportOffice, textColor),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: VoworaColors.champagneGold),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
