import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme.dart';
import 'app_section_header.dart';
import 'devotional_image.dart';

/// Hero verse card for Home — warm, readable, devotional tone with an
/// optional Catholic devotional image header.
class DailyVerseCard extends StatelessWidget {
  const DailyVerseCard({
    super.key,
    required this.verseText,
    required this.verseRef,
    this.title,
    this.preview,
    this.imagePath,
    this.isCompleted = false,
    this.onTap,
    this.onRead,
  });

  final String? title;
  final String verseText;
  final String verseRef;
  final String? preview;
  final String? imagePath;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onRead;

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
            borderRadius: BorderRadius.circular(AppRadii.card),
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imagePath != null)
                DevotionalHeroImage(
                  assetPath: imagePath!,
                  aspectRatio: 16 / 9,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadii.card),
                    topRight: Radius.circular(AppRadii.card),
                  ),
                  darken: 0.22,
                  semanticLabel: 'Devotional artwork for $verseRef',
                  overlay: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const AppEyebrow(
                              'Verse of the day',
                              color: Colors.white,
                            ),
                            const Spacer(),
                            if (isCompleted) _ReadPill(onImage: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imagePath == null)
                      Row(
                        children: [
                          const AppEyebrow('Verse of the day'),
                          const Spacer(),
                          if (isCompleted) _ReadPill(onImage: false),
                        ],
                      ),
                    if (title != null) ...[
                      if (imagePath == null) const SizedBox(height: 14),
                      Text(title!, style: theme.textTheme.titleLarge),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      verseRef,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.marianBlue,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"$verseText"',
                      style: GoogleFonts.lora(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (preview != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        preview!,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (onRead != null) ...[
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: onRead,
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                          label: const Text('Continue reading'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.warmGold,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
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

class _ReadPill extends StatelessWidget {
  const _ReadPill({required this.onImage});
  final bool onImage;

  @override
  Widget build(BuildContext context) {
    final fg = onImage ? Colors.white : AppColors.sageGreen;
    final bg = onImage
        ? Colors.white.withValues(alpha: 0.25)
        : AppColors.sageMist;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: onImage
            ? Border.all(color: Colors.white.withValues(alpha: 0.55))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: fg, size: 14),
          const SizedBox(width: 4),
          Text(
            'Read',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
