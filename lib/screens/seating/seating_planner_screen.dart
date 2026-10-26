import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/seating_table.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/guest_gate_dialog.dart';

class SeatingPlannerScreen extends StatefulWidget {
  const SeatingPlannerScreen({super.key});

  @override
  State<SeatingPlannerScreen> createState() => _SeatingPlannerScreenState();
}

class _SeatingPlannerScreenState extends State<SeatingPlannerScreen> {
  void _showAddTableModal(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isGuest) {
      GuestGateDialog.show(
        context,
        onCreateAccount: () => Navigator.pushNamed(context, '/signup'),
      );
      return;
    }

    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '8');

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
                'Add Seating Table',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Table Name (e.g. Table 1 - Royal Family)',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Seat Capacity',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final cap = int.tryParse(capacityController.text.trim()) ?? 8;
                    if (name.isNotEmpty) {
                      final table = SeatingTable(
                        id: 'st_${DateTime.now().millisecondsSinceEpoch}',
                        tableName: name,
                        capacity: cap,
                        guestIds: [],
                      );
                      Provider.of<WeddingProvider>(context, listen: false).addSeatingTable(table);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VoworaColors.champagneGold,
                    foregroundColor: const Color(0xFF141210),
                  ),
                  child: Text(
                    'Add Table',
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
    final tables = weddingProvider.seatingTables;
    final guests = weddingProvider.guests;

    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Seating Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_restaurant_outlined),
            onPressed: () => _showAddTableModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reception Tables (${tables.length})',
              style: GoogleFonts.playfairDisplay(
                color: VoworaColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: tables.isEmpty
                  ? VoworaEmptyState(
                      title: 'No tables set up yet ♡',
                      description: 'Assign your family and friends to ballroom tables.',
                      buttonText: 'Add First Table',
                      onButtonPressed: () => _showAddTableModal(context),
                    )
                  : ListView.separated(
                      itemCount: tables.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final table = tables[index];
                        final assignedGuests =
                            guests.where((g) => table.guestIds.contains(g.id)).toList();

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.table_restaurant_rounded,
                                        color: VoworaColors.champagneGold,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        table.tableName,
                                        style: GoogleFonts.playfairDisplay(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: VoworaColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: table.isFull
                                          ? VoworaColors.warning.withValues(alpha: 0.15)
                                          : VoworaColors.success.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${table.assignedCount}/${table.capacity} Seats',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: table.isFull ? VoworaColors.warning : VoworaColors.success,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (assignedGuests.isEmpty)
                                Text(
                                  'No guests assigned to this table yet.',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: VoworaColors.textSecondary,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              else
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: assignedGuests.map((g) {
                                    return Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: VoworaColors.champagneGold,
                                        child: Text(
                                          g.name[0],
                                          style: const TextStyle(fontSize: 10, color: Colors.black),
                                        ),
                                      ),
                                      label: Text(
                                        g.name,
                                        style: GoogleFonts.plusJakartaSans(fontSize: 11),
                                      ),
                                      backgroundColor: VoworaColors.ivoryCream,
                                    );
                                  }).toList(),
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
        onPressed: () => _showAddTableModal(context),
        icon: const Icon(Icons.add),
        label: Text(
          'Add Table',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
