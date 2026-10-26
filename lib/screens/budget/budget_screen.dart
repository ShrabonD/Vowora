import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/budget_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/guest_gate_dialog.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  void _showAddExpenseModal(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isGuest) {
      GuestGateDialog.show(
        context,
        onCreateAccount: () => Navigator.pushNamed(context, '/signup'),
      );
      return;
    }

    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final paidController = TextEditingController();
    String selectedCategory = VoworaConstants.budgetCategories.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1917),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Expense',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title / Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.description_outlined, color: VoworaColors.champagneGold),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Total Cost',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.attach_money_rounded, color: VoworaColors.champagneGold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: paidController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Paid So Far',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.check_circle_outline, color: VoworaColors.champagneGold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                dropdownColor: const Color(0xFF1C1917),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                items: VoworaConstants.budgetCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedCategory = val;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
                    final paid = double.tryParse(paidController.text.trim()) ?? 0.0;

                    if (title.isNotEmpty && amount > 0) {
                      final item = BudgetItem(
                        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                        category: selectedCategory,
                        title: title,
                        amount: amount,
                        paidAmount: paid,
                        date: DateTime.now(),
                      );
                      Provider.of<WeddingProvider>(context, listen: false).addBudgetItem(item);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VoworaColors.champagneGold,
                    foregroundColor: const Color(0xFF141210),
                  ),
                  child: Text(
                    'Save Expense',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weddingProvider = Provider.of<WeddingProvider>(context);
    final items = weddingProvider.budgetItems;

    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Wedding Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddExpenseModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Banner
            if (weddingProvider.isOverBudget) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: VoworaColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VoworaColors.error.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: VoworaColors.error, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Budget Warning: Your total expenses exceed your estimated budget!',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Summary Cards Row
            Row(
              children: [
                _buildSummaryCard(
                  'Total Budget',
                  '\$${weddingProvider.totalBudget.toStringAsFixed(0)}',
                  VoworaColors.champagneGold,
                ),
                const SizedBox(width: 10),
                _buildSummaryCard(
                  'Spent',
                  '\$${weddingProvider.totalSpent.toStringAsFixed(0)}',
                  VoworaColors.dustyRose,
                ),
                const SizedBox(width: 10),
                _buildSummaryCard(
                  'Remaining',
                  '\$${weddingProvider.remainingBudget.toStringAsFixed(0)}',
                  weddingProvider.remainingBudget >= 0 ? VoworaColors.success : VoworaColors.error,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Donut Chart
            if (items.isNotEmpty) ...[
              Text(
                'Expense Breakdown',
                style: GoogleFonts.playfairDisplay(
                  color: VoworaColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                    sections: _generatePieChartSections(items, weddingProvider.totalSpent),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Expenses List
            Text(
              'All Expenses (${items.length})',
              style: GoogleFonts.playfairDisplay(
                color: VoworaColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              VoworaEmptyState(
                title: 'No expenses added yet ♡',
                description: 'Start tracking your venue, catering, and decor costs by adding your first expense.',
                buttonText: 'Add Expense',
                onButtonPressed: () => _showAddExpenseModal(context),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: VoworaColors.champagneGold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_long_outlined,
                            color: VoworaColors.deepGold,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: VoworaColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${item.category} • Paid: \$${item.paidAmount.toStringAsFixed(0)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: VoworaColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${item.amount.toStringAsFixed(0)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: VoworaColors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                              onPressed: () {
                                weddingProvider.deleteBudgetItem(item.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: VoworaColors.champagneGold,
        foregroundColor: const Color(0xFF141210),
        onPressed: () => _showAddExpenseModal(context),
        icon: const Icon(Icons.add),
        label: Text(
          'Add Expense',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: VoworaColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections(List<BudgetItem> items, double totalSpent) {
    final colors = [
      VoworaColors.champagneGold,
      VoworaColors.dustyRose,
      VoworaColors.deepForestGreen,
      VoworaColors.mutedMauve,
      const Color(0xFF6C5CE7),
      const Color(0xFF00CEC9),
    ];
    int colorIndex = 0;

    return items.map((item) {
      final percentage = totalSpent > 0 ? (item.amount / totalSpent) * 100 : 0.0;
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        color: color,
        value: item.amount,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 35,
        titleStyle: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
