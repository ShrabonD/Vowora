import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_booking_model.dart';
import '../../providers/wedding_wizard_provider.dart';

class VenueSelectionStepView extends StatefulWidget {
  const VenueSelectionStepView({super.key});

  @override
  State<VenueSelectionStepView> createState() => _VenueSelectionStepViewState();
}

class _VenueSelectionStepViewState extends State<VenueSelectionStepView> {
  String _typeFilter = 'All'; // All, Indoor, Outdoor, Both
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final allVenues = provider.venues;
    final selectedVenue = provider.booking.selectedVenue;

    final filteredVenues = allVenues.where((v) {
      if (_typeFilter == 'Indoor' && v.venueType != VenueType.indoor) return false;
      if (_typeFilter == 'Outdoor' && v.venueType != VenueType.outdoor && v.venueType != VenueType.both) return false;
      if (_searchQuery.isNotEmpty &&
          !v.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !v.location.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2: Venue Selection 🏰',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose a luxury venue for your celebration.',
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.champagneGold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Search & Filter Bar
          TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search by venue name or location...',
              prefixIcon: const Icon(Icons.search_rounded, color: VoworaColors.champagneGold),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Pills
          Row(
            children: ['All', 'Indoor', 'Outdoor'].map((type) {
              final isSel = _typeFilter == type;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _typeFilter = type),
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
                      type,
                      style: GoogleFonts.plusJakartaSans(
                        color: isSel ? const Color(0xFF141210) : Colors.white,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Venues Cards List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredVenues.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final venue = filteredVenues[index];
              final isSelected = selectedVenue?.id == venue.id;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? VoworaColors.champagneGold : Colors.white.withValues(alpha: 0.18),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Banner
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      child: Stack(
                        children: [
                          Image.network(
                            venue.imageUrl,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded || frame != null) return child;
                              return Image.asset(
                                'assets/images/wedding_background.png',
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                            errorBuilder: (c, e, s) => Image.asset(
                              'assets/images/wedding_background.png',
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${venue.rating}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                venue.name,
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '৳${(venue.price / 1000).toStringAsFixed(0)}k',
                                style: GoogleFonts.playfairDisplay(
                                  color: VoworaColors.champagneGold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${venue.location} • Up to ${venue.capacity} Guests',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Facilities Badges
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: venue.facilities.map((f) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  f,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white60,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),

                          // Action Buttons
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () => _showVenueDetailsModal(context, venue),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text('View Details'),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    provider.selectVenue(venue);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? VoworaColors.champagneGold
                                        : Colors.white.withValues(alpha: 0.15),
                                    foregroundColor: isSelected ? Colors.black : Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: Text(
                                    isSelected ? '✓ Venue Selected' : 'Select Venue',
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
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

          // Continue to Package Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: selectedVenue == null
                  ? null
                  : () {
                      provider.setStep(3); // Continue to Package
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: VoworaColors.champagneGold,
                foregroundColor: const Color(0xFF141210),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Continue to Package',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVenueDetailsModal(BuildContext context, VenueModel venue) {
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
                venue.name,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '📍 ${venue.location}',
                style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Text(
                venue.description,
                style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Text(
                'Facilities included: ${venue.facilities.join(', ')}',
                style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
