import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';

class BudgetStepView extends StatefulWidget {
  const BudgetStepView({super.key});

  @override
  State<BudgetStepView> createState() => _BudgetStepViewState();
}

class _BudgetStepViewState extends State<BudgetStepView> {
  late TextEditingController _budgetCtrl;

  @override
  void initState() {
    super.initState();
    final booking =
        Provider.of<WeddingWizardProvider>(context, listen: false).booking;
    _budgetCtrl = TextEditingController(
        text: booking.totalPlannedBudget.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _budgetCtrl.dispose();
    super.dispose();
  }

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
            'Step 10: Budget Management 💰',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Monitor overall budget vs real-time estimated costs.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Over Budget Warning Banner
          if (booking.isOverBudget) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: VoworaColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VoworaColors.error),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: VoworaColors.error, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your wedding expenses are exceeding your planned budget.',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Total Planned Budget Field
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
                Text(
                  'SET TOTAL PLANNED BUDGET (৳)',
                  style: GoogleFonts.plusJakartaSans(
                    color: VoworaColors.champagneGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _budgetCtrl,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: '400000',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final val = double.tryParse(_budgetCtrl.text.trim());
                        if (val != null) {
                          provider.setTotalPlannedBudget(val);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Budget updated!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VoworaColors.champagneGold,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Budget Financial Metrics Summary
          Row(
            children: [
              _buildBudgetTile('Planned', '৳${(booking.totalPlannedBudget / 1000).toStringAsFixed(0)}k', Colors.white),
              const SizedBox(width: 8),
              _buildBudgetTile('Estimated', '৳${(booking.totalEstimatedCost / 1000).toStringAsFixed(0)}k', VoworaColors.champagneGold),
              const SizedBox(width: 8),
              _buildBudgetTile('Paid', '৳${(booking.totalPaidAmount / 1000).toStringAsFixed(0)}k', const Color(0xFF6FCFB0)),
            ],
          ),
          const SizedBox(height: 20),

          // Category Expense Breakdown Cards
          Text('Expense Breakdown', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          _buildExpenseRow('Venue', booking.venueCost),
          _buildExpenseRow('Package', booking.packageCost),
          _buildExpenseRow('Decoration', booking.decorationCost),
          _buildExpenseRow('Catering', booking.cateringCost),
          _buildExpenseRow('Photography', booking.mediaCost),
          _buildExpenseRow('Entertainment', booking.entertainmentCost),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                provider.setStep(11); // Continue to Invitation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Invitation',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetTile(String label, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(val, style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: GoogleFonts.plusJakartaSans(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseRow(String category, double amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(category, style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12)),
          Text('৳${amount.toStringAsFixed(0)}', style: GoogleFonts.playfairDisplay(color: VoworaColors.champagneGold, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
