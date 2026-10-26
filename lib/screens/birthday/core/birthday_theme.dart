import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Birthday-specific visual theme. Used ONLY inside the Birthday module.
/// Does NOT modify the global VoworaTheme.
class BirthdayTheme {
  // Birthday Color Palette
  static const Color warmIvory = Color(0xFFFAF5F2);
  static const Color champagneBeige = Color(0xFFEADBCF);
  static const Color roseBeige = Color(0xFFD9B7A7);
  static const Color mutedGold = Color(0xFFB28A63);
  static const Color deepCocoa = Color(0xFF382923);
  static const Color softWhite = Color(0xFFFFFFFF);
  static const Color subtleBorder = Color(0xFFE9D9D2);
  static const Color cardBg = Color(0xFFFFFAF8);
  static const Color successGreen = Color(0xFF6BAF7A);
  static const Color alertOrange = Color(0xFFE8A455);
  static const Color errorRed = Color(0xFFD46B6B);

  // Text Styles
  static TextStyle heading1 = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: deepCocoa,
    height: 1.3,
  );

  static TextStyle heading2 = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: deepCocoa,
    height: 1.3,
  );

  static TextStyle heading3 = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: deepCocoa,
    height: 1.3,
  );

  static TextStyle subtitle = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    color: deepCocoa.withValues(alpha: 0.6),
    height: 1.5,
  );

  static TextStyle body = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    color: deepCocoa,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    color: deepCocoa.withValues(alpha: 0.7),
    height: 1.4,
  );

  static TextStyle label = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: mutedGold,
    letterSpacing: 0.5,
  );

  static TextStyle buttonText = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.3,
  );

  // Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [softWhite, cardBg],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: roseBeige.withValues(alpha: 0.28), width: 0.8),
    boxShadow: [
      BoxShadow(
        color: roseBeige.withValues(alpha: 0.12),
        blurRadius: 18,
        offset: const Offset(0, 7),
      ),
    ],
  );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [softWhite, cardBg],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: roseBeige.withValues(alpha: 0.36), width: 0.8),
    boxShadow: [
      BoxShadow(
        color: deepCocoa.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 9),
      ),
    ],
  );

  static InputDecoration inputDecoration(
    String label, {
    String? hint,
    IconData? icon,
  }) => InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: icon != null ? Icon(icon, color: mutedGold, size: 20) : null,
    labelStyle: GoogleFonts.plusJakartaSans(
      color: deepCocoa.withValues(alpha: 0.6),
      fontSize: 13,
    ),
    hintStyle: GoogleFonts.plusJakartaSans(
      color: deepCocoa.withValues(alpha: 0.3),
      fontSize: 14,
    ),
    filled: true,
    fillColor: warmIvory,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: subtleBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: subtleBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: mutedGold, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: errorRed, width: 1.5),
    ),
  );

  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: mutedGold,
    foregroundColor: softWhite,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: buttonText,
  );

  static ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
    foregroundColor: mutedGold,
    side: const BorderSide(color: mutedGold),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: buttonText,
  );

  /// Birthday hero image asset path
  static const String heroImage = 'assets/images/birthday/birthday_hero.jpg';

  /// Theme image paths
  static String themeImage(String key) =>
      'assets/images/birthday/theme_$key.jpg';

  /// Feature image paths
  static String featureImage(String key) => 'assets/images/birthday/$key.jpg';

  /// Builds an Image.asset with graceful fallback
  static Widget assetImage(
    String path, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [champagneBeige, roseBeige.withValues(alpha: 0.5)],
            ),
          ),
          child: const Center(
            child: Icon(Icons.cake_rounded, color: mutedGold, size: 40),
          ),
        );
      },
    );
  }
}
