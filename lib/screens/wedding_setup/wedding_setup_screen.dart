import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/theme/vowora_theme.dart';
import '../../models/wedding_profile.dart';
import '../../providers/wedding_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/vowora_button.dart';
import '../../widgets/vowora_text_field.dart';

class WeddingSetupScreen extends StatefulWidget {
  const WeddingSetupScreen({super.key});

  @override
  State<WeddingSetupScreen> createState() => _WeddingSetupScreenState();
}

class _WeddingSetupScreenState extends State<WeddingSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _coupleNameController =
      TextEditingController(text: 'Shrabonti & Alex');
  final TextEditingController _locationController =
      TextEditingController(text: 'Radisson Blu, Dhaka');
  final TextEditingController _guestCountController = TextEditingController(text: '250');
  final TextEditingController _budgetController = TextEditingController(text: '25000');
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 127));
  String _selectedCurrency = VoworaConstants.currencies.first;
  String _selectedStyle = 'Luxury';
  Color _selectedColor = VoworaColors.champagneGold;

  final List<Color> _colorOptions = [
    VoworaColors.champagneGold,
    VoworaColors.dustyRose,
    VoworaColors.mutedMauve,
    VoworaColors.deepForestGreen,
    const Color(0xFF3F51B5),
    const Color(0xFFE91E63),
    const Color(0xFF009688),
    const Color(0xFF795548),
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _coupleNameController.dispose();
    _locationController.dispose();
    _guestCountController.dispose();
    _budgetController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: VoworaColors.champagneGold,
              onPrimary: const Color(0xFF141210),
              surface: const Color(0xFF1C1917),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  void _handleSaveSetup() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: VoworaColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final weddingProvider = Provider.of<WeddingProvider>(context, listen: false);
    final updatedProfile = WeddingProfile(
      id: 'wp_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_active',
      coupleName: _coupleNameController.text.trim(),
      weddingDate: _selectedDate,
      location: _locationController.text.trim(),
      estimatedGuestCount: int.tryParse(_guestCountController.text.trim()) ?? 250,
      estimatedBudget: double.tryParse(_budgetController.text.trim()) ?? 25000.0,
      currency: _selectedCurrency,
      style: _selectedStyle,
      primaryColor: '#${_selectedColor.toARGB32().toRadixString(16).substring(2)}',
    );

    weddingProvider.updateWeddingProfile(updatedProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Celebration saved! Let\'s explore nearby vendors 🎉'),
        backgroundColor: VoworaColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.weddingVendors);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              VoworaConstants.bgWeddingHero,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.68),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        VoworaConstants.appName,
                        style: GoogleFonts.playfairDisplay(
                          color: VoworaColors.champagneGold,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, AppRoutes.weddingVendors);
                          }
                        },
                        child: Text(
                          'Skip for now',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tell us about your celebration ♡',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Let's personalize Vowora around your special day.",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Couple Name
                          VoworaTextField(
                            controller: _coupleNameController,
                            hintText: 'Couple / Wedding Name (e.g. Shrabonti & Alex)',
                            labelText: 'COUPLE NAME',
                            prefixIcon: Icons.favorite_border_rounded,
                            validator: (v) => v == null || v.isEmpty ? 'Please enter couple name' : null,
                          ),
                          const SizedBox(height: 16),
                          // Wedding Date
                          VoworaTextField(
                            controller: _dateController,
                            hintText: 'Select Wedding Date',
                            labelText: 'WEDDING DATE',
                            prefixIcon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: _selectDate,
                          ),
                          const SizedBox(height: 16),
                          // Wedding Location
                          VoworaTextField(
                            controller: _locationController,
                            hintText: 'Wedding Venue / Location',
                            labelText: 'LOCATION',
                            prefixIcon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 16),
                          // Guests & Budget Row
                          Row(
                            children: [
                              Expanded(
                                child: VoworaTextField(
                                  controller: _guestCountController,
                                  hintText: 'Estimated Guests',
                                  labelText: 'GUESTS',
                                  prefixIcon: Icons.people_outline_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: VoworaTextField(
                                  controller: _budgetController,
                                  hintText: 'Total Budget',
                                  labelText: 'BUDGET',
                                  prefixIcon: Icons.attach_money_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Currency Dropdown
                          Text(
                            'CURRENCY',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: VoworaColors.textLightMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCurrency,
                                isExpanded: true,
                                dropdownColor: const Color(0xFF1E1A17),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 15),
                                items: VoworaConstants.currencies
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedCurrency = val);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Style Selection Grid
                          Text(
                            'WEDDING STYLE',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: VoworaColors.textLightMuted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: VoworaConstants.weddingStyles.map((style) {
                              final isSelected = _selectedStyle == style;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedStyle = style);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? VoworaColors.champagneGold
                                        : Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? VoworaColors.champagneGold
                                          : Colors.white.withValues(alpha: 0.3),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Text(
                                    style,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isSelected ? const Color(0xFF141210) : Colors.white,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          // Primary Color Selector
                          Text(
                            'PRIMARY WEDDING COLOR',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: VoworaColors.textLightMuted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _colorOptions.map((color) {
                              final isSelected = _selectedColor == color;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColor = color),
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      width: 2.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: color.withValues(alpha: 0.6),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                          VoworaPrimaryButton(
                            text: 'Start Planning',
                            onPressed: _handleSaveSetup,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
