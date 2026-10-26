import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/vowora_constants.dart';
import '../../core/theme/vowora_theme.dart';
import '../../providers/wedding_provider.dart';
import '../../widgets/empty_state.dart';

class InspirationScreen extends StatefulWidget {
  const InspirationScreen({super.key});

  @override
  State<InspirationScreen> createState() => _InspirationScreenState();
}

class _InspirationScreenState extends State<InspirationScreen> {
  String _selectedCategory = 'All';
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final weddingProvider = Provider.of<WeddingProvider>(context);
    final allItems = weddingProvider.inspirationItems;

    final filteredItems = allItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesFavorite = !_showFavoritesOnly || item.isFavorite;
      return matchesCategory && matchesFavorite;
    }).toList();

    return Scaffold(
      backgroundColor: VoworaColors.ivoryCream,
      appBar: AppBar(
        title: const Text('Ideas & Inspiration'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _showFavoritesOnly ? Colors.redAccent : VoworaColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', ...VoworaConstants.inspirationCategories].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = cat);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                          cat,
                          style: GoogleFonts.plusJakartaSans(
                            color: isSelected ? const Color(0xFF141210) : VoworaColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Inspiration Grid
            Expanded(
              child: filteredItems.isEmpty
                  ? VoworaEmptyState(
                      title: 'No inspiration items found ♡',
                      description: 'Explore themes and tap the heart icon to add to your collection.',
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.75),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      weddingProvider.toggleInspirationFavorite(item.id);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                        color: item.isFavorite ? Colors.redAccent : Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: VoworaColors.champagneGold,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.category.toUpperCase(),
                                          style: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF141210),
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.title,
                                        style: GoogleFonts.playfairDisplay(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
