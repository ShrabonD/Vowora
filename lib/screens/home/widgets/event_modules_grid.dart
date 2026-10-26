import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/vowora_theme.dart';
import '../../../providers/wedding_wizard_provider.dart';
import '../../../routes/app_routes.dart';

class EventModulesGrid extends StatelessWidget {
  final BoxConstraints constraints;

  const EventModulesGrid({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.15,
      children: [
        // 1. Wedding
        _buildModuleCard(
          context,
          title: 'Wedding',
          subtitle: 'Complete end-to-end wedding manager',
          icon: Icons.diversity_1_rounded,
          accentColor: VoworaColors.champagneGold,
          route: AppRoutes.weddingManager,
          bgImageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552',
          onCustomTap: () {
            final provider = Provider.of<WeddingWizardProvider>(context, listen: false);
            if (provider.booking.isConfirmed) {
              Navigator.pushNamed(context, AppRoutes.weddingDashboard);
            } else {
              Navigator.pushNamed(context, AppRoutes.weddingManager);
            }
          },
        ),
        // 2. Birthday
        _buildModuleCard(
          context,
          title: 'Birthday',
          subtitle: 'Celebrate another beautiful year',
          icon: Icons.cake_rounded,
          accentColor: VoworaColors.dustyRose,
          route: AppRoutes.birthdayStudio,
          bgImageUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d',
        ),
        // 3. Anniversary & Others
        _buildModuleCard(
          context,
          title: 'Anniversary',
          subtitle: 'Milestones, Sraddho, or Khatna',
          icon: Icons.celebration_rounded,
          accentColor: const Color(0xFF6FCFB0),
          route: AppRoutes.weddingSetup,
          bgImageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622',
        ),
        // 4. Cultural / Corporate Gatherings
        _buildModuleCard(
          context,
          title: 'Gatherings',
          subtitle: 'Corporate, Seminars & Fests',
          icon: Icons.festival_rounded,
          accentColor: const Color(0xFF9B8FE0),
          route: AppRoutes.weddingSetup,
          bgImageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30',
        ),
        // 5. Conference (FIXED)
        _buildModuleCard(
          context,
          title: 'Conference',
          subtitle: 'Corporate, Seminars & Fests',
          icon: Icons.festival_rounded,
          accentColor: const Color(0xFF9B8FE0),
          route: AppRoutes.cLandingPage,
          bgImageUrl: 'assets/conference/c_logo.png', // Fixed path and spelling
        ),
        // 6. Custom Event
        _buildModuleCard(
          context,
          title: 'Custom Event',
          subtitle: 'Design your own unique event',
          icon: Icons.dashboard_customize_rounded,
          accentColor: const Color(0xFF5EC8C4),
          route: AppRoutes.weddingSetup,
          bgImageUrl: 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3',
        ),
      ],
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required String route,
    required String bgImageUrl,
    VoidCallback? onCustomTap,
  }) {
    // Check if it's a local asset or a network image
    final bool isAsset = bgImageUrl.startsWith('assets/');

    return GestureDetector(
      onTap: onCustomTap ?? () => Navigator.pushNamed(context, route),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // 1. Distinct Event Background Image
            Positioned.fill(
              child: isAsset
                  ? Image.asset(
                      bgImageUrl,
                      fit: BoxFit.contain, // Contain so the logo isn't cropped
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/wedding_background.png', fit: BoxFit.cover);
                      },
                    )
                  : Image.network(
                      bgImageUrl,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) return child;
                        return Image.asset('assets/images/wedding_background.png', fit: BoxFit.cover);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/wedding_background.png', fit: BoxFit.cover);
                      },
                    ),
            ),

            // 2. Dark Gradient Overlay for High Readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.70),
                      Colors.black.withValues(alpha: 0.92),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),

            // 3. Card Content & Accent Glass Border
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.6),
                              width: 1.0,
                            ),
                          ),
                          child: Icon(icon, color: accentColor, size: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.8),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}