import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/vowora_theme.dart';
import '../../../data/mock_halls_data.dart';
import 'c_hall_details_page.dart';

class CHallPage extends StatelessWidget {
  const CHallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      appBar: AppBar(
        title: const Text('Conference Halls in Sylhet'),
        backgroundColor: VoworaColors.champagneGold,
        foregroundColor: Colors.white,
      ),
      body: mockHalls.isEmpty
          ? Center(
              child: Text(
                'No halls available',
                style: GoogleFonts.plusJakartaSans(
                  color: VoworaColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockHalls.length,
              itemBuilder: (context, index) {
                final hall = mockHalls[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.08),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => CHallDetailsPage(hall: hall),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _HallThumbnail(
                                asset: hall.thumbnailAsset,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hall.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.playfairDisplay(
                                      color: VoworaColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 15,
                                        color: VoworaColors.textSecondary,
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          hall.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: VoworaColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    hall.slogan,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: VoworaColors.textSecondary,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '৳${hall.basePrice}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: VoworaColors.champagneGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'View Details →',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: VoworaColors.champagneGold,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _HallThumbnail extends StatelessWidget {
  const _HallThumbnail({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    if (asset.isEmpty) return const _ImageNotFoundPlaceholder();
    return Image.asset(
      asset,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _ImageNotFoundPlaceholder(),
    );
  }
}

class _ImageNotFoundPlaceholder extends StatelessWidget {
  const _ImageNotFoundPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported,
            size: 32,
            color: Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            'Image Not Found',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade700,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
