import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';

class PackageSelectionStepView extends StatelessWidget {
  const PackageSelectionStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final packages = provider.packages;
    final selectedPackage = provider.booking.selectedPackage;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3: Wedding Package 🎁',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select or customize an end-to-end wedding package.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),

          // Package Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: packages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final pkg = packages[index];
              final isSel = selectedPackage?.id == pkg.id;

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSel ? VoworaColors.champagneGold : Colors.white.withValues(alpha: 0.18),
                    width: isSel ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pkg.name,
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                pkg.targetAudience,
                                style: GoogleFonts.plusJakartaSans(
                                  color: VoworaColors.champagneGold,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: VoworaColors.champagneGold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            pkg.tier.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: VoworaColors.champagneGold,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.white.withValues(alpha: 0.12)),
                    const SizedBox(height: 8),

                    // Inclusions List
                    _buildInclusionRow(Icons.auto_awesome, 'Decoration', pkg.decorationSummary),
                    _buildInclusionRow(Icons.restaurant, 'Catering', pkg.cateringSummary),
                    _buildInclusionRow(Icons.camera_alt_outlined, 'Photography', pkg.photographySummary),
                    _buildInclusionRow(Icons.videocam_outlined, 'Videography', pkg.videographySummary),
                    _buildInclusionRow(Icons.chair_alt_rounded, 'Stage Design', pkg.stageSummary),
                    _buildInclusionRow(Icons.lightbulb_outline, 'Lighting', pkg.lightingSummary),
                    _buildInclusionRow(Icons.speaker_group_outlined, 'Sound System', pkg.soundSummary),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Package Price',
                                style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 10)),
                            Text(
                              '৳${(pkg.price / 1000).toStringAsFixed(0)}k',
                              style: GoogleFonts.playfairDisplay(
                                color: VoworaColors.champagneGold,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                provider.selectPackage(pkg);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSel ? VoworaColors.champagneGold : Colors.white12,
                                foregroundColor: isSel ? Colors.black : Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Text(
                                isSel ? '✓ Selected' : 'Select Package',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Continue Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: selectedPackage == null
                  ? null
                  : () {
                      provider.setStep(4); // Continue to Decoration
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Decoration',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInclusionRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: VoworaColors.champagneGold),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.plusJakartaSans(
                color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
