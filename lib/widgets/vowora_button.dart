import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/vowora_theme.dart';

class VoworaPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool showArrow;

  const VoworaPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: VoworaColors.champagneGold,
          foregroundColor: const Color(0xFF1E1610),
          disabledBackgroundColor: VoworaColors.champagneGold.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E1610)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: const Color(0xFF1E1610),
                    ),
                  ),
                  if (showArrow) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}

class VoworaOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool showArrow;
  final Color textColor;
  final Color borderColor;

  const VoworaOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.showArrow = false,
    this.textColor = Colors.white,
    this.borderColor = const Color(0x66FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}

class VoworaSocialButton extends StatelessWidget {
  final String text;
  final Widget iconWidget;
  final VoidCallback onPressed;

  const VoworaSocialButton({
    super.key,
    required this.text,
    required this.iconWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0x44FFFFFF), width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          backgroundColor: Colors.white.withValues(alpha: 0.04),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
