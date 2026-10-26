import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/vendor_package.dart';

class BirthdayVendorDiscoveryScreen extends StatefulWidget {
  const BirthdayVendorDiscoveryScreen({super.key});

  @override
  State<BirthdayVendorDiscoveryScreen> createState() =>
      _BirthdayVendorDiscoveryScreenState();
}

class _BirthdayVendorDiscoveryScreenState
    extends State<BirthdayVendorDiscoveryScreen> {
  String _selectedCategory = 'All';
  String _currentLocation = 'Dhanmondi, Dhaka';

  // Birthday Theme Accent Color: Dusty Rose & Warm Blush Gold
  static const Color birthdayAccent = VoworaColors.dustyRose;

  // Sample Nearby Birthday Vendors Data with Festive Packages
  final List<NearbyVendor> _birthdayVendors = [
    NearbyVendor(
      id: 'bv1',
      name: 'Sweet Bliss Custom Cakes',
      category: 'Birthday Cake',
      rating: 4.9,
      reviewsCount: 156,
      distanceKm: 0.8,
      address: 'Satmasjid Road, Dhanmondi',
      imageUrl: 'https://images.unsplash.com/photo-1535141192574-5d4897c13136',
      startingPrice: 3500,
      packages: [
        VendorPackage(
          id: 'bp1_basic',
          name: 'Classic Cream Delight',
          tier: PackageTier.basic,
          basePrice: 3500,
          description: '2 kg custom flavoured cream cake with age topper.',
          items: [
            PackageItem(
              id: 'bi1',
              name: '2 kg Custom Whipped Cream Cake',
              description: 'Vanilla/Chocolate base with custom name piping',
              defaultPrice: 2800,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bi2',
              name: 'Numbered Birthday Candle & Sparkler',
              description: 'Gold number candle + 2 cold sparklers',
              defaultPrice: 700,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bi3',
              name: '12 Matching Cupcakes',
              description: 'Themed frosted cupcakes for guests',
              defaultPrice: 1500,
              isDefaultIncluded: false,
              isSelected: false,
            ),
          ],
        ),
        VendorPackage(
          id: 'bp1_moderate',
          name: '3D Fondant Theme Cake',
          tier: PackageTier.moderate,
          basePrice: 7500,
          description: '3 kg sculpted 3D fondant theme cake with dessert cup box.',
          items: [
            PackageItem(
              id: 'bi1',
              name: '3 kg 3D Sculpted Fondant Cake',
              description: 'Custom character / luxury design (2 Tiers)',
              defaultPrice: 5500,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bi2',
              name: '12 Theme Cupcakes & 6 Cake Pops',
              description: 'Color-matched fondant decorations',
              defaultPrice: 2000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bi3',
              name: 'Donut Tower & Dessert Jars',
              description: '10 glazed donuts + 6 mousse jars',
              defaultPrice: 2200,
              isDefaultIncluded: false,
              isSelected: false,
            ),
          ],
        ),
        VendorPackage(
          id: 'bp1_premium',
          name: 'Royal Dessert Kingdom',
          tier: PackageTier.premium,
          basePrice: 14000,
          description: '5 kg 3-tier grand centerpiece cake with complete dessert bar.',
          items: [
            PackageItem(
              id: 'bi1',
              name: '5 kg Grand 3-Tier Luxury Cake',
              description: 'Edible gold leafing & handcrafted sugar toppers',
              defaultPrice: 9000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bi2',
              name: 'Full Dessert Table Spread',
              description: '24 Cupcakes, 12 Cake pops, 12 Macarons',
              defaultPrice: 5000,
              isDefaultIncluded: true,
            ),
          ],
        ),
      ],
    ),
    NearbyVendor(
      id: 'bv2',
      name: 'Balloon Kingdom & Theme Decor',
      category: 'Theme Decor',
      rating: 4.8,
      reviewsCount: 112,
      distanceKm: 1.5,
      address: 'Road 11, Banani / Dhanmondi branch',
      imageUrl: 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce',
      startingPrice: 12000,
      packages: [
        VendorPackage(
          id: 'bp2_basic',
          name: 'Pastel Joy Arch',
          tier: PackageTier.basic,
          basePrice: 12000,
          description: 'Organic balloon arch, neon sign & cake table decor.',
          items: [
            PackageItem(
              id: 'bd1',
              name: '6x6 ft Pastel Balloon Arch & Backdrop',
              description: 'Dual color balloon garland',
              defaultPrice: 7000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bd2',
              name: 'Neon "Happy Birthday" Sign & Cake Plinth',
              description: 'Warm LED neon light backdrop',
              defaultPrice: 3500,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bd3',
              name: 'Number LED Light Stand',
              description: '3ft glowing marquee number',
              defaultPrice: 1500,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bd4',
              name: 'Helium Balloon Ceiling Spread (30 Pcs)',
              description: 'Floating helium balloons with metallic ribbons',
              defaultPrice: 3000,
              isDefaultIncluded: false,
              isSelected: false,
            ),
          ],
        ),
        VendorPackage(
          id: 'bp2_moderate',
          name: 'Magic Wonderland Setup',
          tier: PackageTier.moderate,
          basePrice: 22000,
          description: 'Interactive character theme backdrop with welcome arch.',
          items: [
            PackageItem(
              id: 'bd1',
              name: '10x8 ft 3D Theme Backdrop & Cutouts',
              description: 'Custom character foam cutouts & floral balloon arch',
              defaultPrice: 14000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bd2',
              name: 'Entrance Archway & Red Carpet Walkway',
              description: 'Balloon tunnel with welcome easel stand',
              defaultPrice: 5000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bd3',
              name: '3 Cylinder Cake Plinths & Backdrop Lighting',
              description: 'Focus spotlights & cake display stands',
              defaultPrice: 3000,
              isDefaultIncluded: true,
            ),
          ],
        ),
        VendorPackage(
          id: 'bp2_premium',
          name: 'Grand Carnival Experience',
          tier: PackageTier.premium,
          basePrice: 45000,
          description: 'Complete venue transformation with custom photobooth.',
          items: [
            PackageItem(
              id: 'bd1',
              name: '15ft Grand Stage Backdrop & LED Wall Accent',
              description: 'Full hall thematic balloon canopy & LED lights',
              defaultPrice: 28000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bd2',
              name: 'Interactive Photobooth Corner',
              description: 'Prop station & instant photo printer setup',
              defaultPrice: 10000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'bd3',
              name: 'Table Centerpieces (10 Tables)',
              description: 'Mini helium balloon clusters',
              defaultPrice: 7000,
              isDefaultIncluded: true,
            ),
          ],
        ),
      ],
    ),
    NearbyVendor(
      id: 'bv3',
      name: 'FunZone Magic & Entertainment',
      category: 'Entertainment',
      rating: 4.9,
      reviewsCount: 88,
      distanceKm: 2.3,
      address: 'Mirpur Road, Dhaka',
      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819',
      startingPrice: 8000,
      packages: [
        VendorPackage(
          id: 'bp3_basic',
          name: 'Magician & Game Host',
          tier: PackageTier.basic,
          basePrice: 8000,
          description: '45 mins illusion magic show + 30 mins game hosting.',
          items: [
            PackageItem(
              id: 'e1',
              name: 'Interactive Illusion Magic Show (45 Mins)',
              description: 'Live bunny/pigeon magic tricks for kids',
              defaultPrice: 5000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'e2',
              name: 'Party Game Host & Music Playlist',
              description: 'Musical chairs, pass the parcel & prizes',
              defaultPrice: 3000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'e3',
              name: 'Face Painting Artist (1 Hour)',
              description: 'Hypoallergenic glitter face paint for guests',
              defaultPrice: 3500,
              isDefaultIncluded: false,
              isSelected: false,
            ),
          ],
        ),
        VendorPackage(
          id: 'bp3_moderate',
          name: 'Carnival & Mascot Fiesta',
          tier: PackageTier.moderate,
          basePrice: 16000,
          description: 'Magic show + Cartoon mascot + Live popcorn machine.',
          items: [
            PackageItem(
              id: 'e1',
              name: 'Grand Magic Show & Game Anchor',
              description: 'Interactive comedy magic & game show',
              defaultPrice: 7000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'e2',
              name: '2 Life-size Mascot Characters',
              description: 'Mickey/Minnie or Superhero 2 hours greeting',
              defaultPrice: 5000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'e3',
              name: 'Live Popcorn & Cotton Candy Stall',
              description: 'Unlimited live fresh popcorn & cotton candy',
              defaultPrice: 4000,
              isDefaultIncluded: true,
            ),
          ],
        ),
        VendorPackage(
          id: 'bp3_premium',
          name: 'Ultimate Kids Extravaganza',
          tier: PackageTier.premium,
          basePrice: 30000,
          description: 'Full 3-hour entertainment show with puppet & game stalls.',
          items: [
            PackageItem(
              id: 'e1',
              name: 'Master Magician & Ventriloquist Puppet Show',
              description: 'Talking puppet show + illusion magic',
              defaultPrice: 12000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'e2',
              name: '3 Mascots + Face Painter + Tattoo Corner',
              description: 'Full team of kids entertainers',
              defaultPrice: 10000,
              isDefaultIncluded: true,
            ),
            PackageItem(
              id: 'e3',
              name: 'Bouncy Castle Inflatable Ride (3 Hours)',
              description: 'Safe inflatable jumping castle with supervisor',
              defaultPrice: 8000,
              isDefaultIncluded: true,
            ),
          ],
        ),
      ],
    ),
  ];

  final List<String> _categories = [
    'All',
    'Birthday Cake',
    'Theme Decor',
    'Entertainment',
    'Venue & Playzone',
    'Photography & Reel',
    'Catering & Snacks',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredVendors = _selectedCategory == 'All'
        ? _birthdayVendors
        : _birthdayVendors.where((v) => v.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: VoworaColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cake_rounded, color: birthdayAccent, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Birthday Celebration',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.near_me_rounded,
                  size: 11,
                  color: birthdayAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  'Nearby: $_currentLocation',
                  style: GoogleFonts.plusJakartaSans(
                    color: birthdayAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: birthdayAccent),
            onPressed: () => _showLocationChangeSheet(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    birthdayAccent.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.98),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. Festive Birthday Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: birthdayAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: birthdayAccent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: birthdayAccent.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.celebration_rounded,
                            color: birthdayAccent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Celebrate Another Beautiful Year! 🎈',
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Custom cakes, balloon decor, magicians & playzones nearby.',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Birthday Category Filter Pills
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedCategory = cat);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? birthdayAccent
                                  : Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? birthdayAccent
                                    : Colors.white.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected ? const Color(0xFF141210) : Colors.white,
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Nearby Birthday Vendors List
                Expanded(
                  child: filteredVendors.isEmpty
                      ? Center(
                          child: Text(
                            'No nearby birthday vendors in this category.',
                            style: GoogleFonts.plusJakartaSans(color: Colors.white70),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          itemCount: filteredVendors.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final vendor = filteredVendors[index];
                            return _buildBirthdayVendorCard(context, vendor);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Birthday Vendor Card Widget ───────────────────────────────────────────
  Widget _buildBirthdayVendorCard(BuildContext context, NearbyVendor vendor) {
    return GestureDetector(
      onTap: () => _showBirthdayVendorPackagesSheet(context, vendor),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: birthdayAccent.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: birthdayAccent.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.cake_outlined,
                        color: birthdayAccent,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  vendor.name,
                                  style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: birthdayAccent.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.navigation_rounded,
                                      size: 10,
                                      color: birthdayAccent,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${vendor.distanceKm} km away',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: birthdayAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${vendor.category} • ${vendor.address}',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 15, color: Color(0xFFFFC107)),
                              const SizedBox(width: 3),
                              Text(
                                '${vendor.rating} (${vendor.reviewsCount} reviews)',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.white.withValues(alpha: 0.15)),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3 Party Packages Available',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Starting ৳${vendor.startingPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.playfairDisplay(
                            color: birthdayAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showBirthdayVendorPackagesSheet(context, vendor),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: birthdayAccent,
                        foregroundColor: const Color(0xFF141210),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.cake, size: 14),
                      label: Text(
                        'View Tiers',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Birthday Packages Modal Sheet ─────────────────────────────────────────
  void _showBirthdayVendorPackagesSheet(BuildContext context, NearbyVendor vendor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _BirthdayVendorPackagesView(vendor: vendor);
      },
    );
  }

  // ── Change Location Dialog ────────────────────────────────────────────────
  void _showLocationChangeSheet(BuildContext context) {
    final controller = TextEditingController(text: _currentLocation);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1816),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Nearby Location',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find nearby birthday party vendors around your location.',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on, color: birthdayAccent),
                  hintText: 'e.g. Uttara, Dhanmondi or Sylhet',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: birthdayAccent.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      setState(() => _currentLocation = text);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: birthdayAccent,
                    foregroundColor: const Color(0xFF141210),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Apply Location',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Birthday Vendor Packages Modal View ────────────────────────────────────
class _BirthdayVendorPackagesView extends StatefulWidget {
  final NearbyVendor vendor;

  const _BirthdayVendorPackagesView({required this.vendor});

  @override
  State<_BirthdayVendorPackagesView> createState() =>
      _BirthdayVendorPackagesViewState();
}

class _BirthdayVendorPackagesViewState
    extends State<_BirthdayVendorPackagesView> {
  late VendorPackage _selectedPackage;

  @override
  void initState() {
    super.initState();
    _selectedPackage = widget.vendor.packages.firstWhere(
      (p) => p.tier == PackageTier.moderate,
      orElse: () => widget.vendor.packages.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1618),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
            color: VoworaColors.dustyRose.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vendor.name,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Customize Birthday Party Package Tiers',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.dustyRose,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.12)),

          // 3 Tier Buttons Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: widget.vendor.packages.map((pkg) {
                final isSelected = _selectedPackage.id == pkg.id;
                String tierLabel = 'Basic';
                if (pkg.tier == PackageTier.moderate) tierLabel = 'Festive ⭐';
                if (pkg.tier == PackageTier.premium) tierLabel = 'Deluxe';

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedPackage = pkg);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? VoworaColors.dustyRose
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? VoworaColors.dustyRose
                              : Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            tierLabel,
                            style: GoogleFonts.plusJakartaSans(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '৳${pkg.basePrice.toStringAsFixed(0)}',
                            style: GoogleFonts.playfairDisplay(
                              color: isSelected ? Colors.black : VoworaColors.dustyRose,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: VoworaColors.dustyRose.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: VoworaColors.dustyRose.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedPackage.name,
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: VoworaColors.dustyRose,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _selectedPackage.tier.name.toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedPackage.description,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customize Party Add-ons',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Check/Uncheck items',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.dustyRose,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedPackage.items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _selectedPackage.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: item.isSelected
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: item.isSelected
                                ? VoworaColors.dustyRose.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isSelected,
                              activeColor: VoworaColors.dustyRose,
                              checkColor: Colors.black,
                              onChanged: (val) {
                                setState(() {
                                  item.isSelected = val ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item.name,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      if (item.isDefaultIncluded) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Included',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: Colors.white70,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.description,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              item.isDefaultIncluded && item.isSelected
                                  ? 'Included'
                                  : '+৳${item.defaultPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.playfairDisplay(
                                color: VoworaColors.dustyRose,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Dynamic Calculation & Action Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF120E10),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Customized Estimate',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      '৳${_selectedPackage.calculateTotalPrice().toStringAsFixed(0)}',
                      style: GoogleFonts.playfairDisplay(
                        color: VoworaColors.dustyRose,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: VoworaColors.dustyRose,
                            content: Text(
                              'Birthday party booking request sent for "${widget.vendor.name}"! 🎂',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VoworaColors.dustyRose,
                        foregroundColor: const Color(0xFF141210),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Book Birthday Party',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
