import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/birthday_theme.dart';
import '../../providers/birthday_provider.dart';
import '../../models/birthday/birthday_timeline_item.dart';

class BirthdayTimelineScreen extends StatefulWidget {
  const BirthdayTimelineScreen({super.key});

  @override
  State<BirthdayTimelineScreen> createState() => _BirthdayTimelineScreenState();
}

class _BirthdayTimelineScreenState extends State<BirthdayTimelineScreen> {
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
          'Party Schedule',
          style: BirthdayTheme.heading3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_rounded, color: BirthdayTheme.mutedGold),
            tooltip: 'Add Timeline Event',
            onPressed: () {
              final provider = Provider.of<BirthdayProvider>(context, listen: false);
              if (provider.activeEvent != null) {
                _showAddEditTimelineSheet(context, provider: provider);
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

          final items = List<BirthdayTimelineItem>.from(provider.timeline)
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

          final totalCount = items.length;
          final completedCount = items.where((i) => i.isCompleted).length;

          return RefreshIndicator(
            color: BirthdayTheme.mutedGold,
            backgroundColor: BirthdayTheme.softWhite,
            onRefresh: () => provider.loadEventData(activeEvent.id),
            child: items.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: _buildEmptyState(context, provider, activeEvent.id),
                    ),
                  )
                : Column(
                    children: [
                      // Header Progress & Quick Hint Card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: _buildTimelineHeader(
                          completedCount: completedCount,
                          totalCount: totalCount,
                        ),
                      ),

                      // Reorderable Vertical Timeline
                      Expanded(
                        child: ReorderableListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                          itemCount: items.length,
                          onReorder: (oldIndex, newIndex) async {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final item = items.removeAt(oldIndex);
                            items.insert(newIndex, item);

                            // Update sort order for all affected
                            for (int i = 0; i < items.length; i++) {
                              if (items[i].sortOrder != i) {
                                items[i].sortOrder = i;
                                await provider.updateTimelineItem(items[i]);
                              }
                            }
                          },
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isFirst = index == 0;
                            final isLast = index == items.length - 1;

                            return _buildTimelineRow(
                              key: ValueKey(item.id),
                              context: context,
                              item: item,
                              index: index,
                              isFirst: isFirst,
                              isLast: isLast,
                              provider: provider,
                            );
                          },
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
            _showAddEditTimelineSheet(context, provider: provider);
          } else {
            _showNoEventSnack(context);
          }
        },
        icon: const Icon(Icons.add_alarm_rounded, size: 20),
        label: Text('Add Milestone', style: BirthdayTheme.buttonText.copyWith(color: BirthdayTheme.softWhite, fontSize: 14)),
      ),
    );
  }

  // ===== HEADER PROGRESS CARD =====
  Widget _buildTimelineHeader({
    required int completedCount,
    required int totalCount,
  }) {
    final double percent = totalCount == 0 ? 0 : (completedCount / totalCount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BirthdayTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: BirthdayTheme.champagneBeige.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.access_time_filled_rounded, color: BirthdayTheme.mutedGold, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text('Run of Show', style: BirthdayTheme.heading3.copyWith(fontSize: 16)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BirthdayTheme.champagneBeige.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount / $totalCount Passed',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: BirthdayTheme.deepCocoa,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: BirthdayTheme.champagneBeige.withValues(alpha: 0.5),
              valueColor: const AlwaysStoppedAnimation(BirthdayTheme.mutedGold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.touch_app_rounded, size: 14, color: BirthdayTheme.mutedGold),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Tap to edit • Long-press card to toggle complete • Drag handle to reorder',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== VERTICAL TIMELINE ROW =====
  Widget _buildTimelineRow({
    required Key key,
    required BuildContext context,
    required BirthdayTimelineItem item,
    required int index,
    required bool isFirst,
    required bool isLast,
    required BirthdayProvider provider,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Time Text
            SizedBox(
              width: 72,
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  item.time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: item.isCompleted
                        ? BirthdayTheme.deepCocoa.withValues(alpha: 0.4)
                        : BirthdayTheme.mutedGold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Center: Dot and Connecting Lines
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  // Top Line
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 2,
                      color: isFirst
                          ? Colors.transparent
                          : BirthdayTheme.mutedGold.withValues(alpha: 0.35),
                    ),
                  ),

                  // Circle Dot
                  GestureDetector(
                    onTap: () {
                      item.isCompleted = !item.isCompleted;
                      provider.updateTimelineItem(item);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: item.isCompleted ? BirthdayTheme.mutedGold : BirthdayTheme.softWhite,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BirthdayTheme.mutedGold,
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: BirthdayTheme.mutedGold.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: item.isCompleted
                          ? const Center(
                              child: Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: BirthdayTheme.softWhite,
                              ),
                            )
                          : Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: BirthdayTheme.roseBeige,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                    ),
                  ),

                  // Bottom Line
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 2,
                      color: isLast
                          ? Colors.transparent
                          : BirthdayTheme.mutedGold.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Right: Content Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Dismissible(
                  key: Key('dismiss_${item.id}'),
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
                        SizedBox(width: 4),
                        Text(
                          'Delete',
                          style: TextStyle(color: BirthdayTheme.softWhite, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  confirmDismiss: (dir) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: BirthdayTheme.softWhite,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Text('Delete Schedule Item?', style: BirthdayTheme.heading3),
                        content: Text('Remove "${item.title}" from the event timeline?', style: BirthdayTheme.body),
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
                    provider.deleteTimelineItem(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed "${item.title}"'),
                        backgroundColor: BirthdayTheme.deepCocoa,
                      ),
                    );
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      _showAddEditTimelineSheet(context, provider: provider, existingItem: item);
                    },
                    onLongPress: () {
                      item.isCompleted = !item.isCompleted;
                      provider.updateTimelineItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 1200),
                          content: Text(
                            item.isCompleted ? 'Marked as completed!' : 'Marked as pending',
                          ),
                          backgroundColor: BirthdayTheme.deepCocoa,
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: item.isCompleted
                            ? BirthdayTheme.softWhite.withValues(alpha: 0.7)
                            : BirthdayTheme.softWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: item.isCompleted
                              ? BirthdayTheme.subtleBorder.withValues(alpha: 0.5)
                              : BirthdayTheme.subtleBorder,
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: BirthdayTheme.deepCocoa.withValues(alpha: item.isCompleted ? 0.02 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: item.isCompleted
                                              ? BirthdayTheme.deepCocoa.withValues(alpha: 0.45)
                                              : BirthdayTheme.deepCocoa,
                                          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                    ),
                                    if (item.isCompleted) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: BirthdayTheme.successGreen.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Done',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: BirthdayTheme.successGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (item.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: BirthdayTheme.bodySmall.copyWith(
                                      color: item.isCompleted
                                          ? BirthdayTheme.deepCocoa.withValues(alpha: 0.4)
                                          : BirthdayTheme.deepCocoa.withValues(alpha: 0.7),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Reorder Drag Handle
                          ReorderableDragStartListener(
                            index: index,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.drag_indicator_rounded,
                                color: BirthdayTheme.deepCocoa.withValues(alpha: 0.3),
                                size: 20,
                              ),
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
    );
  }

  // ===== EMPTY STATE =====
  Widget _buildEmptyState(
    BuildContext context,
    BirthdayProvider provider,
    String eventId,
  ) {
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
                Icons.schedule_rounded,
                size: 40,
                color: BirthdayTheme.mutedGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Schedule Items Yet',
              style: BirthdayTheme.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Structure the flow of your party from guest welcoming to the cake cutting highlight and final farewell.',
              style: BirthdayTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  style: BirthdayTheme.secondaryButton,
                  onPressed: () async {
                    final defaults = BirthdayTimelineItem.defaultTimeline(eventId);
                    for (final item in defaults) {
                      await provider.addTimelineItem(item);
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Loaded default party schedule!')),
                      );
                    }
                  },
                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                  label: const Text('Load Suggested'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: BirthdayTheme.primaryButton,
                  onPressed: () => _showAddEditTimelineSheet(context, provider: provider),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Milestone'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== NO ACTIVE EVENT STATE =====
  Widget _buildNoActiveEventState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.alarm_off_rounded, size: 64, color: BirthdayTheme.mutedGold),
            const SizedBox(height: 16),
            Text('No Active Event Selected', style: BirthdayTheme.heading2),
            const SizedBox(height: 8),
            Text(
              'Select a birthday celebration in the Birthday Studio to plan its party schedule.',
              style: BirthdayTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: BirthdayTheme.primaryButton,
              onPressed: () => Navigator.maybePop(context),
              child: const Text('Back to Birthday Studio'),
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

  // ===== ADD / EDIT BOTTOM SHEET =====
  void _showAddEditTimelineSheet(
    BuildContext context, {
    required BirthdayProvider provider,
    BirthdayTimelineItem? existingItem,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TimelineFormSheet(
        provider: provider,
        existingItem: existingItem,
      ),
    );
  }
}

// ===== TIMELINE FORM BOTTOM SHEET WIDGET =====
class _TimelineFormSheet extends StatefulWidget {
  final BirthdayProvider provider;
  final BirthdayTimelineItem? existingItem;

  const _TimelineFormSheet({
    required this.provider,
    this.existingItem,
  });

  @override
  State<_TimelineFormSheet> createState() => _TimelineFormSheetState();
}

class _TimelineFormSheetState extends State<_TimelineFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _timeController;
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    _timeController = TextEditingController(text: item?.time ?? '06:00 PM');
    _titleController = TextEditingController(text: item?.title ?? '');
    _descController = TextEditingController(text: item?.description ?? '');
    _isCompleted = item?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _timeController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: BirthdayTheme.mutedGold,
              onPrimary: BirthdayTheme.softWhite,
              surface: BirthdayTheme.softWhite,
              onSurface: BirthdayTheme.deepCocoa,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      setState(() {
        _timeController.text = '${hour.toString().padLeft(2, '0')}:$minute $period';
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final activeEvent = widget.provider.activeEvent;
    if (activeEvent == null) return;

    if (widget.existingItem != null) {
      // Update
      final updated = widget.existingItem!
        ..time = _timeController.text.trim()
        ..title = _titleController.text.trim()
        ..description = _descController.text.trim()
        ..isCompleted = _isCompleted;
      await widget.provider.updateTimelineItem(updated);
    } else {
      // Create
      final newItem = BirthdayTimelineItem(
        id: 'tl_${DateTime.now().millisecondsSinceEpoch}',
        eventId: activeEvent.id,
        time: _timeController.text.trim(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        isCompleted: _isCompleted,
        sortOrder: widget.provider.timeline.length,
      );
      await widget.provider.addTimelineItem(newItem);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;

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
                      isEditing ? 'Edit Schedule Item' : 'New Timeline Milestone',
                      style: BirthdayTheme.heading3,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: BirthdayTheme.deepCocoa),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Time picker field
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timeController,
                        style: BirthdayTheme.body,
                        decoration: BirthdayTheme.inputDecoration(
                          'Scheduled Time *',
                          hint: '06:00 PM',
                          icon: Icons.access_time_rounded,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Enter milestone time';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.schedule_rounded, color: BirthdayTheme.mutedGold, size: 28),
                      tooltip: 'Select Time',
                      onPressed: _pickTime,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Title
                TextFormField(
                  controller: _titleController,
                  style: BirthdayTheme.body,
                  decoration: BirthdayTheme.inputDecoration(
                    'Milestone Title *',
                    hint: 'e.g., Cake Cutting Ceremony, Magic Show',
                    icon: Icons.celebration_rounded,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Description
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  style: BirthdayTheme.body,
                  decoration: BirthdayTheme.inputDecoration(
                    'Description / Details',
                    hint: 'Key participants, announcements, background music cue...',
                    icon: Icons.notes_rounded,
                  ),
                ),
                const SizedBox(height: 16),

                // Completed toggle
                Container(
                  decoration: BoxDecoration(
                    color: BirthdayTheme.warmIvory,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BirthdayTheme.subtleBorder),
                  ),
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    title: Text('Completed Event', style: BirthdayTheme.body),
                    subtitle: Text('Mark if this moment has already taken place', style: BirthdayTheme.bodySmall),
                    value: _isCompleted,
                    activeThumbColor: BirthdayTheme.mutedGold,
                    onChanged: (val) {
                      setState(() => _isCompleted = val);
                    },
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
                      isEditing ? 'Save Changes' : 'Add to Schedule',
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
