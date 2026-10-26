import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/guest.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/guest_gate_dialog.dart';

class GuestsScreen extends StatefulWidget {
  const GuestsScreen({super.key});

  @override
  State<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen> {
  String _searchQuery = '';
  String _selectedSideFilter = 'All';
  String _selectedRsvpFilter = 'All';

  void _showAddGuestModal(BuildContext context, [Guest? existingGuest]) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isGuest) {
      GuestGateDialog.show(
        context,
        onCreateAccount: () => Navigator.pushNamed(context, '/signup'),
      );
      return;
    }

    final nameController = TextEditingController(text: existingGuest?.name);
    final phoneController = TextEditingController(text: existingGuest?.phone);
    final emailController = TextEditingController(text: existingGuest?.email);
    String selectedSide = existingGuest?.side ?? 'Bride';
    String selectedRsvp = existingGuest?.rsvp ?? 'Pending';
    String selectedMeal = existingGuest?.mealPreference ?? 'Regular';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1917),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    existingGuest == null ? 'Add Guest' : 'Edit Guest',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.person_outline, color: VoworaColors.champagneGold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Side selector
                  Text('SIDE', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: ['Bride', 'Groom', 'Both'].map((side) {
                      final isSelected = selectedSide == side;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() => selectedSide = side);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? VoworaColors.champagneGold
                                  : Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? VoworaColors.champagneGold
                                    : Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              side,
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected ? const Color(0xFF141210) : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  // RSVP selector
                  Text('RSVP STATUS', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: ['Pending', 'Attending', 'Not Attending'].map((rsvp) {
                      final isSelected = selectedRsvp == rsvp;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() => selectedRsvp = rsvp);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? VoworaColors.champagneGold
                                  : Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? VoworaColors.champagneGold
                                    : Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              rsvp,
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected ? const Color(0xFF141210) : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          final guest = Guest(
                            id: existingGuest?.id ?? 'g_${DateTime.now().millisecondsSinceEpoch}',
                            name: name,
                            phone: phoneController.text.trim(),
                            email: emailController.text.trim(),
                            side: selectedSide,
                            rsvp: selectedRsvp,
                            mealPreference: selectedMeal,
                          );
                          final wp = Provider.of<WeddingProvider>(context, listen: false);
                          if (existingGuest == null) {
                            wp.addGuest(guest);
                          } else {
                            wp.editGuest(guest);
                          }
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VoworaColors.champagneGold,
                        foregroundColor: const Color(0xFF141210),
                      ),
                      child: Text(
                        existingGuest == null ? 'Add Guest' : 'Save Changes',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weddingProvider = Provider.of<WeddingProvider>(context);
    final allGuests = weddingProvider.guests;

    final filteredGuests = allGuests.where((guest) {
      final matchesQuery = guest.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          guest.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSide = _selectedSideFilter == 'All' || guest.side == _selectedSideFilter;
      final matchesRsvp = _selectedRsvpFilter == 'All' || guest.rsvp == _selectedRsvpFilter;
      return matchesQuery && matchesSide && matchesRsvp;
    }).toList();

    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Guest Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: () => _showAddGuestModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Guest Metrics Header
            Row(
              children: [
                _buildStatTile('Total', '${weddingProvider.totalGuests}', VoworaColors.textPrimary),
                const SizedBox(width: 8),
                _buildStatTile('Attending', '${weddingProvider.attendingGuests}', VoworaColors.success),
                const SizedBox(width: 8),
                _buildStatTile('Pending', '${weddingProvider.pendingRsvpGuests}', VoworaColors.warning),
                const SizedBox(width: 8),
                _buildStatTile('Declined', '${weddingProvider.notAttendingGuests}', VoworaColors.error),
              ],
            ),
            const SizedBox(height: 16),
            // Search Bar
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search guest name or email...',
                prefixIcon: const Icon(Icons.search_rounded),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Sides', _selectedSideFilter == 'All', () => setState(() => _selectedSideFilter = 'All')),
                  _buildFilterChip('Bride Side', _selectedSideFilter == 'Bride', () => setState(() => _selectedSideFilter = 'Bride')),
                  _buildFilterChip('Groom Side', _selectedSideFilter == 'Groom', () => setState(() => _selectedSideFilter = 'Groom')),
                  _buildFilterChip('Attending', _selectedRsvpFilter == 'Attending', () => setState(() => _selectedRsvpFilter = 'Attending')),
                  _buildFilterChip('Pending RSVP', _selectedRsvpFilter == 'Pending', () => setState(() => _selectedRsvpFilter = 'Pending')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Guests List
            Expanded(
              child: filteredGuests.isEmpty
                  ? VoworaEmptyState(
                      title: 'No guests found ♡',
                      description: 'Your guest list is waiting for your additions.',
                      buttonText: 'Add First Guest',
                      onButtonPressed: () => _showAddGuestModal(context),
                    )
                  : ListView.separated(
                      itemCount: filteredGuests.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final guest = filteredGuests[index];
                        final rsvpColor = guest.rsvp == 'Attending'
                            ? VoworaColors.success
                            : (guest.rsvp == 'Pending' ? VoworaColors.warning : VoworaColors.error);

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: VoworaColors.dustyRose.withValues(alpha: 0.2),
                                child: Text(
                                  guest.name.isNotEmpty ? guest.name[0].toUpperCase() : 'G',
                                  style: GoogleFonts.playfairDisplay(
                                    color: VoworaColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      guest.name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Side: ${guest.side} • ${guest.phone}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: VoworaColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: rsvpColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  guest.rsvp,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: rsvpColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                                onPressed: () => _showAddGuestModal(context, guest),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: VoworaColors.champagneGold,
        foregroundColor: const Color(0xFF141210),
        onPressed: () => _showAddGuestModal(context),
        icon: const Icon(Icons.add),
        label: Text(
          'Add Guest',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.playfairDisplay(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? VoworaColors.champagneGold
                : const Color(0xFFEFECE6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? VoworaColors.champagneGold : const Color(0xFFD0C9BD),
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: isSelected ? const Color(0xFF141210) : VoworaColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
