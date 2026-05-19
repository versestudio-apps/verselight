import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/devotional_images.dart';
import '../utils/theme.dart';
import 'devotional_image.dart';

/// Devotional list card. When [imagePath] is provided, the artwork is
/// rendered as a full-width 16:9 banner on top of the text content so
/// landscape masters (Phase 08E) display in their native ratio without
/// being squeezed into a tiny side thumbnail.
class VerseCard extends StatelessWidget {
  const VerseCard({
    super.key,
    required this.verseText,
    required this.verseRef,
    this.title,
    this.bodyPreview,
    this.imagePath,
    this.isPremium = false,
    this.isCompleted = false,
    this.onTap,
  });

  final String? title;
  final String verseText;
  final String verseRef;
  final String? bodyPreview;
  final String? imagePath;
  final bool isPremium;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.hairline,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imagePath != null)
                DevotionalHeroImage(
                  assetPath: imagePath!,
                  aspectRatio: 16 / 9,
                  alignment: DevotionalImages.alignmentFor(imagePath!),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadii.card),
                    topRight: Radius.circular(AppRadii.card),
                  ),
                  // Pills sit on the banner, so darken slightly more than
                  // a plain image so the pill chrome stays legible.
                  darken: (isCompleted || isPremium) ? 0.22 : 0.12,
                  semanticLabel: title ?? verseRef,
                  overlay: (isCompleted || isPremium)
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: _BannerPill(
                              icon: isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.auto_awesome_rounded,
                              label: isCompleted ? 'Read' : 'Premium',
                            ),
                          ),
                        )
                      : null,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.marianBlueLight,
                        borderRadius:
                            BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        verseRef,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.marianBlue,
                          fontSize: 11,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"$verseText"',
                      style: GoogleFonts.lora(
                        fontSize: 15.5,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bodyPreview != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        bodyPreview!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: '"$verseText" — $verseRef',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Verse copied')),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 14),
                        label: const Text('Copy verse'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.slate,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(fontSize: 12.5),
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
    );
  }
}

/// Compact pill shown on top of a banner image. White-on-glass styling
/// keeps it legible against any artwork that flows behind it.
class _BannerPill extends StatelessWidget {
  const _BannerPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
