import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/birthday_theme.dart';
import '../../providers/birthday_provider.dart';
import '../../models/birthday/birthday_event.dart';
import 'birthday_create_event_screen.dart';
import 'birthday_ai_designer_screen.dart';
import 'birthday_theme_studio_screen.dart';
import 'birthday_budget_screen.dart';
import 'birthday_cake_studio_screen.dart';
import 'birthday_guests_screen.dart';
import 'birthday_invitation_screen.dart';
import 'birthday_checklist_screen.dart';
import 'birthday_gifts_screen.dart';
import 'birthday_timeline_screen.dart';
import 'birthday_memory_vault_screen.dart';

/// The central hub for the Birthday Studio module.
/// Provides access to upcoming celebrations, planning features, and analytics.
class BirthdayHomeScreen extends StatefulWidget {
  const BirthdayHomeScreen({super.key});

  @override
  State<BirthdayHomeScreen> createState() => _BirthdayHomeScreenState();
}

class _BirthdayHomeScreenState extends State<BirthdayHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BirthdayProvider>().loadAll();
      }
    });
  }

  /// Formats currency to Bangladeshi Taka (৳) with commas.
  String _formatCurrency(num amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return isNegative ? '-৳$formatted' : '৳$formatted';
  }

  /// Formats a DateTime into a friendly string (e.g. "Nov 15, 2026").
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BirthdayTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: BirthdayTheme.warmIvory,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: BirthdayTheme.deepCocoa),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: BirthdayTheme.deepCocoa,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Birthday Studio', style: BirthdayTheme.heading2),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: BirthdayTheme.deepCocoa,
            ),
            tooltip: 'Refresh',
            onPressed: () => context.read<BirthdayProvider>().loadAll(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<BirthdayProvider>(
        builder: (context, provider, child) {
          final upcomingEvents = provider.upcomingEvents;
          final activeEvent = provider.activeEvent;

          return RefreshIndicator(
            color: BirthdayTheme.mutedGold,
            backgroundColor: BirthdayTheme.softWhite,
            onRefresh: () => provider.loadAll(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Loading progress indicator
                  if (provider.isLoading)
                    const LinearProgressIndicator(
                      minHeight: 2.5,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        BirthdayTheme.mutedGold,
                      ),
                    ),

                  const SizedBox(height: 12),

                  // B. Header Section
                  _buildHeaderSection(),

                  const SizedBox(height: 24),

                  // C. Hero Banner
                  _buildHeroBanner(context),

                  const SizedBox(height: 32),

                  // D. Upcoming Celebrations
                  _buildUpcomingCelebrations(context, provider, upcomingEvents),

                  const SizedBox(height: 32),

                  // E. Feature Grid (12 items)
                  _buildFeatureGrid(context),

                  const SizedBox(height: 32),

                  // F. Planning Overview Dashboard
                  _buildPlanningOverview(context, provider, activeEvent),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // SECTION B: HEADER
  // ===========================================================================
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Birthday Studio',
                        style: BirthdayTheme.heading1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: BirthdayTheme.champagneBeige.withValues(
                          alpha: 0.38,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BirthdayTheme.mutedGold.withValues(
                            alpha: 0.22,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: BirthdayTheme.roseBeige.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.cake_rounded,
                        color: BirthdayTheme.mutedGold,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Make their day unforgettable.',
                  style: BirthdayTheme.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION C: HERO BANNER
  // ===========================================================================
  Widget _buildHeroBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 230,
          width: double.infinity,
          decoration: BoxDecoration(
            color: BirthdayTheme.champagneBeige,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: BirthdayTheme.deepCocoa.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero Asset Image with error fallback
              Image.asset(
                BirthdayTheme.heroImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          BirthdayTheme.champagneBeige,
                          BirthdayTheme.roseBeige.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.celebration_rounded,
                        color: BirthdayTheme.mutedGold.withValues(alpha: 0.6),
                        size: 64,
                      ),
                    ),
                  );
                },
              ),

              // Rose-tinted shading keeps the image visible while preserving text contrast.
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      BirthdayTheme.roseBeige.withValues(alpha: 0.08),
                      BirthdayTheme.deepCocoa.withValues(alpha: 0.18),
                      BirthdayTheme.deepCocoa.withValues(alpha: 0.72),
                    ],
                    stops: const [0.0, 0.48, 1.0],
                  ),
                ),
              ),

              // Overlay content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: BirthdayTheme.deepCocoa.withValues(
                            alpha: 0.34,
                          ),
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: BirthdayTheme.softWhite.withValues(
                              alpha: 0.28,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Every Celebration Tells a Story',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: BirthdayTheme.softWhite,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Plan a birthday filled with beautiful little moments.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: BirthdayTheme.softWhite.withValues(
                                  alpha: 0.92,
                                ),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 11),
                            ElevatedButton(
                              style: BirthdayTheme.primaryButton,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BirthdayCreateEventScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_rounded,
                                    size: 18,
                                    color: BirthdayTheme.softWhite,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Plan a Birthday',
                                    style: BirthdayTheme.buttonText.copyWith(
                                      color: BirthdayTheme.softWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION D: UPCOMING CELEBRATIONS
  // ===========================================================================
  Widget _buildUpcomingCelebrations(
    BuildContext context,
    BirthdayProvider provider,
    List<BirthdayEvent> upcomingEvents,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title + Count Badge + Add Action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('Upcoming Celebrations', style: BirthdayTheme.heading3),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: BirthdayTheme.mutedGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${upcomingEvents.length}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: BirthdayTheme.mutedGold,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BirthdayCreateEventScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 16,
                  color: BirthdayTheme.mutedGold,
                ),
                label: Text(
                  'Add',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BirthdayTheme.mutedGold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        if (upcomingEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildEmptyCelebrationsState(context),
          )
        else
          SizedBox(
            height: 215,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: upcomingEvents.length,
              itemBuilder: (context, index) {
                final event = upcomingEvents[index];
                return _buildEventCard(context, provider, event);
              },
            ),
          ),
      ],
    );
  }

  /// Empty state when no events exist yet
  Widget _buildEmptyCelebrationsState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BirthdayTheme.cardDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BirthdayTheme.champagneBeige.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cake_outlined,
              color: BirthdayTheme.mutedGold,
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No upcoming celebrations yet',
            style: BirthdayTheme.heading3.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Start planning a memorable birthday celebration today with personalized themes and budgets.',
            style: BirthdayTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            style: BirthdayTheme.secondaryButton,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BirthdayCreateEventScreen(),
                ),
              );
            },
            child: const Text('Plan First Celebration'),
          ),
        ],
      ),
    );
  }

  /// Single Event Card in horizontal list
  Widget _buildEventCard(
    BuildContext context,
    BirthdayProvider provider,
    BirthdayEvent event,
  ) {
    final isSelected = provider.activeEvent?.id == event.id;
    final readinessPercent = isSelected ? provider.eventReadiness.round() : 65;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 14, bottom: 4, top: 2),
      decoration: BirthdayTheme.cardDecoration.copyWith(
        border: Border.all(
          color: isSelected
              ? BirthdayTheme.mutedGold
              : BirthdayTheme.subtleBorder,
          width: isSelected ? 1.5 : 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            provider.setActiveEvent(event);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BirthdayCreateEventScreen(event: event),
              ),
            );
          },
          onLongPress: () => _showDeleteConfirmation(context, provider, event),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Person name & Days remaining
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.personName,
                        style: BirthdayTheme.heading3.copyWith(fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: event.daysRemaining <= 7
                            ? BirthdayTheme.alertOrange.withValues(alpha: 0.15)
                            : BirthdayTheme.mutedGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.daysRemaining == 0
                            ? 'Today!'
                            : '${event.daysRemaining}d left',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: event.daysRemaining <= 7
                              ? BirthdayTheme.alertOrange
                              : BirthdayTheme.mutedGold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Row 2: Date & Theme chip
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: BirthdayTheme.mutedGold,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _formatDate(event.eventDate),
                      style: BirthdayTheme.bodySmall.copyWith(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: BirthdayTheme.champagneBeige.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.theme,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: BirthdayTheme.deepCocoa.withValues(
                              alpha: 0.8,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Row 3: Completion progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Readiness',
                      style: BirthdayTheme.bodySmall.copyWith(fontSize: 11),
                    ),
                    Text(
                      '$readinessPercent%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: BirthdayTheme.mutedGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (readinessPercent / 100).clamp(0.0, 1.0),
                    minHeight: 5,
                    backgroundColor: BirthdayTheme.champagneBeige.withValues(
                      alpha: 0.6,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      BirthdayTheme.mutedGold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: BirthdayTheme.subtleBorder),
                const SizedBox(height: 8),

                // Row 4: Budget summary & Guest count
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 14,
                      color: BirthdayTheme.mutedGold,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _formatCurrency(event.totalBudget),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: BirthdayTheme.deepCocoa,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 14,
                      color: BirthdayTheme.mutedGold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.expectedGuestCount} guests',
                      style: BirthdayTheme.bodySmall.copyWith(fontSize: 11),
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

  /// Delete confirmation dialog on long-press
  void _showDeleteConfirmation(
    BuildContext context,
    BirthdayProvider provider,
    BirthdayEvent event,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: BirthdayTheme.softWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Celebration?', style: BirthdayTheme.heading3),
        content: Text(
          'Are you sure you want to delete the celebration for "${event.personName}"? All associated tasks, guests, gifts, and budgets will be permanently removed.',
          style: BirthdayTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: BirthdayTheme.deepCocoa.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: BirthdayTheme.errorRed,
              foregroundColor: BirthdayTheme.softWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await provider.deleteEvent(event.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Deleted celebration for ${event.personName}',
                    ),
                    backgroundColor: BirthdayTheme.deepCocoa,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION E: FEATURE GRID (12 ITEMS)
  // ===========================================================================
  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      _FeatureConfig(
        title: 'Birthday Planner',
        subtitle: 'Plan & manage',
        icon: Icons.event_note_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayCreateEventScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'AI Designer',
        subtitle: 'Smart suggestions',
        icon: Icons.auto_awesome_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayAiDesignerScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Theme Studio',
        subtitle: 'Palettes & decor',
        icon: Icons.palette_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayThemeStudioScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Budget Manager',
        subtitle: 'Track spending',
        icon: Icons.account_balance_wallet_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayBudgetScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Cake Studio',
        subtitle: 'Custom cakes',
        icon: Icons.cake_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayCakeStudioScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Guest & RSVP',
        subtitle: 'Track attendees',
        icon: Icons.people_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayGuestsScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Invitations',
        subtitle: 'Digital cards',
        icon: Icons.mail_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayInvitationScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Checklist',
        subtitle: 'Task timeline',
        icon: Icons.checklist_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayChecklistScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Gift Wishlist',
        subtitle: 'Registry ideas',
        icon: Icons.card_giftcard_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayGiftsScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Vendors',
        subtitle: 'Find & book',
        icon: Icons.store_rounded,
        onTap: () => Navigator.pushNamed(context, '/birthday-vendors'),
      ),
      _FeatureConfig(
        title: 'Party Timeline',
        subtitle: 'Day schedule',
        icon: Icons.timeline_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayTimelineScreen()),
        ),
      ),
      _FeatureConfig(
        title: 'Memory Vault',
        subtitle: 'Photos & moments',
        icon: Icons.photo_library_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BirthdayMemoryVaultScreen()),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Birthday Features', style: BirthdayTheme.heading3),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 380 ? 2 : 3;
              final childAspectRatio = constraints.maxWidth < 380 ? 1.05 : 0.88;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final item = features[index];
                  return _buildFeatureItem(item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Single Feature Card
  Widget _buildFeatureItem(_FeatureConfig item) {
    return Container(
      decoration: BirthdayTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: BirthdayTheme.champagneBeige.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: BirthdayTheme.roseBeige.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    color: BirthdayTheme.mutedGold,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: BirthdayTheme.deepCocoa,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION F: PLANNING OVERVIEW DASHBOARD
  // ===========================================================================
  Widget _buildPlanningOverview(
    BuildContext context,
    BirthdayProvider provider,
    BirthdayEvent? activeEvent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Planning Overview', style: BirthdayTheme.heading3),
              if (activeEvent != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: BirthdayTheme.champagneBeige.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      activeEvent.personName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: BirthdayTheme.deepCocoa,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          if (activeEvent == null)
            _buildEmptyOverviewState(context)
          else ...[
            // Active event selector indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: BirthdayTheme.champagneBeige.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: BirthdayTheme.subtleBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.celebration_rounded,
                    color: BirthdayTheme.mutedGold,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Active: ${activeEvent.personName}\'s Birthday (${activeEvent.theme})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: BirthdayTheme.deepCocoa,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (provider.events.length > 1)
                    PopupMenuButton<BirthdayEvent>(
                      tooltip: 'Switch event',
                      icon: const Icon(
                        Icons.swap_horiz_rounded,
                        color: BirthdayTheme.mutedGold,
                        size: 20,
                      ),
                      onSelected: (event) => provider.setActiveEvent(event),
                      itemBuilder: (context) {
                        return provider.events.map((e) {
                          final isCurrent = e.id == activeEvent.id;
                          return PopupMenuItem<BirthdayEvent>(
                            value: e,
                            child: Row(
                              children: [
                                if (isCurrent)
                                  const Icon(
                                    Icons.check_rounded,
                                    color: BirthdayTheme.mutedGold,
                                    size: 16,
                                  )
                                else
                                  const SizedBox(width: 16),
                                const SizedBox(width: 8),
                                Text(
                                  e.personName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: isCurrent
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: BirthdayTheme.deepCocoa,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList();
                      },
                    ),
                ],
              ),
            ),

            // 8 Stat Cards Grid
            _buildStatCardsGrid(provider, activeEvent),
          ],
        ],
      ),
    );
  }

  /// Empty state when no active event is present
  Widget _buildEmptyOverviewState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BirthdayTheme.cardDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BirthdayTheme.champagneBeige.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: BirthdayTheme.mutedGold,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No active celebration selected',
            style: BirthdayTheme.heading3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Select a celebration from upcoming events or plan a new one to view planning metrics, task progress, and budget overview.',
            style: BirthdayTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Grid of 8 stats
  Widget _buildStatCardsGrid(
    BirthdayProvider provider,
    BirthdayEvent activeEvent,
  ) {
    final stats = [
      _StatData(
        label: 'Total Events',
        value: '${provider.events.length}',
        icon: Icons.event_available_rounded,
        accentColor: BirthdayTheme.mutedGold,
      ),
      _StatData(
        label: 'Upcoming',
        value: '${provider.upcomingEvents.length}',
        icon: Icons.upcoming_rounded,
        accentColor: BirthdayTheme.deepCocoa,
      ),
      _StatData(
        label: 'Tasks Done',
        value: '${provider.totalTasksCompleted}',
        icon: Icons.task_alt_rounded,
        accentColor: BirthdayTheme.successGreen,
      ),
      _StatData(
        label: 'Tasks Left',
        value: '${provider.totalTasksPending}',
        icon: Icons.pending_actions_rounded,
        accentColor: BirthdayTheme.alertOrange,
      ),
      _StatData(
        label: 'Total Budget',
        value: _formatCurrency(activeEvent.totalBudget),
        icon: Icons.account_balance_wallet_rounded,
        accentColor: BirthdayTheme.mutedGold,
      ),
      _StatData(
        label: 'Actual Spend',
        value: _formatCurrency(provider.totalActualSpending),
        icon: Icons.shopping_bag_outlined,
        accentColor: BirthdayTheme.deepCocoa,
      ),
      _StatData(
        label: 'Remaining',
        value: _formatCurrency(provider.remainingBudget),
        icon: Icons.savings_outlined,
        accentColor: provider.remainingBudget >= 0
            ? BirthdayTheme.successGreen
            : BirthdayTheme.errorRed,
      ),
      _StatData(
        label: 'Readiness',
        value: '${provider.eventReadiness.toStringAsFixed(0)}%',
        icon: Icons.speed_rounded,
        accentColor: BirthdayTheme.mutedGold,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 420 ? 2 : 4;
        final childAspectRatio = constraints.maxWidth < 420 ? 2.1 : 1.8;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return _buildSingleStatCard(stat);
          },
        );
      },
    );
  }

  /// Single Stat Card
  Widget _buildSingleStatCard(_StatData stat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BirthdayTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: stat.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(stat.icon, color: stat.accentColor, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: BirthdayTheme.deepCocoa.withValues(alpha: 0.65),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  stat.value,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: BirthdayTheme.deepCocoa,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper data class for features
class _FeatureConfig {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

/// Helper data class for dashboard stats
class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });
}
