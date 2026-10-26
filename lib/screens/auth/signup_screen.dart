import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/theme/vowora_theme.dart';
import '../../core/utils/vowora_validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wedding_wizard_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/vowora_button.dart';
import '../../widgets/vowora_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController =
  TextEditingController(text: 'Dhaka, Bangladesh');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _agreeToTerms = false;
  PasswordStrength _passwordStrength =
  PasswordStrength(score: 0.0, label: 'Weak', color: Colors.grey);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordStrength = VoworaValidators.getPasswordStrength(value);
    });
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please accept the Terms & Conditions and Privacy Policy to proceed.'),
          backgroundColor: VoworaColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUp(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final wizardProvider = Provider.of<WeddingWizardProvider>(context, listen: false);
      wizardProvider.resetForNewUser();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Vowora ♡ Account created successfully!'),
          backgroundColor: VoworaColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.weddingSetup);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ??
              'Account creation failed. Please try again.'),
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
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Form Glass Card
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== Heading =====
                          Text(
                            'Create Your Account',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Let's get started. Create your Vowora account and begin planning a celebration that feels uniquely yours.",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ===== Full Name =====
                          VoworaTextField(
                            controller: _fullNameController,
                            hintText: 'Full Name',
                            prefixIcon: Icons.person_outline,
                            validator: (v) =>
                                VoworaValidators.validateRequired(v, 'your name'),
                          ),
                          const SizedBox(height: 14),

                          // ===== Email Address =====
                          VoworaTextField(
                            controller: _emailController,
                            hintText: 'Email Address',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: VoworaValidators.validateEmail,
                          ),
                          const SizedBox(height: 14),

                          // ===== Phone Number =====
                          VoworaTextField(
                            controller: _phoneController,
                            hintText: 'Phone Number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: VoworaValidators.validatePhone,
                          ),
                          const SizedBox(height: 14),

                          // ===== Location =====
                          VoworaTextField(
                            controller: _locationController,
                            hintText: 'Location (e.g., Dhaka, Bangladesh)',
                            prefixIcon: Icons.location_on_outlined,
                            validator: (v) => VoworaValidators.validateRequired(
                                v, 'your location'),
                          ),
                          const SizedBox(height: 14),

                          // ===== Password =====
                          VoworaTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            onChanged: _onPasswordChanged,
                            validator: VoworaValidators.validatePassword,
                          ),
                          const SizedBox(height: 8),

                          // ===== Password Strength Meter =====
                          if (_passwordController.text.isNotEmpty) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _passwordStrength.score,
                                      backgroundColor:
                                      Colors.white.withValues(alpha: 0.2),
                                      color: _passwordStrength.color,
                                      minHeight: 4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Strength: ${_passwordStrength.label}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: _passwordStrength.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          const SizedBox(height: 6),

                          // ===== Confirm Password =====
                          VoworaTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            validator: (v) =>
                                VoworaValidators.validateConfirmPassword(
                                  v,
                                  _passwordController.text,
                                ),
                          ),
                          const SizedBox(height: 16),

                          // ===== Terms Checkbox =====
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (val) {
                                    setState(() {
                                      _agreeToTerms = val ?? false;
                                    });
                                  },
                                  activeColor: VoworaColors.champagneGold,
                                  checkColor: const Color(0xFF141210),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.termsPrivacy);
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.plusJakartaSans(
                                        color:
                                        Colors.white.withValues(alpha: 0.8),
                                        fontSize: 12,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(
                                            color: VoworaColors.champagneGold,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: VoworaColors.champagneGold,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ===== Submit Button =====
                          VoworaPrimaryButton(
                            text: 'Create Account',
                            isLoading: authProvider.isLoading,
                            onPressed: _handleSignup,
                          ),
                          const SizedBox(height: 16),

                          // ===== Login Link =====
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Log In',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: VoworaColors.champagneGold,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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