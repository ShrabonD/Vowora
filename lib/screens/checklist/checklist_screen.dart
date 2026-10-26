import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/task_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/guest_gate_dialog.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  void _showAddTaskModal(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isGuest) {
      GuestGateDialog.show(
        context,
        onCreateAccount: () => Navigator.pushNamed(context, '/signup'),
      );
      return;
    }

    final titleController = TextEditingController();
    final categoryController = TextEditingController(text: 'General');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1917),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Planning Task',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Category (e.g. Venue, Decor, Beauty)',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isNotEmpty) {
                      final task = TaskItem(
                        id: 't_${DateTime.now().millisecondsSinceEpoch}',
                        title: title,
                        category: categoryController.text.trim().isEmpty ? 'General' : categoryController.text.trim(),
                        dueDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      Provider.of<WeddingProvider>(context, listen: false).addTask(task);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VoworaColors.champagneGold,
                    foregroundColor: const Color(0xFF141210),
                  ),
                  child: Text(
                    'Add Task',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weddingProvider = Provider.of<WeddingProvider>(context);
    final tasks = weddingProvider.tasks;
    final pct = weddingProvider.taskCompletionPercentage;

    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Wedding Checklist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_rounded),
            onPressed: () => _showAddTaskModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1917),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Checklist Progress',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(pct * 100).toStringAsFixed(0)}% Completed',
                        style: GoogleFonts.plusJakartaSans(
                          color: VoworaColors.champagneGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      color: VoworaColors.champagneGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${weddingProvider.completedTasksCount} of ${weddingProvider.totalTasksCount} tasks completed',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tasks List
            Expanded(
              child: tasks.isEmpty
                  ? VoworaEmptyState(
                      title: 'No tasks in checklist ♡',
                      description: 'Keep your wedding on track by adding your to-do items.',
                      buttonText: 'Add First Task',
                      onButtonPressed: () => _showAddTaskModal(context),
                    )
                  : ListView.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: task.isCompleted,
                                activeColor: VoworaColors.champagneGold,
                                checkColor: const Color(0xFF141210),
                                onChanged: (val) {
                                  weddingProvider.toggleTaskCompletion(task.id);
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: task.isCompleted
                                            ? Colors.grey
                                            : VoworaColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${task.category} • Due: ${DateFormat('MMM dd').format(task.dueDate)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: VoworaColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                                onPressed: () {
                                  weddingProvider.deleteTask(task.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: VoworaColors.champagneGold,
        foregroundColor: const Color(0xFF141210),
        onPressed: () => _showAddTaskModal(context),
        icon: const Icon(Icons.add),
        label: Text(
          'Add Task',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
