import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_booking_model.dart';
import '../../providers/wedding_wizard_provider.dart';
import '../../routes/app_routes.dart';

class WeddingEntryStepView extends StatelessWidget {
  const WeddingEntryStepView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final booking = provider.booking;
    final hasActiveWedding = booking.isConfirmed && booking.brideName.trim().isNotEmpty;
    final days = booking.daysUntilWedding;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Welcome Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wedding Hub 💍',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Plan your dream celebration effortlessly.',
                    style: GoogleFonts.plusJakartaSans(
                      color: VoworaColors.champagneGold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_active_outlined,
                    color: VoworaColors.champagneGold),
                onPressed: () => _showNotificationsSheet(context, provider),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (!hasActiveWedding) ...[
            // ===== CLEAN 0-EVENT STATE FOR NEW USER =====
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: VoworaColors.champagneGold.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NO ACTIVE EVENT YET',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.champagneGold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const Icon(Icons.celebration_outlined, color: VoworaColors.champagneGold, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Start Planning Your Dream Wedding 💍',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Follow our 9-step smart wizard to select venue, decor, catering menu, photographers & digital invitation card.',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        provider.startNewBookingWizard();
                        provider.setStep(1); // Go to Step 1 of Creation Wizard
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VoworaColors.champagneGold,
                        foregroundColor: const Color(0xFF141210),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.add_circle_rounded, size: 22),
                      label: Text(
                        '+ Create Your Wedding',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Join Event Callout
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: VoworaColors.champagneGold.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.qr_code_scanner_rounded, color: VoworaColors.champagneGold, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Have an Invitation Code? 💌',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Enter Secret Code (e.g. WED-8F42K9) to join an event as guest.',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.joinWedding),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: VoworaColors.champagneGold,
                      side: const BorderSide(color: VoworaColors.champagneGold),
                    ),
                    child: const Text('Join'),
                  ),
                ],
              ),
            ),
          ] else ...[
            // ===== ACTIVE CONFIRMED WEDDING VIEW =====
            // Prominent "+ Create Your Wedding" Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.startNewBookingWizard();
                  provider.setStep(1); // Go to Step 1 of Creation Wizard
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: VoworaColors.champagneGold,
                  foregroundColor: const Color(0xFF141210),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                icon: const Icon(Icons.add_circle, size: 22),
                label: Text(
                  '+ Create New Wedding',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Live Wedding Countdown
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: VoworaColors.champagneGold.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'WEDDING COUNTDOWN',
                            style: GoogleFonts.plusJakartaSans(
                              color: VoworaColors.champagneGold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: VoworaColors.champagneGold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              booking.weddingId,
                              style: GoogleFonts.plusJakartaSans(
                                color: VoworaColors.champagneGold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '$days',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Days Until The Vows',
                                style: GoogleFonts.playfairDisplay(
                                  color: VoworaColors.champagneGold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${booking.brideName} & ${booking.groomName}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Overview Dashboard Cards
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.weddingDashboard),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Wedding Overview',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Open Dashboard →',
                    style: GoogleFonts.plusJakartaSans(
                      color: VoworaColors.champagneGold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildOverviewCard(
                  context,
                  title: 'Planning Progress',
                  value: '${(booking.planningProgressPercentage * 100).toInt()}%',
                  subtitle: 'Steps Completed',
                  icon: Icons.donut_large_rounded,
                  color: VoworaColors.champagneGold,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.weddingDashboard),
                ),
                _buildOverviewCard(
                  context,
                  title: 'Budget Spent',
                  value: '৳${(booking.totalEstimatedCost / 1000).toStringAsFixed(0)}k',
                  subtitle: 'Of ৳${(booking.totalPlannedBudget / 1000).toStringAsFixed(0)}k Budget',
                  icon: Icons.account_balance_wallet_outlined,
                  color: booking.isOverBudget ? VoworaColors.error : const Color(0xFF6FCFB0),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.weddingDashboard),
                ),
                _buildOverviewCard(
                  context,
                  title: 'Guests RSVP',
                  value: '${booking.guestsList.length}',
                  subtitle: 'Total Guests Invited',
                  icon: Icons.people_alt_outlined,
                  color: VoworaColors.dustyRose,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.weddingDashboard),
                ),
                _buildOverviewCard(
                  context,
                  title: 'Upcoming Tasks',
                  value: '${booking.tasksList.where((t) => t.status != TaskStatus.completed).length}',
                  subtitle: 'Pending Items',
                  icon: Icons.checklist_rtl_rounded,
                  color: const Color(0xFF9B8FE0),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.weddingDashboard),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Shortcut to Standalone Wedding Dashboard
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.weddingDashboard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: VoworaColors.champagneGold,
                  foregroundColor: const Color(0xFF141210),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.dashboard_rounded),
                label: Text(
                  'Open My Wedding Dashboard',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 22),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white38, size: 12),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white54,
                    fontSize: 9.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context, WeddingWizardProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181513),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wedding Alerts & Reminders',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                itemCount: provider.notifications.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.white.withValues(alpha: 0.1)),
                itemBuilder: (context, index) {
                  final notif = provider.notifications[index];
                  return ListTile(
                    leading: Icon(notif.icon, color: VoworaColors.champagneGold),
                    title: Text(
                      notif.title,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      notif.message,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
