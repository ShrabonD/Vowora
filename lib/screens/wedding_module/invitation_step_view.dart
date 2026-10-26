import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_booking_model.dart';
import '../../providers/wedding_wizard_provider.dart';

class InvitationStepView extends StatelessWidget {
  const InvitationStepView({super.key});

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
            'Step 11: Digital Invitation 💌',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Customize your digital royal wedding card & RSVP link.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Theme Selector Pills
          Text(
            'INVITATION THEME',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: InvitationTheme.values.map((theme) {
                final isSel = booking.invitationTheme == theme;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      provider.updateInvitationDesign(theme, booking.fontStyle);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSel ? VoworaColors.champagneGold : Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSel ? VoworaColors.champagneGold : Colors.white24,
                        ),
                      ),
                      child: Text(
                        theme.name.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: isSel ? const Color(0xFF141210) : Colors.white,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Upload Photos From Gallery Bar
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: provider.pickBridePhoto,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: VoworaColors.champagneGold,
                    side: const BorderSide(color: VoworaColors.champagneGold, width: 0.8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: const Icon(Icons.female_rounded, size: 16),
                  label: const FittedBox(child: Text('Bride Photo', style: TextStyle(fontSize: 11))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: provider.pickGroomPhoto,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: VoworaColors.champagneGold,
                    side: const BorderSide(color: VoworaColors.champagneGold, width: 0.8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: const Icon(Icons.male_rounded, size: 16),
                  label: const FittedBox(child: Text('Groom Photo', style: TextStyle(fontSize: 11))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: provider.pickCoverPhoto,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: VoworaColors.champagneGold,
                    side: const BorderSide(color: VoworaColors.champagneGold, width: 0.8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: const Icon(Icons.add_photo_alternate_rounded, size: 16),
                  label: const FittedBox(child: Text('Cover Photo', style: TextStyle(fontSize: 11))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Digital Card Interactive Preview Box
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF231B15),
                  const Color(0xFF120E0C),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: VoworaColors.champagneGold, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: VoworaColors.champagneGold.withValues(alpha: 0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'YOU ARE CORDIALLY INVITED TO CELEBRATE',
                  style: GoogleFonts.plusJakartaSans(
                    color: VoworaColors.champagneGold,
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Couple Photos Preview Avatar Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAvatarCircle(booking.bridePhotoUrl, Icons.female_rounded),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('❤️', style: GoogleFonts.playfairDisplay(fontSize: 20)),
                    ),
                    _buildAvatarCircle(booking.groomPhotoUrl, Icons.male_rounded),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  '${booking.brideName}\n&\n${booking.groomName}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: VoworaColors.champagneGold.withValues(alpha: 0.4)),
                const SizedBox(height: 12),
                Text(
                  '📅 ${DateFormat('EEEE, MMMM dd, yyyy').format(booking.weddingDate)} • ${booking.weddingTime}',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '📍 ${booking.selectedVenue?.name ?? 'Radisson Blu'}, ${booking.selectedVenue?.location ?? 'Dhaka'}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 11),
                ),
                const SizedBox(height: 20),

                // Interactive RSVP Button on Card
                SizedBox(
                  width: 160,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('RSVP Submitted! 🎉')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VoworaColors.champagneGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('RSVP NOW', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons: Share Card & Download
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invitation Share Link Copied! 📲')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VoworaColors.champagneGold,
                    foregroundColor: const Color(0xFF141210),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.share_rounded, size: 18, color: Color(0xFF141210)),
                  label: Text(
                    'Share Card',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: const Color(0xFF141210),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading Card PDF/Image... 📥')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: VoworaColors.champagneGold, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 18, color: VoworaColors.champagneGold),
                  label: Text(
                    'Download',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                provider.setStep(12); // Continue to Payment
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Payment',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle(String? pathOrUrl, IconData placeholderIcon) {
    final hasImg = pathOrUrl != null && pathOrUrl.isNotEmpty;

    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: VoworaColors.champagneGold, width: 2),
        color: Colors.white12,
      ),
      child: ClipOval(
        child: hasImg
            ? (pathOrUrl.startsWith('http')
                ? Image.network(pathOrUrl, fit: BoxFit.cover)
                : Image.file(File(pathOrUrl), fit: BoxFit.cover))
            : Icon(placeholderIcon, color: VoworaColors.champagneGold, size: 24),
      ),
    );
  }
}
