import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';

class PhotographyStepView extends StatelessWidget {
  const PhotographyStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final mediaServices = provider.photographyServices;
    final selectedMedia = provider.booking.selectedMediaServices;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 7: Photography & Cinema 📷',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Book lead photographers, cinematic reels & 4K drone shoots.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),

          // Services Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mediaServices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final service = mediaServices[index];
              final isBooked = selectedMedia.any((s) => s.id == service.id);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isBooked ? VoworaColors.champagneGold : Colors.white.withValues(alpha: 0.18),
                    width: isBooked ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            service.title,
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '৳${(service.price / 1000).toStringAsFixed(0)}k',
                          style: GoogleFonts.playfairDisplay(
                            color: VoworaColors.champagneGold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '⏱️ Duration: ${service.duration}',
                      style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.description,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.photo_library_outlined, color: Colors.white54, size: 16),
                            const SizedBox(width: 4),
                            Text('Portfolio Samples', style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 11)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            provider.toggleMediaService(service);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBooked ? VoworaColors.champagneGold : Colors.white12,
                            foregroundColor: isBooked ? Colors.black : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            isBooked ? '✓ Service Booked' : 'Book Service',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                provider.setStep(8); // Continue to Entertainment
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Entertainment',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
