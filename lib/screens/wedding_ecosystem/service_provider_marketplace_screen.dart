import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/services/supabase_database_service.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_ecosystem_models.dart';
import '../../providers/wedding_ecosystem_provider.dart';
import '../../routes/app_routes.dart';

class ServiceProviderMarketplaceScreen extends StatefulWidget {
  const ServiceProviderMarketplaceScreen({super.key});

  @override
  State<ServiceProviderMarketplaceScreen> createState() =>
      _ServiceProviderMarketplaceScreenState();
}

class _ServiceProviderMarketplaceScreenState
    extends State<ServiceProviderMarketplaceScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Photography',
    'Videography',
    'Decoration',
    'Catering',
    'Venue',
    'Entertainment',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingEcosystemProvider>(context);
    final providersList = provider.serviceProviders;

    final filteredProviders = providersList.where((p) {
      if (_selectedCategory != 'All' &&
          p.type.name.toLowerCase() != _selectedCategory.toLowerCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !p.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !p.location.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

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
        title: Text(
          'Vendor Marketplace 🛍️',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize_rounded,
                color: VoworaColors.champagneGold),
            tooltip: 'Provider Dashboard',
            onPressed: () {
              provider.setActiveRole(UserRole.serviceProvider);
              Navigator.pushNamed(context, AppRoutes.serviceProviderDashboard);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search vendors by name or city...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: VoworaColors.champagneGold),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2)),
                  ),
                ),
              ),
            ),

            // Category Filter Pills
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSel = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel
                              ? VoworaColors.champagneGold
                              : Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel
                                ? VoworaColors.champagneGold
                                : Colors.white24,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSel ? const Color(0xFF141210) : Colors.white,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Providers List with Supabase Realtime Stream
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: SupabaseDatabaseService.streamServiceProviders(),
                builder: (context, snapshot) {
                  List<ServiceProviderModel> displayList = filteredProviders;

                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                    displayList = snapshot.data!.map((json) {
                      return ServiceProviderModel(
                        id: json['id'] ?? '',
                        name: json['name'] ?? 'Vendor',
                        type: ServiceProviderType.values.firstWhere(
                          (e) => e.name == json['type'],
                          orElse: () => ServiceProviderType.photographer,
                        ),
                        location: json['location'] ?? 'Dhaka',
                        rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
                        reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 50,
                        startingPrice: (json['starting_price'] as num?)?.toDouble() ?? 25000.0,
                        portfolioCount: (json['portfolio_count'] as num?)?.toInt() ?? 20,
                        isAvailable: json['is_available'] ?? true,
                        profileImageUrl: json['profile_image_url'] ?? 'https://images.unsplash.com/photo-1537633552985-df8429e8048b',
                        bio: json['bio'] ?? '',
                        portfolioImages: (json['portfolio_images'] as List?)?.map((e) => e.toString()).toList() ?? [],
                        packages: [],
                      );
                    }).where((p) {
                      if (_selectedCategory != 'All' &&
                          p.type.name.toLowerCase() != _selectedCategory.toLowerCase()) {
                        return false;
                      }
                      if (_searchQuery.isNotEmpty &&
                          !p.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                          !p.location.toLowerCase().contains(_searchQuery.toLowerCase())) {
                        return false;
                      }
                      return true;
                    }).toList();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: displayList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final providerItem = displayList[index];
                      return _buildProviderCard(context, providerItem, provider);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(
    BuildContext context,
    ServiceProviderModel providerItem,
    WeddingEcosystemProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: VoworaColors.champagneGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  providerItem.profileImageUrl,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return Image.asset(
                      'assets/images/wedding_background.png',
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    );
                  },
                  errorBuilder: (c, e, s) => Image.asset(
                    'assets/images/wedding_background.png',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerItem.name,
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '📍 ${providerItem.location} • ${providerItem.type.name.toUpperCase()}',
                      style: GoogleFonts.plusJakartaSans(
                        color: VoworaColors.champagneGold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFC107), size: 15),
                        const SizedBox(width: 3),
                        Text(
                          '${providerItem.rating} (${providerItem.reviewsCount} reviews)',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '📸 ${providerItem.portfolioCount} Photos',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white60,
                            fontSize: 11,
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
          Text(
            providerItem.bio,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'From ৳${(providerItem.startingPrice / 1000).toStringAsFixed(0)}k',
                  style: GoogleFonts.playfairDisplay(
                    color: VoworaColors.champagneGold,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.serviceProviderProfile,
                        arguments: providerItem,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Profile'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.serviceProviderProfile,
                        arguments: providerItem,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: VoworaColors.champagneGold,
                      foregroundColor: const Color(0xFF141210),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Book',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
