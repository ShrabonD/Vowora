import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_booking_model.dart';
import '../../providers/wedding_wizard_provider.dart';

class ChecklistStepView extends StatelessWidget {
  const ChecklistStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final tasks = provider.booking.tasksList;
    final progress = provider.booking.planningProgressPercentage;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 9: Planning Checklist 📋',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track all pre-wedding milestones & deadlines.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Overall Progress Bar Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wedding Planning Progress',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.playfairDisplay(
                        color: VoworaColors.champagneGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(VoworaColors.champagneGold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Task Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final task = tasks[index];
              final isDone = task.status == TaskStatus.completed;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDone
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDone
                        ? Colors.white12
                        : VoworaColors.champagneGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: isDone,
                      activeColor: VoworaColors.champagneGold,
                      checkColor: Colors.black,
                      onChanged: (val) {
                        provider.toggleTaskStatus(task.id);
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: GoogleFonts.plusJakartaSans(
                              color: isDone ? Colors.white54 : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          Text(
                            'Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate)} • Priority: ${task.priority.name.toUpperCase()}',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white38,
                              fontSize: 10.5,
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
                provider.setStep(10); // Continue to Budget
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Budget',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
