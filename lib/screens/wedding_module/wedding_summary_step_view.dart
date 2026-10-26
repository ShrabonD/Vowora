import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';

class WeddingSummaryStepView extends StatelessWidget {
  const WeddingSummaryStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final booking = provider.booking;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 13: Wedding Summary 📝',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Review all selections before final confirmation.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Summary Card Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: VoworaColors.champagneGold, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryHeader('Couple', () => provider.setStep(1)),
                Text(
                  '${booking.brideName} ❤️ ${booking.groomName}',
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Phone: ${booking.bridePhone}',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 11)),
                const SizedBox(height: 14),

                _buildSummaryHeader('Date & Schedule', () => provider.setStep(1)),
                Text(
                  '${DateFormat('EEEE, MMMM dd, yyyy').format(booking.weddingDate)} • ${booking.weddingTime}',
                  style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),

                _buildSummaryHeader('Selected Venue', () => provider.setStep(2)),
                Text(
                  booking.selectedVenue?.name ?? 'No Venue Selected',
                  style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text('Location: ${booking.selectedVenue?.location ?? 'Dhaka'}',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 11)),
                const SizedBox(height: 14),

                _buildSummaryHeader('Guest Count & Catering', () => provider.setStep(5)),
                Text(
                  '${booking.expectedGuestCount} Guests • ${booking.selectedCateringPackage?.packageName ?? 'Standard Menu'}',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 14),

                _buildSummaryHeader('Decoration & Theme', () => provider.setStep(4)),
                Text(
                  booking.selectedDecorations.map((d) => d.name).join(', '),
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 14),

                _buildSummaryHeader('Photography & Entertainment', () => provider.setStep(7)),
                Text(
                  '${booking.selectedMediaServices.length} Media Services • ${booking.selectedEntertainment.length} Entertainment Acts',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Divider(color: VoworaColors.champagneGold.withValues(alpha: 0.3)),
                const SizedBox(height: 12),

                // Financials Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Budget: ৳${booking.totalPlannedBudget.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12)),
                    Text('Total Cost: ৳${booking.totalEstimatedCost.toStringAsFixed(0)}', style: GoogleFonts.playfairDisplay(color: VoworaColors.champagneGold, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Paid: ৳${booking.totalPaidAmount.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF6FCFB0), fontSize: 12)),
                    Text('Remaining: ৳${booking.remainingBalance.toStringAsFixed(0)}', style: GoogleFonts.playfairDisplay(color: VoworaColors.champagneGold, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons: Edit or Confirm Wedding
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                provider.confirmWeddingBooking(); // Confirm & generate unique WED-2026-0001
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                elevation: 8,
              ),
              child: Text(
                '🎉 Confirm Wedding Booking',
                style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(String title, VoidCallback onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.toUpperCase(), style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        InkWell(
          onTap: onEdit,
          child: Text('Edit', style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 11, decoration: TextDecoration.underline)),
        ),
      ],
    );
  }
}
