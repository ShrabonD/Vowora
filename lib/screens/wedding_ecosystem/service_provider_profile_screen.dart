import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_ecosystem_models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_ecosystem_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/guest_gate_dialog.dart';

class ServiceProviderProfileScreen extends StatelessWidget {
  const ServiceProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingEcosystemProvider>(context);
    final providerItem = ModalRoute.of(context)?.settings.arguments as ServiceProviderModel? ??
        provider.serviceProviders.first;

    return Scaffold(
      backgroundColor: VoworaColors.darkBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: VoworaColors.darkBackground,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                providerItem.name,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    providerItem.profileImageUrl,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) return child;
                      return Image.asset('assets/images/wedding_background.png', fit: BoxFit.cover);
                    },
                    errorBuilder: (c, e, s) => Image.asset('assets/images/wedding_background.png', fit: BoxFit.cover),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black38,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${providerItem.rating} (${providerItem.reviewsCount} reviews)',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '📍 ${providerItem.location}',
                      style: GoogleFonts.plusJakartaSans(color: VoworaColors.champagneGold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  providerItem.bio,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 24),

                // Portfolio Albums Header
                Text('Portfolio Samples', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: providerItem.portfolioImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            providerItem.portfolioImages[index],
                            width: 140,
                            height: 120,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded || frame != null) return child;
                              return Image.asset(
                                'assets/images/wedding_background.png',
                                width: 140,
                                height: 120,
                                fit: BoxFit.cover,
                              );
                            },
                            errorBuilder: (c, e, s) => Image.asset(
                              'assets/images/wedding_background.png',
                              width: 140,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Available Service Packages
                Text('Service Packages', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                if (providerItem.packages.isEmpty)
                  Text('Custom pricing on inquiry.', style: GoogleFonts.plusJakartaSans(color: Colors.white60))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: providerItem.packages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final pkg = providerItem.packages[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: VoworaColors.champagneGold.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(pkg.name, style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('৳${(pkg.price / 1000).toStringAsFixed(0)}k', style: GoogleFonts.playfairDisplay(color: VoworaColors.champagneGold, fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(pkg.photographySummary, style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  if (authProvider.isGuest) {
                                    GuestGateDialog.show(
                                      context,
                                      onCreateAccount: () => Navigator.pushNamed(context, AppRoutes.signup),
                                    );
                                  } else {
                                    provider.createBookingRequest(provider: providerItem, package: pkg);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Booking Request Sent to "${providerItem.name}"! 🎉')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: VoworaColors.champagneGold,
                                  foregroundColor: Colors.black,
                                ),
                                child: Text('Book ${providerItem.type.name.toUpperCase()}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
