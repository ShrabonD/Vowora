import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_booking_model.dart';
import '../../providers/wedding_ecosystem_provider.dart';
import '../../routes/app_routes.dart';

class GuestWeddingPageScreen extends StatefulWidget {
  const GuestWeddingPageScreen({super.key});

  @override
  State<GuestWeddingPageScreen> createState() => _GuestWeddingPageScreenState();
}

class _GuestWeddingPageScreenState extends State<GuestWeddingPageScreen> {
  // RSVP Form States
  RSVPStatus _selectedRsvp = RSVPStatus.confirmed;
  int _attendees = 2;
  String _mealPref = 'Regular';
  final TextEditingController _nameCtrl = TextEditingController(text: 'Nusrat Jahan');
  final TextEditingController _phoneCtrl = TextEditingController(text: '+880 1700000003');
  final TextEditingController _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingEcosystemProvider>(context);
    final wedding = provider.joinedGuestWedding ?? provider.activeWedding;

    return Scaffold(
      backgroundColor: VoworaColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guest Event Portal 💍',
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Joined via ${wedding.weddingId}',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wedding_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Hero Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          VoworaColors.champagneGold.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: VoworaColors.champagneGold, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'YOU ARE CORDIALLY INVITED TO THE WEDDING OF',
                          style: GoogleFonts.plusJakartaSans(
                            color: VoworaColors.champagneGold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${wedding.brideName} ❤️ ${wedding.groomName}',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '📅 ${DateFormat('EEEE, MMMM dd, yyyy').format(wedding.weddingDate)} • ${wedding.weddingTime}',
                          style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '📍 ${wedding.selectedVenue?.name ?? 'Radisson Garden'}, ${wedding.selectedVenue?.location ?? 'Dhaka'}',
                          style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Action Tabs Grid for Guest
                  Text('Guest Options', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.1,
                    children: [
                      _buildGuestActionCard(
                        title: 'RSVP',
                        icon: Icons.how_to_reg_rounded,
                        color: VoworaColors.champagneGold,
                        onTap: () => _scrollToRsvpForm(),
                      ),
                      _buildGuestActionCard(
                        title: 'Schedule',
                        icon: Icons.access_time_filled_rounded,
                        color: const Color(0xFF6FCFB0),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.weddingSchedule),
                      ),
                      _buildGuestActionCard(
                        title: 'Gallery',
                        icon: Icons.photo_library_rounded,
                        color: VoworaColors.dustyRose,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.weddingGallery),
                      ),
                      _buildGuestActionCard(
                        title: 'Moments',
                        icon: Icons.add_a_photo_rounded,
                        color: const Color(0xFF9B8FE0),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.weddingGallery),
                      ),
                      _buildGuestActionCard(
                        title: 'Location',
                        icon: Icons.location_on_rounded,
                        color: const Color(0xFF5EC8C4),
                        onTap: () => _showLocationDialog(context, wedding),
                      ),
                      _buildGuestActionCard(
                        title: 'Invitation',
                        icon: Icons.mark_email_read_rounded,
                        color: VoworaColors.champagneGold,
                        onTap: () => _showInvitationModal(context, wedding),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // RSVP Form Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Submit Your RSVP',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please confirm your attendance to help the couple arrange catering & seating.',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // RSVP Status Selector Buttons
                        Text('ATTENDANCE STATUS', style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            _buildRsvpOptionPill('Yes, I\'ll Attend', RSVPStatus.confirmed),
                            const SizedBox(width: 6),
                            _buildRsvpOptionPill('Maybe', RSVPStatus.pending),
                            const SizedBox(width: 6),
                            _buildRsvpOptionPill('Declined', RSVPStatus.declined),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Guest Name & Phone
                        TextField(
                          controller: _nameCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(labelText: 'Your Name', labelStyle: TextStyle(color: Colors.white70)),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(labelText: 'Phone Number', labelStyle: TextStyle(color: Colors.white70)),
                        ),
                        const SizedBox(height: 16),

                        // Attendees Count
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('NUMBER OF ATTENDEES', style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 10, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                                  onPressed: () {
                                    if (_attendees > 1) setState(() => _attendees--);
                                  },
                                ),
                                Text('$_attendees', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: VoworaColors.champagneGold),
                                  onPressed: () => setState(() => _attendees++),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Upgraded Meal Preference Cards
                        Text('MEAL PREFERENCE 🍽️', style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        const SizedBox(height: 8),

                        Column(
                          children: [
                            _buildMealCard(
                              title: 'Royal Mutton Kacchi Feast',
                              subtitle: 'Mutton Kacchi Biryani, Chicken Roast & Shahi Borhani',
                              icon: Icons.restaurant_menu_rounded,
                              mealKey: 'Royal Mutton Kacchi Feast',
                            ),
                            const SizedBox(height: 8),
                            _buildMealCard(
                              title: 'Gourmet Vegetarian Menu',
                              subtitle: 'Paneer Butter Masala, Vegetable Polao & Dessert',
                              icon: Icons.eco_rounded,
                              mealKey: 'Gourmet Vegetarian Menu',
                            ),
                            const SizedBox(height: 8),
                            _buildMealCard(
                              title: 'Diabetic & Low Salt Special',
                              subtitle: 'Grilled Chicken, Brown Rice & Fresh Salad',
                              icon: Icons.health_and_safety_rounded,
                              mealKey: 'Diabetic & Low Salt Special',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              provider.submitGuestRSVP(
                                name: _nameCtrl.text.trim(),
                                phone: _phoneCtrl.text.trim(),
                                status: _selectedRsvp,
                                attendeesCount: _attendees,
                                mealPref: _mealPref,
                                specialRequest: _notesCtrl.text.trim(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('RSVP Submitted Successfully! Thank you 🎉'),
                                  backgroundColor: VoworaColors.success,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VoworaColors.champagneGold,
                              foregroundColor: const Color(0xFF141210),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: Text(
                              'Confirm RSVP',
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRsvpOptionPill(String label, RSVPStatus status) {
    final isSel = _selectedRsvp == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRsvp = status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? VoworaColors.champagneGold : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSel ? VoworaColors.champagneGold : Colors.white24,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: isSel ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10.5,
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToRsvpForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in the RSVP form below ⬇️')),
    );
  }

  void _showLocationDialog(BuildContext context, WeddingBookingModel wedding) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181513),
        title: Text('Venue Location Map 📍', style: GoogleFonts.playfairDisplay(color: Colors.white)),
        content: Text(
          '${wedding.selectedVenue?.name}\n${wedding.selectedVenue?.location}\n\nMap navigation directions available.',
          style: GoogleFonts.plusJakartaSans(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: VoworaColors.champagneGold)),
          ),
        ],
      ),
    );
  }

  void _showInvitationModal(BuildContext context, WeddingBookingModel wedding) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181513),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Digital Invitation Card 💌', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('${wedding.brideName} & ${wedding.groomName}', style: GoogleFonts.playfairDisplay(color: VoworaColors.champagneGold, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('${DateFormat('EEEE, MMMM dd, yyyy').format(wedding.weddingDate)} • ${wedding.weddingTime}', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: VoworaColors.champagneGold, foregroundColor: Colors.black),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String mealKey,
  }) {
    final isSel = _mealPref == mealKey;
    return GestureDetector(
      onTap: () => setState(() => _mealPref = mealKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSel
              ? VoworaColors.champagneGold.withValues(alpha: 0.18)
              : Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSel ? VoworaColors.champagneGold : Colors.white24,
            width: isSel ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSel ? VoworaColors.champagneGold : Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSel ? const Color(0xFF141210) : Colors.white70,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: isSel ? VoworaColors.champagneGold : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white60,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            if (isSel)
              const Icon(Icons.check_circle_rounded, color: VoworaColors.champagneGold, size: 20),
          ],
        ),
      ),
    );
  }
}
