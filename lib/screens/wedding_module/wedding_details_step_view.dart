import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_booking_model.dart';
import '../../providers/wedding_wizard_provider.dart';
import '../../widgets/vowora_text_field.dart';

class WeddingDetailsStepView extends StatefulWidget {
  const WeddingDetailsStepView({super.key});

  @override
  State<WeddingDetailsStepView> createState() => _WeddingDetailsStepViewState();
}

class _WeddingDetailsStepViewState extends State<WeddingDetailsStepView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _brideNameCtrl;
  late TextEditingController _groomNameCtrl;
  late TextEditingController _bridePhoneCtrl;
  late TextEditingController _groomPhoneCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _timeCtrl;
  late TextEditingController _guestsCountCtrl;
  late TextEditingController _descCtrl;

  late DateTime _selectedDate;
  late WeddingType _selectedType;

  @override
  void initState() {
    super.initState();
    final booking =
        Provider.of<WeddingWizardProvider>(context, listen: false).booking;

    _brideNameCtrl = TextEditingController(text: booking.brideName);
    _groomNameCtrl = TextEditingController(text: booking.groomName);
    _bridePhoneCtrl = TextEditingController(text: booking.bridePhone);
    _groomPhoneCtrl = TextEditingController(text: booking.groomPhone);
    _selectedDate = booking.weddingDate;
    _dateCtrl = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(_selectedDate));
    _timeCtrl = TextEditingController(text: booking.weddingTime);
    _guestsCountCtrl =
        TextEditingController(text: booking.expectedGuestCount.toString());
    _descCtrl = TextEditingController(text: booking.description);
    _selectedType = booking.weddingType;
  }

  @override
  void dispose() {
    _brideNameCtrl.dispose();
    _groomNameCtrl.dispose();
    _bridePhoneCtrl.dispose();
    _groomPhoneCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _guestsCountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: VoworaColors.champagneGold,
            surface: Color(0xFF1E1A17),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<WeddingWizardProvider>(context, listen: false);
    provider.updateWeddingDetails(
      brideName: _brideNameCtrl.text.trim(),
      groomName: _groomNameCtrl.text.trim(),
      bridePhone: _bridePhoneCtrl.text.trim(),
      groomPhone: _groomPhoneCtrl.text.trim(),
      weddingDate: _selectedDate,
      weddingTime: _timeCtrl.text.trim(),
      weddingType: _selectedType,
      expectedGuestCount: int.tryParse(_guestsCountCtrl.text.trim()) ?? 300,
      description: _descCtrl.text.trim(),
    );

    provider.setStep(2); // Continue to Venue Selection
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1: Wedding Details 💍',
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tell us about the couple & wedding schedule.',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),

            // Couple Info Section
            Text(
              'COUPLE INFORMATION',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: VoworaTextField(
                    controller: _brideNameCtrl,
                    hintText: 'Bride Name',
                    labelText: 'BRIDE NAME',
                    prefixIcon: Icons.female_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter bride name' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VoworaTextField(
                    controller: _groomNameCtrl,
                    hintText: 'Groom Name',
                    labelText: 'GROOM NAME',
                    prefixIcon: Icons.male_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter groom name' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: VoworaTextField(
                    controller: _bridePhoneCtrl,
                    hintText: 'Bride Phone',
                    labelText: 'BRIDE PHONE',
                    prefixIcon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VoworaTextField(
                    controller: _groomPhoneCtrl,
                    hintText: 'Groom Phone',
                    labelText: 'GROOM PHONE',
                    prefixIcon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Wedding Info Section
            Text(
              'WEDDING INFORMATION',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: VoworaTextField(
                    controller: _dateCtrl,
                    hintText: 'Select Date',
                    labelText: 'WEDDING DATE',
                    prefixIcon: Icons.calendar_today_rounded,
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VoworaTextField(
                    controller: _timeCtrl,
                    hintText: 'e.g. 06:00 PM',
                    labelText: 'WEDDING TIME',
                    prefixIcon: Icons.access_time_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: VoworaTextField(
                    controller: _guestsCountCtrl,
                    hintText: '300',
                    labelText: 'EXPECTED GUESTS',
                    prefixIcon: Icons.groups_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WEDDING TYPE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: VoworaColors.champagneGold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<WeddingType>(
                            value: _selectedType,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1E1A17),
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.white, fontSize: 13),
                            items: WeddingType.values
                                .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t.name.toUpperCase()),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedType = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            VoworaTextField(
              controller: _descCtrl,
              hintText: 'Describe your wedding vision...',
              labelText: 'WEDDING DESCRIPTION',
              prefixIcon: Icons.notes_rounded,
            ),
            const SizedBox(height: 20),

            // Photos Upload Gallery Section
            Text(
              'PHOTOS (FROM PHONE GALLERY)',
              style: GoogleFonts.plusJakartaSans(
                color: VoworaColors.champagneGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),

            Consumer<WeddingWizardProvider>(
              builder: (context, provider, child) {
                final booking = provider.booking;
                return Row(
                  children: [
                    _buildPhotoUploadBox(
                      label: 'Bride Photo',
                      icon: Icons.female_rounded,
                      pathOrUrl: booking.bridePhotoUrl,
                      onTap: provider.pickBridePhoto,
                    ),
                    const SizedBox(width: 10),
                    _buildPhotoUploadBox(
                      label: 'Groom Photo',
                      icon: Icons.male_rounded,
                      pathOrUrl: booking.groomPhotoUrl,
                      onTap: provider.pickGroomPhoto,
                    ),
                    const SizedBox(width: 10),
                    _buildPhotoUploadBox(
                      label: 'Cover Photo',
                      icon: Icons.add_photo_alternate_rounded,
                      pathOrUrl: booking.coverPhotoUrl,
                      onTap: provider.pickCoverPhoto,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),

            // Save & Continue Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: VoworaColors.champagneGold,
                  foregroundColor: const Color(0xFF141210),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'Save & Continue to Venue',
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
    );
  }

  Widget _buildPhotoUploadBox({
    required String label,
    required IconData icon,
    required String? pathOrUrl,
    required VoidCallback onTap,
  }) {
    final hasImage = pathOrUrl != null && pathOrUrl.isNotEmpty;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasImage ? VoworaColors.champagneGold : Colors.white.withValues(alpha: 0.2),
              width: hasImage ? 2.0 : 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: hasImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      pathOrUrl.startsWith('http')
                          ? Image.network(pathOrUrl, fit: BoxFit.cover)
                          : Image.file(File(pathOrUrl), fit: BoxFit.cover),
                      Container(
                        color: Colors.black38,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit_rounded, color: VoworaColors.champagneGold, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: VoworaColors.champagneGold, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
