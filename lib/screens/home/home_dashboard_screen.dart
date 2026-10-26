import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_provider.dart';
import '../../providers/wedding_wizard_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/guest_gate_dialog.dart';
import 'widgets/event_countdown_card.dart';
import 'widgets/event_modules_grid.dart';
import 'widgets/inspiration_callout_banner.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final wizardProvider = Provider.of<WeddingWizardProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.userProfile != null) {
        wizardProvider.loadUserWeddingFromSupabase(authProvider.userProfile!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final weddingProvider = Provider.of<WeddingProvider>(context);

    final userName = authProvider.userProfile?.fullName.split(' ').first ?? 'Planner';
    final activeEvent = weddingProvider.weddingProfile;

    return Scaffold(
      backgroundColor: VoworaColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withValues(alpha: 0.18),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, $userName ♡',
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            Text(
              "Let's make your next event beautifully organized.",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          if (authProvider.isGuest)
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: ActionChip(
                backgroundColor: VoworaColors.champagneGold.withValues(alpha: 0.25),
                side: BorderSide(color: VoworaColors.champagneGold.withValues(alpha: 0.5)),
                label: Text(
                  'Guest Mode',
                  style: GoogleFonts.plusJakartaSans(
                    color: VoworaColors.champagneGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                onPressed: () {
                  GuestGateDialog.show(
                    context,
                    onCreateAccount: () => Navigator.pushNamed(context, AppRoutes.signup),
                  );
                },
              ),
            ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/wedding_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Dark Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 32 : 18,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Next Event Countdown Card Widget
                      EventCountdownCard(activeEvent: activeEvent),
                      const SizedBox(height: 16),

                      // Join Event Quick Action Banner
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.joinWedding),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: VoworaColors.champagneGold.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: VoworaColors.champagneGold.withValues(alpha: 0.45),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: VoworaColors.champagneGold.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.qr_code_scanner_rounded, color: VoworaColors.champagneGold, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Join an Event 💌',
                                      style: GoogleFonts.playfairDisplay(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Have an Invitation Link, Code or QR Code?',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white70,
                                        fontSize: 10.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: VoworaColors.champagneGold, size: 14),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan New Event',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              '6 Categories',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Grid of 5 Event Modules (Wedding, Birthday, Anniversary, etc.)
                      EventModulesGrid(constraints: constraints),
                      const SizedBox(height: 24),

                      // Inspiration Callout Banner
                      const InspirationCalloutBanner(),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
