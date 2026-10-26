import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/birthday_theme.dart';
import '../../providers/birthday_provider.dart';
import '../../models/birthday/birthday_gift.dart';

class BirthdayGiftsScreen extends StatefulWidget {
  const BirthdayGiftsScreen({super.key});

  @override
  State<BirthdayGiftsScreen> createState() => _BirthdayGiftsScreenState();
}

class _BirthdayGiftsScreenState extends State<BirthdayGiftsScreen> {
  String _selectedFilter = 'All'; // All, Pending, Purchased

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BirthdayTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: BirthdayTheme.warmIvory,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: BirthdayTheme.deepCocoa, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Gift Wishlist',
          style: BirthdayTheme.heading3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard_rounded, color: BirthdayTheme.mutedGold),
            tooltip: 'Add Gift Idea',
            onPressed: () {
              final provider = Provider.of<BirthdayProvider>(context, listen: false);
              if (provider.activeEvent != null) {
                _showAddEditGiftSheet(context, provider: provider);
              } else {
                _showNoEventSnack(context);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<BirthdayProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: BirthdayTheme.mutedGold),
            );
          }

          final activeEvent = provider.activeEvent;
          if (activeEvent == null) {
            return _buildNoActiveEventState(context);
          }

          final gifts = provider.gifts;
          final totalCount = gifts.length;
          final purchasedCount = gifts.where((g) => g.isPurchased).length;
          final pendingCount = gifts.where((g) => !g.isPurchased).length;
          final totalEstimatedValue = gifts.fold<double>(0, (sum, g) => sum + g.estimatedPrice);
          final purchasedValue = gifts
              .where((g) => g.isPurchased)
              .fold<double>(0, (sum, g) => sum + g.estimatedPrice);

          // Filtering
          List<BirthdayGift> filteredGifts = gifts.where((g) {
            switch (_selectedFilter) {
              case 'Purchased':
                return g.isPurchased;
              case 'Pending':
                return !g.isPurchased;
              case 'All':
              default:
                return true;
            }
          }).toList();

          return RefreshIndicator(
            color: BirthdayTheme.mutedGold,
            backgroundColor: BirthdayTheme.softWhite,
            onRefresh: () => provider.loadEventData(activeEvent.id),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary Cards Grid
                        _buildSummarySection(
                          totalCount: totalCount,
                          purchasedCount: purchasedCount,
                          pendingCount: pendingCount,
                          totalEstimatedValue: totalEstimatedValue,
                          purchasedValue: purchasedValue,
                        ),
                        const SizedBox(height: 18),

                        // Filter Tabs
                        _buildFilterTabs(
                          allCount: totalCount,
                          pendingCount: pendingCount,
                          purchasedCount: purchasedCount,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Gift List or Empty State
                if (filteredGifts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context, provider),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final gift = filteredGifts[index];
                          return _buildGiftCard(context, gift, provider);
                        },
                        childCount: filteredGifts.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: BirthdayTheme.mutedGold,
        foregroundColor: BirthdayTheme.softWhite,
        elevation: 4,
        onPressed: () {
          final provider = Provider.of<BirthdayProvider>(context, listen: false);
          if (provider.activeEvent != null) {
            _showAddEditGiftSheet(context, provider: provider);
          } else {
            _showNoEventSnack(context);
          }
        },
        icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
        label: Text('Add Gift', style: BirthdayTheme.buttonText.copyWith(color: BirthdayTheme.softWhite, fontSize: 14)),
      ),
    );
  }

  // ===== SUMMARY SECTION =====
  Widget _buildSummarySection({
    required int totalCount,
    required int purchasedCount,
    required int pendingCount,
    required double totalEstimatedValue,
    required double purchasedValue,
  }) {
    final double percent = totalCount == 0 ? 0 : (purchasedCount / totalCount * 100);

    return Container(
      decoration: BirthdayTheme.elevatedCardDecoration,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wishlist Overview',
                style: BirthdayTheme.heading3.copyWith(fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BirthdayTheme.mutedGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${percent.toStringAsFixed(0)}% Fulfilled',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: BirthdayTheme.mutedGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4 Metric Items Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'Total Gifts',
                  value: '$totalCount',
                  accentColor: BirthdayTheme.deepCocoa,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Purchased',
                  value: '$purchasedCount',
                  accentColor: BirthdayTheme.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.hourglass_top_rounded,
                  label: 'Pending',
                  value: '$pendingCount',
                  accentColor: BirthdayTheme.alertOrange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.payments_outlined,
                  label: 'Total Value',
                  value: '৳${_formatNumber(totalEstimatedValue)}',
                  accentColor: BirthdayTheme.mutedGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalCount == 0 ? 0 : (purchasedCount / totalCount),
              minHeight: 8,
              backgroundColor: BirthdayTheme.champagneBeige.withValues(alpha: 0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(BirthdayTheme.mutedGold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Purchased: ৳${_formatNumber(purchasedValue)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: BirthdayTheme.deepCocoa.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Pending: ৳${_formatNumber(totalEstimatedValue - purchasedValue)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: BirthdayTheme.deepCocoa.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: BirthdayTheme.warmIvory,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BirthdayTheme.subtleBorder, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
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

  // ===== FILTER TABS =====
  Widget _buildFilterTabs({
    required int allCount,
    required int pendingCount,
    required int purchasedCount,
  }) {
    final filters = [
      {'name': 'All', 'count': allCount},
      {'name': 'Pending', 'count': pendingCount},
      {'name': 'Purchased', 'count': purchasedCount},
    ];

    return Row(
      children: filters.map((f) {
        final name = f['name'] as String;
        final count = f['count'] as int;
        final isSelected = _selectedFilter == name;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() => _selectedFilter = name);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? BirthdayTheme.mutedGold : BirthdayTheme.softWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? BirthdayTheme.mutedGold : BirthdayTheme.subtleBorder,
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? BirthdayTheme.softWhite : BirthdayTheme.deepCocoa,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? BirthdayTheme.softWhite.withValues(alpha: 0.25)
                            : BirthdayTheme.champagneBeige.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? BirthdayTheme.softWhite : BirthdayTheme.deepCocoa,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ===== GIFT CARD ITEM =====
  Widget _buildGiftCard(
    BuildContext context,
    BirthdayGift gift,
    BirthdayProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(gift.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: BirthdayTheme.errorRed.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded, color: BirthdayTheme.softWhite, size: 24),
              SizedBox(width: 6),
              Text(
                'Delete',
                style: TextStyle(color: BirthdayTheme.softWhite, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: BirthdayTheme.softWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Delete Gift Item?', style: BirthdayTheme.heading3),
              content: Text(
                'Are you sure you want to remove "${gift.name}" from the wishlist?',
                style: BirthdayTheme.body,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('Cancel', style: TextStyle(color: BirthdayTheme.deepCocoa.withValues(alpha: 0.7))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BirthdayTheme.errorRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Delete', style: TextStyle(color: BirthdayTheme.softWhite)),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) {
          provider.deleteGift(gift.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removed "${gift.name}"'),
              backgroundColor: BirthdayTheme.deepCocoa,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: BirthdayTheme.champagneBeige,
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          decoration: BirthdayTheme.cardDecoration,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              _showAddEditGiftSheet(context, provider: provider, existingGift: gift);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Purchased Checkbox toggle
                      Transform.scale(
                        scale: 1.15,
                        child: Checkbox(
                          value: gift.isPurchased,
                          activeColor: BirthdayTheme.successGreen,
                          checkColor: BirthdayTheme.softWhite,
                          side: BorderSide(
                            color: BirthdayTheme.deepCocoa.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onChanged: (val) {
                            gift.isPurchased = val ?? false;
                            provider.updateGift(gift);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Name & description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gift.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: gift.isPurchased
                                    ? BirthdayTheme.deepCocoa.withValues(alpha: 0.5)
                                    : BirthdayTheme.deepCocoa,
                                decoration: gift.isPurchased ? TextDecoration.lineThrough : null,
                                decorationColor: BirthdayTheme.deepCocoa.withValues(alpha: 0.4),
                              ),
                            ),
                            if (gift.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                gift.description,
                                style: BirthdayTheme.bodySmall.copyWith(
                                  color: BirthdayTheme.deepCocoa.withValues(alpha: 0.65),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Estimated Price Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: BirthdayTheme.champagneBeige.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BirthdayTheme.subtleBorder, width: 0.8),
                        ),
                        child: Text(
                          '৳${_formatNumber(gift.estimatedPrice)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: BirthdayTheme.mutedGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Metadata & Badges Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Purchased Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: gift.isPurchased
                              ? BirthdayTheme.successGreen.withValues(alpha: 0.12)
                              : BirthdayTheme.alertOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: gift.isPurchased
                                ? BirthdayTheme.successGreen.withValues(alpha: 0.3)
                                : BirthdayTheme.alertOrange.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              gift.isPurchased ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                              size: 11,
                              color: gift.isPurchased ? BirthdayTheme.successGreen : BirthdayTheme.alertOrange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              gift.isPurchased ? 'Purchased' : 'Pending',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: gift.isPurchased ? BirthdayTheme.successGreen : BirthdayTheme.alertOrange,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Wrapped Badge
                      if (gift.isWrapped)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: BirthdayTheme.mutedGold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: BirthdayTheme.mutedGold.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.card_giftcard_rounded, size: 11, color: BirthdayTheme.mutedGold),
                              const SizedBox(width: 4),
                              Text(
                                'Gift Wrapped',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: BirthdayTheme.mutedGold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Assigned To Badge
                      if (gift.assignedTo.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: BirthdayTheme.champagneBeige.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: BirthdayTheme.subtleBorder, width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_pin_rounded, size: 12, color: BirthdayTheme.deepCocoa),
                              const SizedBox(width: 4),
                              Text(
                                gift.assignedTo,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: BirthdayTheme.deepCocoa,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Purchase Link tag
                      if (gift.purchaseLink.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: BirthdayTheme.warmIvory,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: BirthdayTheme.subtleBorder, width: 0.8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.link_rounded, size: 12, color: BirthdayTheme.mutedGold),
                              SizedBox(width: 4),
                              Text(
                                'Web Link',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: BirthdayTheme.mutedGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  if (gift.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: BirthdayTheme.warmIvory.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Note: ${gift.notes}',
                        style: BirthdayTheme.bodySmall.copyWith(
                          fontSize: 11,
                          color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== EMPTY STATE =====
  Widget _buildEmptyState(BuildContext context, BirthdayProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: BirthdayTheme.champagneBeige.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                size: 40,
                color: BirthdayTheme.mutedGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 'All'
                  ? 'Wishlist is Empty'
                  : 'No $_selectedFilter Gifts',
              style: BirthdayTheme.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'All'
                  ? 'Start compiling dream gifts, special surprises, or assigned birthday purchases for this event.'
                  : 'Change your selected filter or add a new gift to this list.',
              style: BirthdayTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: BirthdayTheme.primaryButton,
              onPressed: () => _showAddEditGiftSheet(context, provider: provider),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Gift Item'),
            ),
          ],
        ),
      ),
    );
  }

  // ===== NO ACTIVE EVENT =====
  Widget _buildNoActiveEventState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration_outlined, size: 64, color: BirthdayTheme.mutedGold),
            const SizedBox(height: 16),
            Text('No Active Event', style: BirthdayTheme.heading2),
            const SizedBox(height: 8),
            Text(
              'Select an active birthday event from your studio to view its gift wishlist.',
              style: BirthdayTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: BirthdayTheme.primaryButton,
              onPressed: () => Navigator.maybePop(context),
              child: const Text('Back to Studio'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoEventSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select or create an event first.')),
    );
  }

  // ===== ADD / EDIT GIFT BOTTOM SHEET =====
  void _showAddEditGiftSheet(
    BuildContext context, {
    required BirthdayProvider provider,
    BirthdayGift? existingGift,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _GiftFormSheet(
        provider: provider,
        existingGift: existingGift,
      ),
    );
  }

  static String _formatNumber(double val) {
    if (val >= 100000) {
      return '${(val / 1000).toStringAsFixed(1)}k';
    }
    return val.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

// ===== GIFT FORM BOTTOM SHEET WIDGET =====
class _GiftFormSheet extends StatefulWidget {
  final BirthdayProvider provider;
  final BirthdayGift? existingGift;

  const _GiftFormSheet({
    required this.provider,
    this.existingGift,
  });

  @override
  State<_GiftFormSheet> createState() => _GiftFormSheetState();
}

class _GiftFormSheetState extends State<_GiftFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late final TextEditingController _linkController;
  late final TextEditingController _assignedController;
  late final TextEditingController _notesController;

  bool _isPurchased = false;
  bool _isWrapped = false;

  @override
  void initState() {
    super.initState();
    final gift = widget.existingGift;
    _nameController = TextEditingController(text: gift?.name ?? '');
    _descController = TextEditingController(text: gift?.description ?? '');
    _priceController = TextEditingController(
      text: gift != null && gift.estimatedPrice > 0 ? gift.estimatedPrice.toStringAsFixed(0) : '',
    );
    _linkController = TextEditingController(text: gift?.purchaseLink ?? '');
    _assignedController = TextEditingController(text: gift?.assignedTo ?? '');
    _notesController = TextEditingController(text: gift?.notes ?? '');
    _isPurchased = gift?.isPurchased ?? false;
    _isWrapped = gift?.isWrapped ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _linkController.dispose();
    _assignedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final activeEvent = widget.provider.activeEvent;
    if (activeEvent == null) return;

    final double price = double.tryParse(_priceController.text.trim()) ?? 0;

    if (widget.existingGift != null) {
      // Update
      final updated = widget.existingGift!
        ..name = _nameController.text.trim()
        ..description = _descController.text.trim()
        ..estimatedPrice = price
        ..purchaseLink = _linkController.text.trim()
        ..assignedTo = _assignedController.text.trim()
        ..notes = _notesController.text.trim()
        ..isPurchased = _isPurchased
        ..isWrapped = _isWrapped;
      await widget.provider.updateGift(updated);
    } else {
      // Create
      final newGift = BirthdayGift(
        id: 'gift_${DateTime.now().millisecondsSinceEpoch}',
        eventId: activeEvent.id,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        estimatedPrice: price,
        purchaseLink: _linkController.text.trim(),
        assignedTo: _assignedController.text.trim(),
        notes: _notesController.text.trim(),
        isPurchased: _isPurchased,
        isWrapped: _isWrapped,
      );
      await widget.provider.addGift(newGift);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingGift != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: BirthdayTheme.softWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: BirthdayTheme.subtleBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sheet Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Wishlist Gift' : 'Add Gift Idea',
                      style: BirthdayTheme.heading3,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: BirthdayTheme.deepCocoa),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name
                TextFormField(
                  controller: _nameController,
                  style: BirthdayTheme.body,
                  decoration: BirthdayTheme.inputDecoration(
                    'Gift Name *',
                    hint: 'e.g., Polaroid Instant Camera, Lego Set',
                    icon: Icons.card_giftcard_rounded,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please provide a gift name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Description
                TextFormField(
                  controller: _descController,
                  style: BirthdayTheme.body,
                  decoration: BirthdayTheme.inputDecoration(
                    'Description',
                    hint: 'Color, model, size or specifications...',
                    icon: Icons.description_outlined,
                  ),
                ),
                const SizedBox(height: 14),

                // Estimated Price & Assigned to in a Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: BirthdayTheme.body,
                        decoration: BirthdayTheme.inputDecoration(
                          'Estimated Price (৳)',
                          hint: '3500',
                          icon: Icons.currency_exchange_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _assignedController,
                        style: BirthdayTheme.body,
                        decoration: BirthdayTheme.inputDecoration(
                          'Assigned To',
                          hint: 'Friend, Mom, Uncle',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Purchase Link
                TextFormField(
                  controller: _linkController,
                  style: BirthdayTheme.body,
                  keyboardType: TextInputType.url,
                  decoration: BirthdayTheme.inputDecoration(
                    'Purchase / Product URL',
                    hint: 'https://...',
                    icon: Icons.link_rounded,
                  ),
                ),
                const SizedBox(height: 14),

                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  style: BirthdayTheme.body,
                  decoration: BirthdayTheme.inputDecoration(
                    'Additional Notes',
                    hint: 'Where to find, coupon code, secret surprise...',
                    icon: Icons.edit_note_rounded,
                  ),
                ),
                const SizedBox(height: 16),

                // Toggles for isPurchased and isWrapped
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: BirthdayTheme.warmIvory,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BirthdayTheme.subtleBorder),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Purchased / Bought', style: BirthdayTheme.body),
                        subtitle: Text('Mark if the gift has already been acquired', style: BirthdayTheme.bodySmall),
                        value: _isPurchased,
                        activeThumbColor: BirthdayTheme.successGreen,
                        onChanged: (val) {
                          setState(() => _isPurchased = val);
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Gift Wrapped', style: BirthdayTheme.body),
                        subtitle: Text('Mark if ready in decorative wrapper or box', style: BirthdayTheme.bodySmall),
                        value: _isWrapped,
                        activeThumbColor: BirthdayTheme.mutedGold,
                        onChanged: (val) {
                          setState(() => _isWrapped = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: BirthdayTheme.primaryButton,
                    onPressed: _save,
                    child: Text(
                      isEditing ? 'Save Changes' : 'Add to Wishlist',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
