import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/vowora_theme.dart';
import '../../../data/mock_halls_data.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/conference_booking_service.dart';

class CHallDetailsPage extends StatefulWidget {
  const CHallDetailsPage({super.key, required this.hall});

  final ConferenceHall hall;

  @override
  State<CHallDetailsPage> createState() => _CHallDetailsPageState();
}

class _CHallDetailsPageState extends State<CHallDetailsPage> {
  bool _isBooking = false;

  ConferenceHall get hall => widget.hall;

  Future<void> _bookHall() async {
    setState(() => _isBooking = true);
    final user = Provider.of<AuthProvider>(context, listen: false).userProfile;

    try {
      final ok = await ConferenceBookingService.bookHall(
        userName: user?.fullName ?? '',
        userEmail: user?.email ?? '',
        hall: hall,
        eventDate: null,
        notes: null,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? 'Booking confirmed for ${hall.name}'
                : 'Booking failed. Try again.',
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Conference hall booking failed: $error\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $error')),
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        title: const Text('Hall Details'),
        backgroundColor: Colors.white,
        foregroundColor: VoworaColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _HallGallery(
            assets: hall.galleryAssets,
            thumbnailAsset: hall.thumbnailAsset,
          ),
          const SizedBox(height: 20),
          Text(
            hall.name,
            style: GoogleFonts.playfairDisplay(
              color: VoworaColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: VoworaColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hall.location,
                  style: GoogleFonts.plusJakartaSans(
                    color: VoworaColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            hall.slogan,
            style: GoogleFonts.plusJakartaSans(
              color: VoworaColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Contact Information',
            children: [
              _InfoRow(icon: Icons.person, text: hall.contactPerson),
              _InfoRow(icon: Icons.phone, text: hall.phone),
              _InfoRow(icon: Icons.chat, text: hall.whatsapp),
              _InfoRow(icon: Icons.email, text: hall.email),
              if (hall.facebook != null ||
                  hall.instagram != null ||
                  hall.website != null)
                Row(
                  children: [
                    if (hall.facebook != null)
                      IconButton(
                        tooltip: 'Facebook',
                        onPressed: () => debugPrint(hall.facebook),
                        icon: const Icon(Icons.facebook),
                        color: const Color(0xFF1877F2),
                      ),
                    if (hall.instagram != null)
                      IconButton(
                        tooltip: 'Instagram',
                        onPressed: () => debugPrint(hall.instagram),
                        icon: const Icon(Icons.camera_alt_outlined),
                        color: const Color(0xFFC13584),
                      ),
                    if (hall.website != null)
                      IconButton(
                        tooltip: 'Website',
                        onPressed: () => debugPrint(hall.website),
                        icon: const Icon(Icons.language),
                        color: VoworaColors.textSecondary,
                      ),
                  ],
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => debugPrint('Call for slots: ${hall.phone}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VoworaColors.champagneGold,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Call For Slots',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Capacity & Facilities',
            children: [
              _InfoRow(
                icon: Icons.groups,
                text: 'Capacity: ${hall.capacity} people',
              ),
              _BooleanInfoRow(
                icon: Icons.local_parking,
                label: 'Parking',
                value: hall.hasParking,
              ),
              _InfoRow(icon: Icons.ac_unit, text: 'AC: ${hall.acCount} units'),
              _InfoRow(
                icon: Icons.mode_fan_off,
                text: 'Fan: ${hall.fanCount} units',
              ),
              _BooleanInfoRow(
                icon: Icons.wifi,
                label: 'WiFi',
                value: hall.hasWifi,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Rules & Inclusions',
            children: [
              _RuleRow(label: 'Food included', value: hall.foodIncluded),
              _RuleRow(
                label: 'Outside food allowed',
                value: hall.outsideFoodAllowed,
              ),
              _RuleRow(
                label: 'Decoration included',
                value: hall.decorationIncluded,
              ),
              _RuleRow(
                label: 'Outside decoration allowed',
                value: hall.outsideDecorationAllowed,
              ),
              _RuleRow(
                label: 'Sound system included',
                value: hall.soundSystemIncluded,
              ),
              _RuleRow(
                label: 'Outside sound allowed',
                value: hall.outsideSoundAllowed,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Pricing',
            children: [
              Text(
                'Starting from ৳${hall.basePrice}',
                style: GoogleFonts.playfairDisplay(
                  color: VoworaColors.champagneGold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 24),
              for (final entry in hall.pricingDetails.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: GoogleFonts.plusJakartaSans(
                            color: VoworaColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '৳${entry.value}',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isBooking ? null : _bookHall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VoworaColors.champagneGold,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: VoworaColors.champagneGold
                        .withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isBooking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Book Now',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HallGallery extends StatefulWidget {
  const _HallGallery({
    required this.assets,
    required this.thumbnailAsset,
  });

  final List<String> assets;
  final String thumbnailAsset;

  @override
  State<_HallGallery> createState() => _HallGalleryState();
}

class _HallGalleryState extends State<_HallGallery> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final galleryAssets = widget.assets.isNotEmpty
        ? widget.assets
        : widget.thumbnailAsset.isNotEmpty
        ? [widget.thumbnailAsset]
        : const <String>[];

    if (galleryAssets.isEmpty) {
      return const SizedBox(height: 240, child: _GalleryPlaceholder());
    }
    return SizedBox(
      height: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: galleryAssets.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => Image.asset(
                galleryAssets[index],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _GalleryPlaceholder(),
              ),
            ),
            if (galleryAssets.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    galleryAssets.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: index == _currentPage ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? VoworaColors.champagneGold
                            : Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GalleryPlaceholder extends StatelessWidget {
  const _GalleryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Image Not Found',
            style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                color: VoworaColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 19, color: VoworaColors.champagneGold),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BooleanInfoRow extends StatelessWidget {
  const _BooleanInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 19, color: VoworaColors.champagneGold),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: ${value ? 'Yes' : 'No'}',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: value ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.label, required this.value});

  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: value ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
