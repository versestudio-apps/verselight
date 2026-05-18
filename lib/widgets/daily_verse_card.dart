import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme.dart';
import 'app_section_header.dart';

/// Hero verse card for Home — warm, readable, devotional tone.
class DailyVerseCard extends StatelessWidget {
  const DailyVerseCard({
    super.key,
    required this.verseText,
    required this.verseRef,
    this.title,
    this.preview,
    this.isCompleted = false,
    this.onTap,
    this.onRead,
  });

  final String? title;
  final String verseText;
  final String verseRef;
  final String? preview;
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
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.softCream,
              ],
            ),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppEyebrow('Verse of the day'),
                    const Spacer(),
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sageMist,
                          borderRadius:
                              BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.sageGreen,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Read',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.sageGreen,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (title != null) ...[
                  const SizedBox(height: 14),
                  Text(title!, style: theme.textTheme.titleLarge),
                ],
                const SizedBox(height: 14),
                Text(
                  verseRef,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.warmGold,
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
                  const SizedBox(height: 16),
                  Text(
                    preview!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (onRead != null) ...[
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onRead,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
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
        ),
      ),
    );
  }
}
