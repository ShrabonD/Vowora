import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'core/birthday_theme.dart';
import '../../providers/birthday_provider.dart';
import '../../models/birthday/birthday_task.dart';

class BirthdayChecklistScreen extends StatefulWidget {
  const BirthdayChecklistScreen({super.key});

  @override
  State<BirthdayChecklistScreen> createState() => _BirthdayChecklistScreenState();
}

class _BirthdayChecklistScreenState extends State<BirthdayChecklistScreen> {
  String _selectedFilter = 'All'; // All, Pending, Completed, Overdue

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
          'Smart Checklist',
          style: BirthdayTheme.heading3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_check_rounded, color: BirthdayTheme.mutedGold),
            tooltip: 'Checklist Summary',
            onPressed: () {
              _showQuickSummary(context);
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

          final tasks = provider.tasks;
          final completedCount = provider.totalTasksCompleted;
          final pendingCount = provider.totalTasksPending;
          final overdueCount = tasks.where((t) => t.isOverdue).length;
          final totalCount = tasks.length;
          final completionPercent = provider.taskCompletionPercent;

          // Filter logic
          List<BirthdayTask> filteredTasks = tasks.where((task) {
            switch (_selectedFilter) {
              case 'Pending':
                return !task.isCompleted;
              case 'Completed':
                return task.isCompleted;
              case 'Overdue':
                return task.isOverdue;
              case 'All':
              default:
                return true;
            }
          }).toList();

          // Sort by due date (tasks with due dates first, then no due date)
          filteredTasks.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) {
              return a.createdAt.compareTo(b.createdAt);
            }
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });

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
                        // Countdown Card
                        _buildCountdownCard(
                          personName: activeEvent.personName,
                          daysRemaining: activeEvent.daysRemaining,
                          eventDate: activeEvent.eventDate,
                          completionPercent: completionPercent,
                        ),
                        const SizedBox(height: 16),

                        // Progress Bar Card
                        _buildProgressCard(
                          completedCount: completedCount,
                          totalCount: totalCount,
                          completionPercent: completionPercent,
                        ),
                        const SizedBox(height: 16),

                        // Filter Tabs
                        _buildFilterTabs(
                          allCount: totalCount,
                          pendingCount: pendingCount,
                          completedCount: completedCount,
                          overdueCount: overdueCount,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Task List or Empty State
                if (filteredTasks.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context, provider, activeEvent.id),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = filteredTasks[index];
                          return _buildTaskItem(context, task, provider);
                        },
                        childCount: filteredTasks.length,
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
            _showAddEditTaskSheet(context, provider: provider);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select or create an event first.')),
            );
          }
        },
        icon: const Icon(Icons.add_task_rounded, size: 20),
        label: Text('Add Task', style: BirthdayTheme.buttonText.copyWith(color: BirthdayTheme.softWhite, fontSize: 14)),
      ),
    );
  }

  // ===== COUNTDOWN CARD =====
  Widget _buildCountdownCard({
    required String personName,
    required int daysRemaining,
    required DateTime eventDate,
    required double completionPercent,
  }) {
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(eventDate);
    final daysText = daysRemaining == 0
        ? 'Today is the day!'
        : daysRemaining == 1
            ? '1 day to go!'
            : '$daysRemaining days to go!';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BirthdayTheme.deepCocoa,
            BirthdayTheme.deepCocoa.withValues(alpha: 0.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: BirthdayTheme.deepCocoa.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: BirthdayTheme.mutedGold.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: BirthdayTheme.mutedGold.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    "$personName's Celebration",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: BirthdayTheme.champagneBeige,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  daysText,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: BirthdayTheme.softWhite,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.event_available_rounded,
                      color: BirthdayTheme.mutedGold,
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: BirthdayTheme.champagneBeige.withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Circular progress indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: CircularProgressIndicator(
                  value: completionPercent / 100,
                  strokeWidth: 7,
                  backgroundColor: BirthdayTheme.champagneBeige.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(BirthdayTheme.mutedGold),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${completionPercent.toStringAsFixed(0)}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: BirthdayTheme.softWhite,
                    ),
                  ),
                  Text(
                    'Done',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: BirthdayTheme.champagneBeige,
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

  // ===== PROGRESS BAR CARD =====
  Widget _buildProgressCard({
    required int completedCount,
    required int totalCount,
    required double completionPercent,
  }) {
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
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: BirthdayTheme.mutedGold,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Overall Progress',
                    style: BirthdayTheme.heading3.copyWith(fontSize: 15),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BirthdayTheme.champagneBeige.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completedCount of $totalCount tasks completed',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: BirthdayTheme.deepCocoa,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalCount == 0 ? 0 : (completedCount / totalCount),
              minHeight: 10,
              backgroundColor: BirthdayTheme.champagneBeige.withValues(alpha: 0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(BirthdayTheme.mutedGold),
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
    required int completedCount,
    required int overdueCount,
  }) {
    final filters = [
      {'name': 'All', 'count': allCount},
      {'name': 'Pending', 'count': pendingCount},
      {'name': 'Completed', 'count': completedCount},
      {'name': 'Overdue', 'count': overdueCount},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((filter) {
          final name = filter['name'] as String;
          final count = filter['count'] as int;
          final isSelected = _selectedFilter == name;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              showCheckmark: false,
              selected: isSelected,
              onSelected: (val) {
                if (val) {
                  setState(() => _selectedFilter = name);
                }
              },
              backgroundColor: BirthdayTheme.softWhite,
              selectedColor: BirthdayTheme.mutedGold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? BirthdayTheme.mutedGold : BirthdayTheme.subtleBorder,
                  width: 0.8,
                ),
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
          );
        }).toList(),
      ),
    );
  }

  // ===== TASK ITEM CARD =====
  Widget _buildTaskItem(
    BuildContext context,
    BirthdayTask task,
    BirthdayProvider provider,
  ) {
    Color priorityColor;
    switch (task.priority.toLowerCase()) {
      case 'high':
        priorityColor = BirthdayTheme.errorRed;
        break;
      case 'medium':
        priorityColor = BirthdayTheme.alertOrange;
        break;
      case 'low':
      default:
        priorityColor = BirthdayTheme.successGreen;
        break;
    }

    final isOverdue = task.isOverdue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(task.id),
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
              Icon(Icons.delete_sweep_rounded, color: BirthdayTheme.softWhite, size: 24),
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
              title: Text('Delete Task?', style: BirthdayTheme.heading3),
              content: Text(
                'Are you sure you want to delete "${task.title}"?',
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
          provider.deleteTask(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted "${task.title}"'),
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
              _showAddEditTaskSheet(context, provider: provider, existingTask: task);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: task.isCompleted,
                      activeColor: BirthdayTheme.mutedGold,
                      checkColor: BirthdayTheme.softWhite,
                      side: BorderSide(
                        color: BirthdayTheme.deepCocoa.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onChanged: (_) {
                        provider.toggleTask(task.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Title & Metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: task.isCompleted
                                ? BirthdayTheme.deepCocoa.withValues(alpha: 0.4)
                                : BirthdayTheme.deepCocoa,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: BirthdayTheme.deepCocoa.withValues(alpha: 0.4),
                          ),
                        ),
                        if (task.notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.notes,
                            style: BirthdayTheme.bodySmall.copyWith(
                              color: BirthdayTheme.deepCocoa.withValues(alpha: 0.55),
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),

                        // Badges Row
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Priority Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: priorityColor.withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: priorityColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    task.priority.toUpperCase(),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: priorityColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Due Date Badge
                            if (task.dueDate != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isOverdue
                                      ? BirthdayTheme.errorRed.withValues(alpha: 0.12)
                                      : BirthdayTheme.champagneBeige.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isOverdue
                                        ? BirthdayTheme.errorRed.withValues(alpha: 0.4)
                                        : BirthdayTheme.subtleBorder,
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 11,
                                      color: isOverdue ? BirthdayTheme.errorRed : BirthdayTheme.deepCocoa.withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isOverdue
                                          ? 'Overdue • ${DateFormat('MMM d').format(task.dueDate!)}'
                                          : DateFormat('MMM d, yyyy').format(task.dueDate!),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isOverdue ? BirthdayTheme.errorRed : BirthdayTheme.deepCocoa.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Edit Chevron
                  IconButton(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: BirthdayTheme.deepCocoa.withValues(alpha: 0.4),
                      size: 20,
                    ),
                    onPressed: () {
                      _showAddEditTaskSheet(context, provider: provider, existingTask: task);
                    },
                  ),
                ],
              ),
            ),
          ),
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
                Icons.assignment_turned_in_outlined,
                size: 40,
                color: BirthdayTheme.mutedGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 'All'
                  ? 'No Tasks Added Yet'
                  : 'No $_selectedFilter Tasks Found',
              style: BirthdayTheme.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'All'
                  ? 'Get started by creating your customized checklist or load suggested birthday milestones.'
                  : 'Switch filter or create a new task to keep your celebration organized.',
              style: BirthdayTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_selectedFilter == 'All') ...[
                  OutlinedButton.icon(
                    style: BirthdayTheme.secondaryButton,
                    onPressed: () async {
                      final defaults = BirthdayTask.defaultTasks(eventId);
                      for (final t in defaults) {
                        await provider.addTask(t);
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added default birthday tasks!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: const Text('Load Defaults'),
                  ),
                  const SizedBox(width: 12),
                ],
                ElevatedButton.icon(
                  style: BirthdayTheme.primaryButton,
                  onPressed: () => _showAddEditTaskSheet(context, provider: provider),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Task'),
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
            const Icon(Icons.cake_outlined, size: 64, color: BirthdayTheme.mutedGold),
            const SizedBox(height: 16),
            Text('No Active Birthday Event', style: BirthdayTheme.heading2),
            const SizedBox(height: 8),
            Text(
              'Select an active event from the Birthday Studio dashboard to view its smart checklist.',
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

  // ===== ADD / EDIT TASK BOTTOM SHEET =====
  void _showAddEditTaskSheet(
    BuildContext context, {
    required BirthdayProvider provider,
    BirthdayTask? existingTask,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TaskFormSheet(
        provider: provider,
        existingTask: existingTask,
      ),
    );
  }

  // ===== SUMMARY MODAL =====
  void _showQuickSummary(BuildContext context) {
    final provider = Provider.of<BirthdayProvider>(context, listen: false);
    final tasks = provider.tasks;
    final total = tasks.length;
    final done = provider.totalTasksCompleted;
    final pending = provider.totalTasksPending;
    final overdue = tasks.where((t) => t.isOverdue).length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BirthdayTheme.softWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.fact_check_rounded, color: BirthdayTheme.mutedGold),
            const SizedBox(width: 8),
            Text('Checklist Summary', style: BirthdayTheme.heading3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow('Total Tasks', '$total', BirthdayTheme.deepCocoa),
            const Divider(),
            _summaryRow('Completed', '$done', BirthdayTheme.successGreen),
            _summaryRow('Pending', '$pending', BirthdayTheme.alertOrange),
            _summaryRow('Overdue', '$overdue', BirthdayTheme.errorRed),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 8,
                backgroundColor: BirthdayTheme.champagneBeige,
                valueColor: const AlwaysStoppedAnimation(BirthdayTheme.mutedGold),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: BirthdayTheme.primaryButton,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: BirthdayTheme.body),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== TASK FORM BOTTOM SHEET WIDGET =====
class _TaskFormSheet extends StatefulWidget {
  final BirthdayProvider provider;
  final BirthdayTask? existingTask;

  const _TaskFormSheet({
    required this.provider,
    this.existingTask,
  });

  @override
  State<_TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<_TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  DateTime? _selectedDueDate;
  String _priority = 'medium';

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _notesController = TextEditingController(text: task?.notes ?? '');
    _selectedDueDate = task?.dueDate;
    _priority = task?.priority ?? 'medium';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDueDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 730)),
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
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final activeEvent = widget.provider.activeEvent;
    if (activeEvent == null) return;

    if (widget.existingTask != null) {
      // Update
      final updated = widget.existingTask!
        ..title = _titleController.text.trim()
        ..dueDate = _selectedDueDate
        ..priority = _priority
        ..notes = _notesController.text.trim();
      await widget.provider.updateTask(updated);
    } else {
      // Create
      final newTask = BirthdayTask(
        id: 'task_${DateTime.now().millisecondsSinceEpoch}',
        eventId: activeEvent.id,
        title: _titleController.text.trim(),
        dueDate: _selectedDueDate,
        priority: _priority,
        notes: _notesController.text.trim(),
      );
      await widget.provider.addTask(newTask);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;

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
                      isEditing ? 'Edit Task' : 'New Birthday Task',
                      style: BirthdayTheme.heading3,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: BirthdayTheme.deepCocoa),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                TextFormField(
                  controller: _titleController,
                  style: BirthdayTheme.body,
                  decoration: BirthdayTheme.inputDecoration(
                    'Task Title *',
                    hint: 'e.g., Order themed tiered cake',
                    icon: Icons.title_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Due Date Picker
                InkWell(
                  onTap: _pickDueDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: BirthdayTheme.warmIvory,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: BirthdayTheme.subtleBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: BirthdayTheme.mutedGold, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDueDate == null
                                  ? 'Select Due Date (Optional)'
                                  : DateFormat('EEEE, MMMM d, yyyy').format(_selectedDueDate!),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: _selectedDueDate == null
                                    ? BirthdayTheme.deepCocoa.withValues(alpha: 0.4)
                                    : BirthdayTheme.deepCocoa,
                              ),
                            ),
                          ],
                        ),
                        if (_selectedDueDate != null)
                          GestureDetector(
                            onTap: () => setState(() => _selectedDueDate = null),
                            child: const Icon(Icons.clear_rounded, size: 18, color: BirthdayTheme.deepCocoa),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Priority Selection
                Text(
                  'Priority Level',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BirthdayTheme.deepCocoa.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _priorityChip('low', 'Low', BirthdayTheme.successGreen),
                    const SizedBox(width: 8),
                    _priorityChip('medium', 'Medium', BirthdayTheme.alertOrange),
                    const SizedBox(width: 8),
                    _priorityChip('high', 'High', BirthdayTheme.errorRed),
                  ],
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  style: BirthdayTheme.body,
                  decoration: BirthdayTheme.inputDecoration(
                    'Notes / Details',
                    hint: 'Add reminders, vendor contacts, or instructions...',
                    icon: Icons.notes_rounded,
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
                      isEditing ? 'Save Changes' : 'Create Task',
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

  Widget _priorityChip(String key, String label, Color color) {
    final isSelected = _priority == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color : BirthdayTheme.warmIvory,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : BirthdayTheme.subtleBorder,
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? BirthdayTheme.softWhite : BirthdayTheme.deepCocoa,
            ),
          ),
        ),
      ),
    );
  }
}
