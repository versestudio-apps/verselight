import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme.dart';

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
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.parchment.withValues(alpha: 0.9),
              ],
            ),
            border: Border.all(
              color: AppColors.goldSoft.withValues(alpha: 0.8),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.warmBrown.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.goldSoft.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'VERSE OF THE DAY',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 10,
                          letterSpacing: 1.2,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isCompleted)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.sage,
                        size: 22,
                      ),
                  ],
                ),
                if (title != null) ...[
                  const SizedBox(height: 12),
                  Text(title!, style: theme.textTheme.titleLarge),
                ],
                const SizedBox(height: 14),
                Text(
                  verseRef,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  verseText,
                  style: GoogleFonts.lora(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                    color: AppColors.warmBrown,
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
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onRead,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Continue reading'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.gold,
                        padding: EdgeInsets.zero,
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
