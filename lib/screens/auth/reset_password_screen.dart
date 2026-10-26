import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/theme/vowora_theme.dart';
import '../../core/utils/vowora_validators.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/vowora_button.dart';
import '../../widgets/vowora_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  PasswordStrength _passwordStrength = PasswordStrength(score: 0.0, label: 'Weak', color: Colors.grey);
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordStrength = VoworaValidators.getPasswordStrength(value);
    });
  }

  Future<void> _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated successfully. Please log in with your new password.'),
        backgroundColor: VoworaColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
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
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reset Password',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please enter your new password below.',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          VoworaTextField(
                            controller: _newPasswordController,
                            hintText: 'New Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            onChanged: _onPasswordChanged,
                            validator: VoworaValidators.validatePassword,
                          ),
                          const SizedBox(height: 8),
                          if (_newPasswordController.text.isNotEmpty) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _passwordStrength.score,
                                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                                      color: _passwordStrength.color,
                                      minHeight: 4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _passwordStrength.label,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: _passwordStrength.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          VoworaTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm New Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            validator: (v) => VoworaValidators.validateConfirmPassword(
                              v,
                              _newPasswordController.text,
                            ),
                          ),
                          const SizedBox(height: 28),
                          VoworaPrimaryButton(
                            text: 'Update Password',
                            isLoading: _isLoading,
                            onPressed: _handleUpdatePassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
