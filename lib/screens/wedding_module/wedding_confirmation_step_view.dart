import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';
import '../../routes/app_routes.dart';

class WeddingConfirmationStepView extends StatelessWidget {
  const WeddingConfirmationStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final booking = provider.booking;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Celebration Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: VoworaColors.champagneGold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: VoworaColors.champagneGold, width: 2.0),
            ),
            child: const Icon(
              Icons.celebration_rounded,
              color: VoworaColors.champagneGold,
              size: 54,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            '🎉 Wedding Successfully Planned!',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your wedding booking has been confirmed with official ID.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          // Confirmation Ticket / Receipt Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: VoworaColors.champagneGold, width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  'WEDDING ID',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white54,
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  booking.weddingId,
                  style: GoogleFonts.playfairDisplay(
                    color: VoworaColors.champagneGold,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Divider(color: Colors.white.withValues(alpha: 0.15)),
                const SizedBox(height: 12),

                _buildTicketRow('Couple', '${booking.brideName} & ${booking.groomName}'),
                _buildTicketRow('Wedding Date', DateFormat('MMM dd, yyyy').format(booking.weddingDate)),
                _buildTicketRow('Venue', booking.selectedVenue?.name ?? 'Radisson Garden'),
                _buildTicketRow('Expected Guests', '${booking.expectedGuestCount} Guests'),
                _buildTicketRow('Package Tier', booking.selectedPackage?.tier ?? 'Standard'),
                _buildTicketRow('Total Budget', '৳${booking.totalEstimatedCost.toStringAsFixed(0)}'),
                _buildTicketRow('Booking Status', 'CONFIRMED ✓'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Buttons
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.weddingDashboard,
                  (route) => route.isFirst,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Go to Wedding Dashboard',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    provider.setStep(13); // View Details Summary
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                  ),
                  icon: const Icon(Icons.receipt_long_rounded, size: 16),
                  label: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wedding Booking Link Copied! 🔗')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: VoworaColors.champagneGold),
                  ),
                  icon: const Icon(Icons.share_rounded, size: 16, color: VoworaColors.champagneGold),
                  label: const Text('Share Wedding'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 12)),
          Text(val, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
