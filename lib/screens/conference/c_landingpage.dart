import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';

class ConferenceLandingPage extends StatelessWidget {
  const ConferenceLandingPage({super.key});

  static const _services = [
    (
      title: 'Explore and Book Hall',
      icon: Icons.roofing_rounded,
      color: Color(0xFFE5B96F),
      route: AppRoutes.hallList,
    ),
    (
      title: 'Restaurant & Food',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFE77C69),
      route: AppRoutes.conferenceFood,
    ),
    (
      title: 'Sound & Screens',
      icon: Icons.volume_up_rounded,
      color: Color(0xFFB795F5),
      route: AppRoutes.conferenceSound,
    ),
    (
      title: 'Decoration',
      icon: Icons.local_florist_rounded,
      color: Color(0xFF7BDD8C),
      route: AppRoutes.conferenceDecoration,
    ),
    (
      title: 'Photography',
      icon: Icons.camera_alt_rounded,
      color: Color(0xFF6CCAD6),
      route: AppRoutes.conferencePhotography,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A0B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/conference/c_wall.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.50),
                  const Color(0xFF080A0B).withValues(alpha: 0.82),
                  const Color(0xFF080A0B),
                ],
                stops: const [0.0, 0.34, 0.72],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
              child: Column(
                children: [
                  Text(
                    'Welcome to',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Vowora',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: const Color(0xFFE5C58B),
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Conference Section',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose an option to explore our services',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 42),
                  for (final service in _services) ...[
                    _ConferenceServiceTile(
                      title: service.title,
                      icon: service.icon,
                      color: service.color,
                      onTap: () =>
                          Navigator.pushNamed(context, service.route),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConferenceServiceTile extends StatelessWidget {
  const _ConferenceServiceTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.64),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(minHeight: 116),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.72)),
          ),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.22)),
                ),
                child: Icon(icon, color: color, size: 34),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
