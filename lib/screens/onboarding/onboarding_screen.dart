import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/vowora_theme.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Your Love Story\nStarts Here',
      'subtitle':
          'From the first checklist to the final celebration, Vowora brings every wedding detail beautifully together.',
    },
    {
      'title': 'Plan Every\nBeautiful Detail',
      'subtitle':
          'Manage your budget, guests, vendors, checklist, timeline and wedding ideas — all from one elegant space.',
    },
    {
      'title': 'Celebrate Without\nthe Stress',
      'subtitle':
          'Stay organized, stay on budget and enjoy the journey while Vowora takes care of the planning.',
    },
  ];

  Future<void> _completeOnboarding() async {
    await StorageService.setOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Imagery
          Positioned.fill(
            child: Image.asset(
              VoworaConstants.bgWeddingHero,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Bar with Skip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        VoworaConstants.appName,
                        style: GoogleFonts.playfairDisplay(
                          color: VoworaColors.champagneGold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                        ),
                      ),
                      if (_currentIndex < _pages.length - 1)
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            'Skip',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // PageView Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final item = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              item['subtitle']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Page Indicators & Navigation Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    children: [
                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? VoworaColors.champagneGold
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentIndex < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _completeOnboarding();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VoworaColors.champagneGold,
                            foregroundColor: const Color(0xFF141210),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            _currentIndex == _pages.length - 1 ? 'Get Started →' : 'Next →',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
