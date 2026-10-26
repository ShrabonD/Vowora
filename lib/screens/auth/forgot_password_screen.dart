import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/theme/vowora_theme.dart';
import '../../core/utils/vowora_validators.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/vowora_button.dart';
import '../../widgets/vowora_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendPasswordReset(_emailController.text.trim());

    if (!mounted) return;

    if (success) {
      setState(() {
        _emailSent = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to send reset email.'),
          backgroundColor: VoworaColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: _emailSent ? _buildSuccessView() : _buildFormView(authProvider),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forgot your password?',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter your email address and we'll send you a secure link to reset your password.",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          VoworaTextField(
            controller: _emailController,
            hintText: 'Enter your email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: VoworaValidators.validateEmail,
          ),
          const SizedBox(height: 24),
          VoworaPrimaryButton(
            text: 'Send Reset Link',
            isLoading: authProvider.isLoading,
            onPressed: _handleReset,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Back to Login',
                style: GoogleFonts.plusJakartaSans(
                  color: VoworaColors.champagneGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: VoworaColors.champagneGold.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: VoworaColors.champagneGold,
            size: 44,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Check your inbox',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "We've sent password reset instructions to ${_emailController.text.trim()}.",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        VoworaPrimaryButton(
          text: 'Continue to Reset Password',
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.resetPassword);
          },
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Back to Login',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
