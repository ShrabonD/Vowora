import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/vendor.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/guest_gate_dialog.dart';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  String _selectedStatus = 'All';

  void _showAddVendorModal(BuildContext context, [Vendor? existingVendor]) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isGuest) {
      GuestGateDialog.show(
        context,
        onCreateAccount: () => Navigator.pushNamed(context, '/signup'),
      );
      return;
    }

    final nameController = TextEditingController(text: existingVendor?.name);
    final phoneController = TextEditingController(text: existingVendor?.phone);
    final emailController = TextEditingController(text: existingVendor?.email);
    final priceController = TextEditingController(text: existingVendor?.price.toString());
    final notesController = TextEditingController(text: existingVendor?.notes);
    String selectedCategory = existingVendor?.category ?? VoworaConstants.vendorCategories.first;
    String selectedStatus = existingVendor?.status ?? VoworaConstants.vendorStatuses.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1917),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existingVendor == null ? 'Add Vendor' : 'Edit Vendor',
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
                        labelText: 'Vendor Name',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            dropdownColor: const Color(0xFF1C1917),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'Category'),
                            items: VoworaConstants.vendorCategories
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedCategory = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedStatus,
                            dropdownColor: const Color(0xFF1C1917),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: VoworaConstants.vendorStatuses
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedStatus = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'Phone'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'Price (\$)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Email Address'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: 'Notes / Package details'),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          if (name.isNotEmpty) {
                            final vendor = Vendor(
                              id: existingVendor?.id ?? 'v_${DateTime.now().millisecondsSinceEpoch}',
                              name: name,
                              category: selectedCategory,
                              status: selectedStatus,
                              phone: phoneController.text.trim(),
                              email: emailController.text.trim(),
                              price: double.tryParse(priceController.text.trim()) ?? 0.0,
                              notes: notesController.text.trim(),
                            );
                            final wp = Provider.of<WeddingProvider>(context, listen: false);
                            if (existingVendor == null) {
                              wp.addVendor(vendor);
                            } else {
                              wp.editVendor(vendor);
                            }
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VoworaColors.champagneGold,
                          foregroundColor: const Color(0xFF141210),
                        ),
                        child: Text(
                          existingVendor == null ? 'Add Vendor' : 'Save Changes',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weddingProvider = Provider.of<WeddingProvider>(context);
    final allVendors = weddingProvider.vendors;

    final filteredVendors = _selectedStatus == 'All'
        ? allVendors
        : allVendors.where((v) => v.status == _selectedStatus).toList();

    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Vendor Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_outlined),
            onPressed: () => _showAddVendorModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Booked', 'Shortlisted', 'Contacted', 'Completed'].map((status) {
                  final isSelected = _selectedStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedStatus = status);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? VoworaColors.champagneGold
                              : const Color(0xFFEFECE6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? VoworaColors.champagneGold : const Color(0xFFD0C9BD),
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected ? const Color(0xFF141210) : VoworaColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredVendors.isEmpty
                  ? VoworaEmptyState(
                      title: 'No vendors added yet ♡',
                      description: 'Track venue, photographers, caterers, and decorators easily.',
                      buttonText: 'Add First Vendor',
                      onButtonPressed: () => _showAddVendorModal(context),
                    )
                  : ListView.separated(
                      itemCount: filteredVendors.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final vendor = filteredVendors[index];
                        final statusColor = vendor.status == 'Booked'
                            ? VoworaColors.success
                            : (vendor.status == 'Contacted' ? VoworaColors.warning : VoworaColors.deepGold);

                        return Container(
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
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: VoworaColors.champagneGold.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.storefront_outlined, color: VoworaColors.deepGold),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vendor.name,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            vendor.category,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: VoworaColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      vendor.status,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (vendor.notes.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Text(
                                  vendor.notes,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: VoworaColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Divider(color: Colors.grey.shade200),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${vendor.price.toStringAsFixed(0)}',
                                    style: GoogleFonts.playfairDisplay(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: VoworaColors.champagneGold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                                        onPressed: () => _showAddVendorModal(context, vendor),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                                        onPressed: () {
                                          weddingProvider.deleteVendor(vendor.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
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
        onPressed: () => _showAddVendorModal(context),
        icon: const Icon(Icons.add),
        label: Text(
          'Add Vendor',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
