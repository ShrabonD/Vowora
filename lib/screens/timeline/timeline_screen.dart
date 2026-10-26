import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/timeline_event.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/guest_gate_dialog.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  void _showAddEventModal(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isGuest) {
      GuestGateDialog.show(
        context,
        onCreateAccount: () => Navigator.pushNamed(context, '/signup'),
      );
      return;
    }

    final titleController = TextEditingController();
    final startController = TextEditingController(text: '06:00 PM');
    final endController = TextEditingController(text: '10:00 PM');
    final locationController = TextEditingController();

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
                'Add Event to Itinerary',
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
                  labelText: 'Event Name (e.g. Mehendi, Ceremony)',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: endController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Location / Hall',
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
                      final event = TimelineEvent(
                        id: 'te_${DateTime.now().millisecondsSinceEpoch}',
                        title: title,
                        date: DateTime.now().add(const Duration(days: 120)),
                        startTime: startController.text.trim(),
                        endTime: endController.text.trim(),
                        location: locationController.text.trim(),
                      );
                      Provider.of<WeddingProvider>(context, listen: false).addTimelineEvent(event);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VoworaColors.champagneGold,
                    foregroundColor: const Color(0xFF141210),
                  ),
                  child: Text(
                    'Save Event',
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
    final events = weddingProvider.timelineEvents;

    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Wedding Timeline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            onPressed: () => _showAddEventModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: events.isEmpty
            ? VoworaEmptyState(
                title: 'No timeline events yet ♡',
                description: 'Organize your engagement, mehendi, vows, and reception schedule.',
                buttonText: 'Add First Event',
                onButtonPressed: () => _showAddEventModal(context),
              )
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final formattedDate = DateFormat('EEEE, MMM dd, yyyy').format(event.date);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline indicator column
                      Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: VoworaColors.champagneGold,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF141210),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (index < events.length - 1)
                            Container(
                              width: 2,
                              height: 90,
                              color: VoworaColors.champagneGold.withValues(alpha: 0.4),
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Event card
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    event.title,
                                    style: GoogleFonts.playfairDisplay(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: VoworaColors.textPrimary,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                                    onPressed: () {
                                      weddingProvider.deleteTimelineEvent(event.id);
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                formattedDate,
                                style: GoogleFonts.plusJakartaSans(
                                  color: VoworaColors.champagneGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${event.startTime} - ${event.endTime}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: VoworaColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      event.location,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: VoworaColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (event.notes.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  event.notes,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: VoworaColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: VoworaColors.champagneGold,
        foregroundColor: const Color(0xFF141210),
        onPressed: () => _showAddEventModal(context),
        icon: const Icon(Icons.add),
        label: Text(
          'Add Event',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
