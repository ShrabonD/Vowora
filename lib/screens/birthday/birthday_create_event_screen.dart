import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'core/birthday_theme.dart';
import '../../providers/birthday_provider.dart';
import '../../models/birthday/birthday_event.dart';

/// Multi-step creation wizard for creating a new Birthday Event.
/// Includes 4 steps:
/// 1. Birthday Details
/// 2. Preferences
/// 3. Budget & Allocation
/// 4. Review & Save
class BirthdayCreateEventScreen extends StatefulWidget {
  const BirthdayCreateEventScreen({
    super.key,
    this.event,
  });

  final BirthdayEvent? event;

  @override
  State<BirthdayCreateEventScreen> createState() => _BirthdayCreateEventScreenState();
}

class _BirthdayCreateEventScreenState extends State<BirthdayCreateEventScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep3 = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _isSaving = false;
  String? _eventDateError;

  // ===== Step 1 Form Controllers & State =====
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _guestCountController = TextEditingController(text: '20');

  DateTime? _dateOfBirth;
  DateTime? _eventDate;
  String _birthdayType = 'Personal Birthday';
  String _preferredTheme = 'Minimal Classy';
  String _venueSetting = 'Indoor'; // Indoor or Outdoor

  // ===== Step 2 Preferences State =====
  String _colorPalette = 'Warm Neutrals';
  String _celebrationStyle = 'Elegant';
  String _preferredVenueType = 'Banquet Hall';
  String _foodPreference = 'Mixed';
  String _cakeStyle = 'Classic';
  String _entertainment = 'Music';
  String _photography = 'Professional';

  // ===== Step 3 Budget State =====
  final TextEditingController _budgetController = TextEditingController(text: '50000');

  // ===== Options Lists =====
  static const List<String> _birthdayTypes = [
    'Personal Birthday',
    'Surprise Birthday',
    'Kids\' Birthday',
    'Milestone Birthday',
    'Family Birthday',
    'Romantic Birthday',
    'Friends\' Birthday',
    'Luxury Birthday',
    'Intimate Celebration',
  ];

  static const List<String> _themes = [
    'Minimal Classy',
    'Champagne & Gold',
    'Blush & Ivory',
    'Garden Romance',
    'Pastel Dream',
    'Royal Celebration',
    'Black & Gold',
    'Floral Elegance',
    'Kids\' Wonderland',
    'Gaming Party',
    'K-pop Inspired',
    'Tropical Summer',
  ];

  static const List<String> _colorPalettes = [
    'Warm Neutrals',
    'Blush Pink',
    'Gold & Ivory',
    'Pastel Rainbow',
    'Bold & Vibrant',
    'Monochrome',
  ];

  static const Map<String, Color> _paletteColors = {
    'Warm Neutrals': Color(0xFFD9B7A7),
    'Blush Pink': Color(0xFFF2A7B5),
    'Gold & Ivory': Color(0xFFD4AF37),
    'Pastel Rainbow': Color(0xFFA7D7C5),
    'Bold & Vibrant': Color(0xFFE25B45),
    'Monochrome': Color(0xFF4A4A4A),
  };

  static const List<String> _celebrationStyles = [
    'Elegant',
    'Casual',
    'Festive',
    'Themed',
    'Luxury',
  ];

  static const List<String> _venueTypes = [
    'Home',
    'Restaurant',
    'Banquet Hall',
    'Outdoor Venue',
    'Rooftop',
    'Beach',
  ];

  static const List<String> _foodPreferences = [
    'Bengali',
    'Chinese',
    'Mixed',
    'BBQ',
    'Desserts Only',
    'Full Buffet',
  ];

  static const List<String> _cakeStyles = [
    'Classic',
    'Fondant',
    'Buttercream',
    'Naked Cake',
    'Tiered',
    'Custom',
  ];

  static const List<String> _entertainmentOptions = [
    'Music',
    'DJ',
    'Live Band',
    'Games',
    'Magic Show',
    'Photo Booth',
  ];

  static const List<String> _photographyOptions = [
    'Professional',
    'DIY',
    'Photo Booth',
    'Videography',
  ];

  static const List<double> _presetBudgets = [
    10000,
    25000,
    50000,
    100000,
    200000,
  ];

  // 10 categories totaling 100% suggested split
  static const List<_BudgetCategory> _budgetCategories = [
    _BudgetCategory(name: 'Food & Catering', percentage: 0.30, icon: Icons.restaurant_rounded),
    _BudgetCategory(name: 'Venue', percentage: 0.20, icon: Icons.villa_outlined),
    _BudgetCategory(name: 'Decoration', percentage: 0.15, icon: Icons.celebration_outlined),
    _BudgetCategory(name: 'Cake', percentage: 0.08, icon: Icons.cake_outlined),
    _BudgetCategory(name: 'Photography', percentage: 0.08, icon: Icons.camera_alt_outlined),
    _BudgetCategory(name: 'Entertainment', percentage: 0.06, icon: Icons.music_note_outlined),
    _BudgetCategory(name: 'Gifts', percentage: 0.05, icon: Icons.card_giftcard_outlined),
    _BudgetCategory(name: 'Invitations', percentage: 0.03, icon: Icons.mail_outline_rounded),
    _BudgetCategory(name: 'Transport', percentage: 0.02, icon: Icons.directions_car_outlined),
    _BudgetCategory(name: 'Miscellaneous', percentage: 0.03, icon: Icons.miscellaneous_services_outlined),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _nameController.text = widget.event!.personName;
      _locationController.text = widget.event!.location;
      _guestCountController.text = widget.event!.expectedGuestCount.toString();
      _budgetController.text = widget.event!.totalBudget.toString();
      _eventDate = widget.event!.eventDate;
      _preferredTheme = widget.event!.theme;
      _birthdayType = widget.event!.eventType;
      _colorPalette = widget.event!.colorPalette;
      _celebrationStyle = widget.event!.style;
      _foodPreference = widget.event!.foodPreference;
      _cakeStyle = widget.event!.cakeStyle;
    } else {
      // Default event date to 14 days from now
      _eventDate = DateTime.now().add(const Duration(days: 14));
    }
    _budgetController.addListener(_onBudgetChanged);
  }

  void _onBudgetChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _guestCountController.dispose();
    _budgetController.removeListener(_onBudgetChanged);
    _budgetController.dispose();
    super.dispose();
  }

  double get _currentTotalBudget {
    final clean = _budgetController.text.replaceAll(',', '').replaceAll('৳', '').trim();
    return double.tryParse(clean) ?? 0.0;
  }

  String _formatTaka(num amount) {
    try {
      final formatter = NumberFormat.currency(symbol: '৳', decimalDigits: 0, locale: 'en_IN');
      return formatter.format(amount.round());
    } catch (_) {
      return '৳${amount.round()}';
    }
  }

  void _calculateAgeFromDob() {
    if (_dateOfBirth == null) return;
    final target = _eventDate ?? DateTime.now();
    int calculatedAge = target.year - _dateOfBirth!.year;
    if (target.month < _dateOfBirth!.month ||
        (target.month == _dateOfBirth!.month && target.day < _dateOfBirth!.day)) {
      calculatedAge--;
    }
    if (calculatedAge >= 0) {
      _ageController.text = calculatedAge.toString();
    }
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final initial = _dateOfBirth ?? DateTime(now.year - 20, now.month, now.day);
    final picked = await _showStyledDatePicker(
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        _calculateAgeFromDob();
      });
    }
  }

  Future<void> _selectEventDate() async {
    final now = DateTime.now();
    final initial = _eventDate ?? now.add(const Duration(days: 14));
    final picked = await _showStyledDatePicker(
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() {
        _eventDate = picked;
        _eventDateError = null;
        if (_dateOfBirth != null) {
          _calculateAgeFromDob();
        }
      });
    }
  }

  Future<DateTime?> _showStyledDatePicker({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: BirthdayTheme.mutedGold,
              onPrimary: BirthdayTheme.softWhite,
              surface: BirthdayTheme.softWhite,
              onSurface: BirthdayTheme.deepCocoa,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: BirthdayTheme.mutedGold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _goToStep(int step) {
    if (step < 0 || step > 3) return;
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToNext() {
    FocusScope.of(context).unfocus();
    if (_currentStep == 0) {
      final valid = _formKeyStep1.currentState?.validate() ?? false;
      if (_eventDate == null) {
        setState(() => _eventDateError = 'Please select the event date');
        return;
      }
      if (!valid) return;
      _goToStep(1);
    } else if (_currentStep == 1) {
      _goToStep(2);
    } else if (_currentStep == 2) {
      final valid = _formKeyStep3.currentState?.validate() ?? false;
      if (!valid) return;
      if (_currentTotalBudget <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a valid budget greater than ৳0',
              style: GoogleFonts.plusJakartaSans(color: BirthdayTheme.softWhite),
            ),
            backgroundColor: BirthdayTheme.deepCocoa,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      _goToStep(3);
    }
  }

  void _goToPrevious() {
    FocusScope.of(context).unfocus();
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  Future<void> _saveEvent() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final String generatedId = 'bd_${DateTime.now().millisecondsSinceEpoch}';
      final int guestCount = int.tryParse(_guestCountController.text.trim()) ?? 20;
      final int? age = int.tryParse(_ageController.text.trim());

      final newEvent = BirthdayEvent(
        id: generatedId,
        personName: _nameController.text.trim(),
        dateOfBirth: _dateOfBirth,
        eventDate: _eventDate!,
        age: age,
        birthdayType: _birthdayType,
        theme: _preferredTheme,
        location: _locationController.text.trim(),
        venueType: '$_venueSetting · $_preferredVenueType',
        expectedGuestCount: guestCount > 0 ? guestCount : 20,
        totalBudget: _currentTotalBudget > 0 ? _currentTotalBudget : 50000,
        colorPalette: _colorPalette,
        celebrationStyle: _celebrationStyle,
        foodPreference: _foodPreference,
        cakeStyle: _cakeStyle,
        entertainmentOption: _entertainment,
        photographyPreference: _photography,
        status: 'planning',
      );

      final birthdayProvider = Provider.of<BirthdayProvider>(context, listen: false);
      await birthdayProvider.addEvent(newEvent);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: BirthdayTheme.successGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '🎉 Birthday event for "${newEvent.personName}" created successfully!',
                  style: GoogleFonts.plusJakartaSans(
                    color: BirthdayTheme.softWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: BirthdayTheme.deepCocoa,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pop(context, newEvent);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to create event: $e',
            style: GoogleFonts.plusJakartaSans(color: BirthdayTheme.softWhite),
          ),
          backgroundColor: BirthdayTheme.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BirthdayTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: BirthdayTheme.warmIvory,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: BirthdayTheme.deepCocoa, size: 18),
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Create Birthday Event', style: BirthdayTheme.heading3),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: BirthdayTheme.champagneBeige,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Step ${_currentStep + 1}/4',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: BirthdayTheme.deepCocoa,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1Details(),
                _buildStep2Preferences(),
                _buildStep3Budget(),
                _buildStep4Review(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ==========================================
  // STEP INDICATOR HEADER
  // ==========================================
  Widget _buildStepIndicator() {
    final steps = ['Details', 'Preferences', 'Budget', 'Review'];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      color: BirthdayTheme.warmIvory,
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          final isLast = index == steps.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (index < _currentStep) {
                  _goToStep(index);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? BirthdayTheme.mutedGold
                                : isActive
                                    ? BirthdayTheme.deepCocoa
                                    : BirthdayTheme.softWhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? BirthdayTheme.mutedGold
                                  : isCompleted
                                      ? BirthdayTheme.mutedGold
                                      : BirthdayTheme.subtleBorder,
                              width: 1.5,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: BirthdayTheme.mutedGold.withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check, size: 16, color: BirthdayTheme.softWhite)
                                : Text(
                                    '${index + 1}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: (isActive || isCompleted)
                                          ? BirthdayTheme.softWhite
                                          : BirthdayTheme.deepCocoa.withValues(alpha: 0.5),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          steps[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                            color: isActive
                                ? BirthdayTheme.deepCocoa
                                : BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 18,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: index < _currentStep
                            ? BirthdayTheme.mutedGold
                            : BirthdayTheme.subtleBorder,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==========================================
  // STEP 1: BIRTHDAY DETAILS
  // ==========================================
  Widget _buildStep1Details() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Birthday Person & Event',
              subtitle: 'Tell us who we are celebrating and the core event details',
              icon: Icons.cake_rounded,
            ),
            const SizedBox(height: 18),

            // Person Name (Required)
            TextFormField(
              controller: _nameController,
              style: BirthdayTheme.body,
              textCapitalization: TextCapitalization.words,
              decoration: BirthdayTheme.inputDecoration(
                'Birthday Person\'s Name *',
                hint: 'e.g. Ayesha Rahman',
                icon: Icons.person_outline_rounded,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter the birthday person\'s name';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Date of Birth & Age Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: _selectDateOfBirth,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: BirthdayTheme.warmIvory,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: BirthdayTheme.subtleBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.cake_outlined, color: BirthdayTheme.mutedGold, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date of Birth',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _dateOfBirth != null
                                      ? DateFormat('dd MMM yyyy').format(_dateOfBirth!)
                                      : 'Select DOB',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: _dateOfBirth != null
                                        ? BirthdayTheme.deepCocoa
                                        : BirthdayTheme.deepCocoa.withValues(alpha: 0.4),
                                    fontSize: 13,
                                    fontWeight: _dateOfBirth != null ? FontWeight.w600 : FontWeight.normal,
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
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    style: BirthdayTheme.body,
                    decoration: BirthdayTheme.inputDecoration(
                      'Age',
                      hint: 'e.g. 25',
                      icon: Icons.tag_rounded,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Event Date (Required)
            InkWell(
              onTap: _selectEventDate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: BirthdayTheme.warmIvory,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _eventDateError != null ? BirthdayTheme.errorRed : BirthdayTheme.subtleBorder,
                    width: _eventDateError != null ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_available_rounded, color: BirthdayTheme.mutedGold, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Date *',
                            style: GoogleFonts.plusJakartaSans(
                              color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _eventDate != null
                                ? DateFormat('EEEE, dd MMMM yyyy').format(_eventDate!)
                                : 'Select Celebration Date',
                            style: GoogleFonts.plusJakartaSans(
                              color: _eventDate != null
                                  ? BirthdayTheme.deepCocoa
                                  : BirthdayTheme.deepCocoa.withValues(alpha: 0.4),
                              fontSize: 14,
                              fontWeight: _eventDate != null ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.calendar_month_outlined, color: BirthdayTheme.mutedGold, size: 20),
                  ],
                ),
              ),
            ),
            if (_eventDateError != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  _eventDateError!,
                  style: GoogleFonts.plusJakartaSans(color: BirthdayTheme.errorRed, fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 14),

            // Birthday Type Dropdown
            DropdownButtonFormField<String>(
              initialValue: _birthdayType,
              style: BirthdayTheme.body,
              dropdownColor: BirthdayTheme.softWhite,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: BirthdayTheme.mutedGold),
              decoration: BirthdayTheme.inputDecoration(
                'Birthday Type',
                icon: Icons.celebration_outlined,
              ),
              items: _birthdayTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _birthdayType = val);
              },
            ),
            const SizedBox(height: 14),

            // Preferred Theme Dropdown
            DropdownButtonFormField<String>(
              initialValue: _preferredTheme,
              style: BirthdayTheme.body,
              dropdownColor: BirthdayTheme.softWhite,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: BirthdayTheme.mutedGold),
              decoration: BirthdayTheme.inputDecoration(
                'Preferred Theme',
                icon: Icons.palette_outlined,
              ),
              items: _themes.map((t) {
                return DropdownMenuItem<String>(
                  value: t,
                  child: Text(t),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _preferredTheme = val);
              },
            ),
            const SizedBox(height: 14),

            // Location
            TextFormField(
              controller: _locationController,
              style: BirthdayTheme.body,
              decoration: BirthdayTheme.inputDecoration(
                'Event Location',
                hint: 'e.g. Banani Club / Home / Gulshan-2',
                icon: Icons.location_on_outlined,
              ),
            ),
            const SizedBox(height: 16),

            // Indoor / Outdoor Toggle
            Text(
              'Venue Setting',
              style: BirthdayTheme.label,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: BirthdayTheme.champagneBeige.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BirthdayTheme.subtleBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSettingToggleOption(
                      label: 'Indoor',
                      icon: Icons.home_outlined,
                      isSelected: _venueSetting == 'Indoor',
                      onTap: () => setState(() => _venueSetting = 'Indoor'),
                    ),
                  ),
                  Expanded(
                    child: _buildSettingToggleOption(
                      label: 'Outdoor',
                      icon: Icons.wb_sunny_outlined,
                      isSelected: _venueSetting == 'Outdoor',
                      onTap: () => setState(() => _venueSetting = 'Outdoor'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Expected Guest Count
            TextFormField(
              controller: _guestCountController,
              keyboardType: TextInputType.number,
              style: BirthdayTheme.body,
              decoration: BirthdayTheme.inputDecoration(
                'Expected Guest Count',
                hint: '20',
                icon: Icons.people_outline_rounded,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter expected guest count';
                }
                final count = int.tryParse(val.trim());
                if (count == null || count <= 0) {
                  return 'Guest count must be at least 1';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingToggleOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? BirthdayTheme.mutedGold : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: BirthdayTheme.mutedGold.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? BirthdayTheme.softWhite : BirthdayTheme.deepCocoa,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isSelected ? BirthdayTheme.softWhite : BirthdayTheme.deepCocoa,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // STEP 2: PREFERENCES
  // ==========================================
  Widget _buildStep2Preferences() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: 'Celebration Preferences',
            subtitle: 'Curate the aesthetic, vibe, and entertainment for this birthday',
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 20),

          // Color Palette
          _buildChipSection(
            title: 'Color Palette',
            icon: Icons.color_lens_outlined,
            options: _colorPalettes,
            selectedValue: _colorPalette,
            onSelected: (val) => setState(() => _colorPalette = val),
            colorMap: _paletteColors,
          ),
          const SizedBox(height: 20),

          // Celebration Style
          _buildChipSection(
            title: 'Celebration Style',
            icon: Icons.stars_outlined,
            options: _celebrationStyles,
            selectedValue: _celebrationStyle,
            onSelected: (val) => setState(() => _celebrationStyle = val),
          ),
          const SizedBox(height: 20),

          // Preferred Venue Type
          _buildChipSection(
            title: 'Preferred Venue Type',
            icon: Icons.storefront_outlined,
            options: _venueTypes,
            selectedValue: _preferredVenueType,
            onSelected: (val) => setState(() => _preferredVenueType = val),
          ),
          const SizedBox(height: 20),

          // Food Preferences
          _buildChipSection(
            title: 'Food Preferences',
            icon: Icons.restaurant_menu_outlined,
            options: _foodPreferences,
            selectedValue: _foodPreference,
            onSelected: (val) => setState(() => _foodPreference = val),
          ),
          const SizedBox(height: 20),

          // Cake Style
          _buildChipSection(
            title: 'Cake Style',
            icon: Icons.cake_outlined,
            options: _cakeStyles,
            selectedValue: _cakeStyle,
            onSelected: (val) => setState(() => _cakeStyle = val),
          ),
          const SizedBox(height: 20),

          // Entertainment
          _buildChipSection(
            title: 'Entertainment',
            icon: Icons.music_note_outlined,
            options: _entertainmentOptions,
            selectedValue: _entertainment,
            onSelected: (val) => setState(() => _entertainment = val),
          ),
          const SizedBox(height: 20),

          // Photography
          _buildChipSection(
            title: 'Photography',
            icon: Icons.camera_alt_outlined,
            options: _photographyOptions,
            selectedValue: _photography,
            onSelected: (val) => setState(() => _photography = val),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChipSection({
    required String title,
    required IconData icon,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
    Map<String, Color>? colorMap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: BirthdayTheme.mutedGold),
            const SizedBox(width: 8),
            Text(title, style: BirthdayTheme.heading3.copyWith(fontSize: 15)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = opt == selectedValue;
            final dotColor = colorMap?[opt];

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dotColor != null) ...[
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.2),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(opt),
                ],
              ),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: BirthdayTheme.mutedGold,
              backgroundColor: BirthdayTheme.softWhite,
              side: BorderSide(
                color: isSelected ? BirthdayTheme.mutedGold : BirthdayTheme.subtleBorder,
                width: isSelected ? 1.4 : 0.8,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? BirthdayTheme.softWhite : BirthdayTheme.deepCocoa,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              onSelected: (selected) {
                if (selected) onSelected(opt);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // STEP 3: BUDGET & ALLOCATION
  // ==========================================
  Widget _buildStep3Budget() {
    final double totalBudget = _currentTotalBudget;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKeyStep3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Budget & Category Breakdown',
              subtitle: 'Set your overall celebration budget and inspect suggested splits',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 20),

            // Total Budget Input
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: BirthdayTheme.deepCocoa,
              ),
              decoration: BirthdayTheme.inputDecoration(
                'Total Celebration Budget *',
                hint: '50000',
                icon: Icons.monetization_on_outlined,
              ).copyWith(
                prefixText: '৳ ',
                prefixStyle: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: BirthdayTheme.deepCocoa,
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter total budget';
                }
                final numVal = double.tryParse(val.replaceAll(',', '').replaceAll('৳', '').trim());
                if (numVal == null || numVal <= 0) {
                  return 'Please enter a budget greater than ৳0';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Quick select preset chips
            Text('Quick Select Budget', style: BirthdayTheme.label),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _presetBudgets.map((preset) {
                  final isSelected = (totalBudget == preset);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(_formatTaka(preset)),
                      backgroundColor: isSelected ? BirthdayTheme.mutedGold : BirthdayTheme.softWhite,
                      side: BorderSide(
                        color: isSelected ? BirthdayTheme.mutedGold : BirthdayTheme.subtleBorder,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? BirthdayTheme.softWhite : BirthdayTheme.deepCocoa,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      onPressed: () {
                        setState(() {
                          _budgetController.text = preset.toInt().toString();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Suggested Split Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BirthdayTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suggested Category Split', style: BirthdayTheme.heading3.copyWith(fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: BirthdayTheme.champagneBeige,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '10 Categories (100%)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: BirthdayTheme.deepCocoa,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Read-only dynamic suggested allocations based on your ৳${NumberFormat('#,##,###').format(totalBudget.round())} budget.',
                    style: BirthdayTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Segmented visual distribution bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 10,
                      child: Row(
                        children: _budgetCategories.map((cat) {
                          final colorIdx = _budgetCategories.indexOf(cat);
                          final colors = [
                            BirthdayTheme.mutedGold,
                            BirthdayTheme.roseBeige,
                            BirthdayTheme.alertOrange,
                            BirthdayTheme.deepCocoa.withValues(alpha: 0.7),
                            const Color(0xFF9E8A7A),
                            BirthdayTheme.successGreen,
                            const Color(0xFFC49A74),
                            BirthdayTheme.champagneBeige,
                            const Color(0xFFB57C68),
                            const Color(0xFF8C6D58),
                          ];
                          return Expanded(
                            flex: (cat.percentage * 100).toInt(),
                            child: Container(color: colors[colorIdx % colors.length]),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category Breakdown List
                  ..._budgetCategories.map((cat) {
                    final double allocated = totalBudget * cat.percentage;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: BirthdayTheme.warmIvory,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: BirthdayTheme.subtleBorder),
                            ),
                            child: Icon(cat.icon, size: 18, color: BirthdayTheme.mutedGold),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cat.name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: BirthdayTheme.deepCocoa,
                                      ),
                                    ),
                                    Text(
                                      _formatTaka(allocated),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: BirthdayTheme.deepCocoa,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: cat.percentage,
                                          backgroundColor: BirthdayTheme.champagneBeige.withValues(alpha: 0.5),
                                          valueColor: const AlwaysStoppedAnimation<Color>(BirthdayTheme.mutedGold),
                                          minHeight: 4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(cat.percentage * 100).toInt()}%',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // STEP 4: REVIEW & SAVE
  // ==========================================
  Widget _buildStep4Review() {
    final personName = _nameController.text.trim().isEmpty ? 'Celebrant' : _nameController.text.trim();
    final totalBudget = _currentTotalBudget;
    final int guestCount = int.tryParse(_guestCountController.text.trim()) ?? 20;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: 'Review & Confirm',
            subtitle: 'Double check your celebration plan before saving to your studio',
            icon: Icons.checklist_rtl_rounded,
          ),
          const SizedBox(height: 20),

          // Hero Summary Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BirthdayTheme.deepCocoa,
                  BirthdayTheme.deepCocoa.withValues(alpha: 0.92),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: BirthdayTheme.deepCocoa.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: BirthdayTheme.mutedGold.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: BirthdayTheme.mutedGold.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              _birthdayType.toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: BirthdayTheme.champagneBeige,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            personName,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: BirthdayTheme.softWhite,
                            ),
                          ),
                          if (_ageController.text.trim().isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Turning ${_ageController.text.trim()} years old ✨',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: BirthdayTheme.roseBeige,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: BirthdayTheme.mutedGold.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                        border: Border.all(color: BirthdayTheme.mutedGold.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.cake_rounded, color: BirthdayTheme.mutedGold, size: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: BirthdayTheme.mutedGold),
                    const SizedBox(width: 8),
                    Text(
                      _eventDate != null
                          ? DateFormat('EEEE, dd MMMM yyyy').format(_eventDate!)
                          : 'Date to be confirmed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: BirthdayTheme.softWhite.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 1: Event Details
          _buildReviewCard(
            title: 'Event Details',
            icon: Icons.event_note_rounded,
            onEdit: () => _goToStep(0),
            items: [
              _ReviewItem('Celebrant', personName),
              _ReviewItem('Date of Birth', _dateOfBirth != null ? DateFormat('dd MMM yyyy').format(_dateOfBirth!) : 'Not set'),
              _ReviewItem('Event Date', _eventDate != null ? DateFormat('dd MMM yyyy').format(_eventDate!) : 'Not set'),
              _ReviewItem('Age', _ageController.text.trim().isNotEmpty ? '${_ageController.text.trim()} years' : 'Not specified'),
              _ReviewItem('Type', _birthdayType),
              _ReviewItem('Theme', _preferredTheme),
              _ReviewItem('Setting', '$_venueSetting · $_preferredVenueType'),
              _ReviewItem('Location', _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : 'To be determined'),
              _ReviewItem('Guests', '$guestCount guests expected'),
            ],
          ),
          const SizedBox(height: 16),

          // Section 2: Preferences
          _buildReviewCard(
            title: 'Preferences',
            icon: Icons.palette_outlined,
            onEdit: () => _goToStep(1),
            items: [
              _ReviewItem('Color Palette', _colorPalette),
              _ReviewItem('Celebration Style', _celebrationStyle),
              _ReviewItem('Venue Preference', _preferredVenueType),
              _ReviewItem('Food Preference', _foodPreference),
              _ReviewItem('Cake Style', _cakeStyle),
              _ReviewItem('Entertainment', _entertainment),
              _ReviewItem('Photography', _photography),
            ],
          ),
          const SizedBox(height: 16),

          // Section 3: Budget
          _buildReviewCard(
            title: 'Budget & Top Allocations',
            icon: Icons.savings_outlined,
            onEdit: () => _goToStep(2),
            items: [
              _ReviewItem('Total Budget', _formatTaka(totalBudget), isHighlighted: true),
              _ReviewItem('Food & Catering (30%)', _formatTaka(totalBudget * 0.30)),
              _ReviewItem('Venue (20%)', _formatTaka(totalBudget * 0.20)),
              _ReviewItem('Decoration (15%)', _formatTaka(totalBudget * 0.15)),
              _ReviewItem('Cake (8%)', _formatTaka(totalBudget * 0.08)),
              _ReviewItem('Photography (8%)', _formatTaka(totalBudget * 0.08)),
            ],
          ),
          const SizedBox(height: 24),

          // Primary Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: BirthdayTheme.primaryButton.copyWith(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
              ),
              onPressed: _isSaving ? null : _saveEvent,
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(BirthdayTheme.softWhite),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.celebration_rounded, color: BirthdayTheme.softWhite, size: 20),
                        const SizedBox(width: 8),
                        Text('Create Birthday Event', style: BirthdayTheme.buttonText.copyWith(color: BirthdayTheme.softWhite)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String title,
    required IconData icon,
    required VoidCallback onEdit,
    required List<_ReviewItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BirthdayTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: BirthdayTheme.mutedGold),
                  const SizedBox(width: 8),
                  Text(title, style: BirthdayTheme.heading3.copyWith(fontSize: 16)),
                ],
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 14, color: BirthdayTheme.mutedGold),
                label: Text(
                  'Edit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: BirthdayTheme.mutedGold,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: BirthdayTheme.subtleBorder),
          const SizedBox(height: 10),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: BirthdayTheme.deepCocoa.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.value,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: item.isHighlighted ? FontWeight.bold : FontWeight.w600,
                        color: item.isHighlighted ? BirthdayTheme.mutedGold : BirthdayTheme.deepCocoa,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================
  // COMMON SECTION HEADER
  // ==========================================
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: BirthdayTheme.champagneBeige,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: BirthdayTheme.mutedGold, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: BirthdayTheme.heading2.copyWith(fontSize: 20)),
              const SizedBox(height: 2),
              Text(subtitle, style: BirthdayTheme.subtitle.copyWith(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // BOTTOM BAR
  // ==========================================
  Widget _buildBottomBar() {
    final isLastStep = _currentStep == 3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: BirthdayTheme.softWhite,
        border: const Border(top: BorderSide(color: BirthdayTheme.subtleBorder, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: BirthdayTheme.deepCocoa.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  style: BirthdayTheme.secondaryButton.copyWith(
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                  ),
                  onPressed: _goToPrevious,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text('Back', style: BirthdayTheme.buttonText.copyWith(color: BirthdayTheme.mutedGold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                style: BirthdayTheme.primaryButton.copyWith(
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                ),
                onPressed: _isSaving ? null : (isLastStep ? _saveEvent : _goToNext),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(BirthdayTheme.softWhite),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastStep ? 'Create Birthday Event ✨' : 'Continue',
                            style: BirthdayTheme.buttonText.copyWith(color: BirthdayTheme.softWhite),
                          ),
                          if (!isLastStep) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded, size: 16, color: BirthdayTheme.softWhite),
                          ],
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetCategory {
  final String name;
  final double percentage;
  final IconData icon;

  const _BudgetCategory({
    required this.name,
    required this.percentage,
    required this.icon,
  });
}

class _ReviewItem {
  final String label;
  final String value;
  final bool isHighlighted;

  _ReviewItem(this.label, this.value, {this.isHighlighted = false});
}
