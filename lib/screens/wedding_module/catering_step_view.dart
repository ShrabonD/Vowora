import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_booking_model.dart';
import '../../providers/wedding_wizard_provider.dart';

class CateringStepView extends StatefulWidget {
  const CateringStepView({super.key});

  @override
  State<CateringStepView> createState() => _CateringStepViewState();
}

class _CateringStepViewState extends State<CateringStepView> {
  late CateringItemModel _selectedPackage;
  late int _guestCount;
  late TextEditingController _specialReqCtrl;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<WeddingWizardProvider>(context, listen: false);
    final booking = provider.booking;

    _selectedPackage = booking.selectedCateringPackage ?? provider.cateringPackages.first;
    _guestCount = booking.expectedGuestCount;
    _specialReqCtrl = TextEditingController(text: booking.specialFoodRequirements);
  }

  @override
  void dispose() {
    _specialReqCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final packages = provider.cateringPackages;
    final totalCost = _selectedPackage.perPersonPrice * _guestCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 5: Catering & Feast 🍽️',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select menu packages & guest count for instant cost calculation.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),

          // Guest Count Slider
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NUMBER OF GUESTS',
                      style: GoogleFonts.plusJakartaSans(
                        color: VoworaColors.champagneGold,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_guestCount Guests',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _guestCount.toDouble(),
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  activeColor: VoworaColors.champagneGold,
                  inactiveColor: Colors.white24,
                  onChanged: (val) {
                    setState(() {
                      _guestCount = val.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Package Selection
          Text(
            'SELECT CATERING PACKAGE',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: packages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final pkg = packages[index];
              final isSel = _selectedPackage.id == pkg.id;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedPackage = pkg);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
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
                            child: Text(
                              pkg.packageName,
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '৳${pkg.perPersonPrice.toStringAsFixed(0)} / Plate',
                            style: GoogleFonts.playfairDisplay(
                              color: VoworaColors.champagneGold,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.white.withValues(alpha: 0.12)),
                      const SizedBox(height: 6),

                      // Menu Items Summary
                      _buildMenuItemList('Appetizers', pkg.appetizers),
                      _buildMenuItemList('Main Course', pkg.mainCourse),
                      _buildMenuItemList('Desserts & Drinks', [...pkg.desserts, ...pkg.drinks]),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Special Food Requirements Input
          Text(
            'SPECIAL FOOD REQUIREMENTS',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _specialReqCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. Halal food, diabetic dessert options, allergies...',
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Dynamic Price Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VoworaColors.champagneGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '৳${_selectedPackage.perPersonPrice.toStringAsFixed(0)} × $_guestCount Guests',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 11),
                    ),
                    Text(
                      'Total Catering Cost',
                      style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '৳${totalCost.toStringAsFixed(0)}',
                  style: GoogleFonts.playfairDisplay(
                    color: VoworaColors.champagneGold,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                provider.selectCateringPackage(_selectedPackage, _guestCount, _specialReqCtrl.text.trim());
                provider.setStep(6); // Continue to Guest Management
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Guests',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemList(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              items.join(', '),
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
