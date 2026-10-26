import 'package:flutter/material.dart';
import 'core/birthday_theme.dart';

/// Placeholder cake studio screen used to keep the birthday feature flow intact.
/// The original project expected this screen to exist, so a lightweight version
/// is provided without changing the rest of the base app structure.
class BirthdayCakeStudioScreen extends StatelessWidget {
  const BirthdayCakeStudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BirthdayTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: BirthdayTheme.warmIvory,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: BirthdayTheme.deepCocoa),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cake Studio',
          style: BirthdayTheme.heading2,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cake design ideas',
                style: BirthdayTheme.heading3,
              ),
              const SizedBox(height: 12),
              Text(
                'This section is ready for signature cake concepts, custom flavor combinations, and cake mockups.',
                style: BirthdayTheme.body,
              ),
              const SizedBox(height: 24),
              _buildIdeaCard(
                title: 'Classic Fondant',
                subtitle: 'Elegant tiers with floral detailing',
                accent: BirthdayTheme.mutedGold,
              ),
              const SizedBox(height: 12),
              _buildIdeaCard(
                title: 'Buttercream Dream',
                subtitle: 'Soft textures and pastel finishes',
                accent: BirthdayTheme.roseBeige,
              ),
              const SizedBox(height: 12),
              _buildIdeaCard(
                title: 'Modern Minimal',
                subtitle: 'Textured frosting with clean lines',
                accent: BirthdayTheme.deepCocoa,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdeaCard({
    required String title,
    required String subtitle,
    required Color accent,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BirthdayTheme.softWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BirthdayTheme.subtleBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.cake_rounded,
              color: accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: BirthdayTheme.heading3.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: BirthdayTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
