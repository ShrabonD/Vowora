import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';

class DecorationStepView extends StatefulWidget {
  const DecorationStepView({super.key});

  @override
  State<DecorationStepView> createState() => _DecorationStepViewState();
}

class _DecorationStepViewState extends State<DecorationStepView> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Wedding Arch',
    'Stage Decoration',
    'Entrance Decoration',
    'Lighting',
    'Centerpieces',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final decorations = provider.decorations;
    final selectedDecorations = provider.booking.selectedDecorations;

    final filteredDecorations = _selectedCategory == 'All'
        ? decorations
        : decorations.where((d) => d.category == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 4: Decoration Themes 🌸',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select stage, archway & lighting themes for your wedding.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Categories Filter
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSel = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
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
                        cat,
                        style: GoogleFonts.plusJakartaSans(
                          color: isSel ? const Color(0xFF141210) : Colors.white,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Decoration Cards Grid
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredDecorations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final decor = filteredDecorations[index];
              final isAdded = selectedDecorations.any((d) => d.id == decor.id);

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAdded ? VoworaColors.champagneGold : Colors.white.withValues(alpha: 0.18),
                    width: isAdded ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        decor.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null) return child;
                          return Image.asset(
                            'assets/images/wedding_background.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        },
                        errorBuilder: (c, e, s) => Image.asset(
                          'assets/images/wedding_background.png',
                          width: 80,
                          height: 80,
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
                            decor.name,
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Theme: ${decor.themeName}',
                            style: GoogleFonts.plusJakartaSans(
                              color: VoworaColors.champagneGold,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            decor.description,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white70,
                              fontSize: 10.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '৳${(decor.price / 1000).toStringAsFixed(0)}k',
                                style: GoogleFonts.playfairDisplay(
                                  color: VoworaColors.champagneGold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  provider.toggleDecoration(decor);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isAdded ? VoworaColors.champagneGold : Colors.white12,
                                  foregroundColor: isAdded ? Colors.black : Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(
                                  isAdded ? '✓ Added' : '+ Add',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
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

          // Selection Summary & Continue Button
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: VoworaColors.champagneGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Themes: ${selectedDecorations.length}',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(
                      'Total Decor Cost: ৳${provider.booking.decorationCost.toStringAsFixed(0)}',
                      style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                provider.setStep(5); // Continue to Catering
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Catering',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
