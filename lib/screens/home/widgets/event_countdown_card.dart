import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/vowora_theme.dart';
import '../../../models/wedding_profile.dart';
import '../../../providers/wedding_wizard_provider.dart';
import '../../../routes/app_routes.dart';

class EventCountdownCard extends StatelessWidget {
  final WeddingProfile? activeEvent;

  const EventCountdownCard({super.key, this.activeEvent});

  @override
  Widget build(BuildContext context) {
    final wizardProvider = Provider.of<WeddingWizardProvider>(context);
    final booking = wizardProvider.booking;

    final bool hasUserCreatedWedding = booking.brideName.trim().isNotEmpty && booking.isConfirmed;

    if (!hasUserCreatedWedding) {
      // ===== NEW USER WELCOME CALLOUT CARD =====
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withValues(alpha: 0.45),
              border: Border.all(
                color: VoworaColors.champagneGold.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: VoworaColors.champagneGold.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "WELCOME TO VOWORA ♡",
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.champagneGold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: VoworaColors.champagneGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'New User',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.champagneGold,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  'No Active Event Created Yet 💍',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start planning your dream wedding in 9 easy steps, or join an existing wedding using an Event Code.',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          wizardProvider.startNewBookingWizard();
                          Navigator.pushNamed(context, AppRoutes.weddingManager);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VoworaColors.champagneGold,
                          foregroundColor: const Color(0xFF141210),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: Color(0xFF141210)),
                        label: Text(
                          'Create Your Wedding',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ===== EXISTING ACTIVE WEDDING COUNTDOWN CARD =====
    final days = booking.daysUntilWedding;
    final formattedDate = DateFormat('EEEE, MMMM dd, yyyy').format(booking.weddingDate);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.black.withValues(alpha: 0.38),
            border: Border.all(
              color: VoworaColors.champagneGold.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${booking.brideName} & ${booking.groomName}',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: VoworaColors.champagneGold.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      booking.weddingId,
                      style: GoogleFonts.plusJakartaSans(
                        color: VoworaColors.champagneGold,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    days > 0 ? '$days' : '0',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Days Until\nThe Celebration',
                      style: GoogleFonts.playfairDisplay(
                        color: VoworaColors.champagneGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withValues(alpha: 0.18)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_outlined, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            formattedDate,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            booking.selectedVenue?.name ?? 'Venue Selected',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
