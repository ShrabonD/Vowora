import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';

class EntertainmentStepView extends StatelessWidget {
  const EntertainmentStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final options = provider.entertainmentOptions;
    final selectedEnt = provider.booking.selectedEntertainment;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 8: Entertainment & Music 🎶',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Live bands, DJ consoles, acoustic singers & pyro show.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final opt = options[index];
              final isSel = selectedEnt.any((e) => e.id == opt.id);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSel ? VoworaColors.champagneGold : Colors.white.withValues(alpha: 0.18),
                    width: isSel ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        opt.imageUrl,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null) return child;
                          return Image.asset(
                            'assets/images/wedding_background.png',
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          );
                        },
                        errorBuilder: (c, e, s) => Image.asset(
                          'assets/images/wedding_background.png',
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt.name,
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '⏱️ ${opt.duration} • ৳${(opt.price / 1000).toStringAsFixed(0)}k',
                            style: GoogleFonts.plusJakartaSans(
                              color: VoworaColors.champagneGold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opt.description,
                            style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 10.5),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              provider.toggleEntertainmentOption(opt);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSel ? VoworaColors.champagneGold : Colors.white12,
                              foregroundColor: isSel ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              isSel ? '✓ Added' : '+ Add',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
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
                provider.setStep(9); // Continue to Checklist
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Checklist',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
