import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_wizard_provider.dart';

// Step Views
import 'wedding_entry_step_view.dart';
import 'wedding_details_step_view.dart';
import 'venue_selection_step_view.dart';
import 'package:vowora/screens/wedding_module/package_selection_step_view.dart';
import 'decoration_step_view.dart';
import 'catering_step_view.dart';
import 'guest_management_step_view.dart';
import 'photography_step_view.dart';
import 'entertainment_step_view.dart';
import 'checklist_step_view.dart';
import 'budget_step_view.dart';
import 'invitation_step_view.dart';
import 'payment_step_view.dart';
import 'wedding_summary_step_view.dart';
import 'wedding_confirmation_step_view.dart';
import 'main_wedding_dashboard_view.dart';

class WeddingWizardHostScreen extends StatelessWidget {
  const WeddingWizardHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeddingWizardProvider>(context);
    final step = provider.currentStep;

    Widget currentBody;
    switch (step) {
      case 0:
        currentBody = const WeddingEntryStepView();
        break;
      case 1:
        currentBody = const WeddingDetailsStepView();
        break;
      case 2:
        currentBody = const VenueSelectionStepView();
        break;
      case 3:
        currentBody = const PackageSelectionStepView();
        break;
      case 4:
        currentBody = const DecorationStepView();
        break;
      case 5:
        currentBody = const CateringStepView();
        break;
      case 6:
        currentBody = const GuestManagementStepView();
        break;
      case 7:
        currentBody = const PhotographyStepView();
        break;
      case 8:
        currentBody = const EntertainmentStepView();
        break;
      case 9:
        currentBody = const ChecklistStepView();
        break;
      case 10:
        currentBody = const BudgetStepView();
        break;
      case 11:
        currentBody = const InvitationStepView();
        break;
      case 12:
        currentBody = const PaymentStepView();
        break;
      case 13:
        currentBody = const WeddingSummaryStepView();
        break;
      case 14:
        currentBody = const WeddingConfirmationStepView();
        break;
      case 15:
        currentBody = const MainWeddingDashboardView();
        break;
      default:
        currentBody = const WeddingEntryStepView();
    }

    return Scaffold(
      backgroundColor: VoworaColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: step > 0 && step != 15
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () {
                  provider.previousStep();
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wedding Manager 💍',
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (step > 0 && step < 14)
              Text(
                'Step $step of 13 • ${_getStepTitle(step)}',
                style: GoogleFonts.plusJakartaSans(
                  color: VoworaColors.champagneGold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Fullscreen luxury background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/wedding_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: currentBody,
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Couple Details';
      case 2:
        return 'Venue Selection';
      case 3:
        return 'Package Selection';
      case 4:
        return 'Decoration';
      case 5:
        return 'Catering Menu';
      case 6:
        return 'Guest Management';
      case 7:
        return 'Photography';
      case 8:
        return 'Entertainment';
      case 9:
        return 'Planning Checklist';
      case 10:
        return 'Budget Tracking';
      case 11:
        return 'Digital Invitation';
      case 12:
        return 'Payment & Receipts';
      case 13:
        return 'Summary & Confirm';
      default:
        return 'Wedding Hub';
    }
  }
}
