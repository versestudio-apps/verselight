import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme.dart';
import 'devotional_image.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagePath != null) ...[
                  DevotionalImage(
                    assetPath: imagePath!,
                    width: 92,
                    height: 110,
                    borderRadius: BorderRadius.circular(14),
                    semanticLabel: title,
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title!,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            if (isCompleted)
                              _StatusPill(
                                icon: Icons.check_rounded,
                                label: 'Read',
                                color: AppColors.sageGreen,
                                background: AppColors.sageMist,
                              )
                            else if (isPremium)
                              _StatusPill(
                                icon: Icons.auto_awesome_rounded,
                                label: 'Premium',
                                color: AppColors.warmGold,
                                background:
                                    AppColors.goldTint.withValues(alpha: 0.6),
                              ),
                          ],
                        ),
                      if (title != null) const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
                      Text(
                        '"$verseText"',
                        style: GoogleFonts.lora(
                          fontSize: 15,
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
                      const SizedBox(height: 6),
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
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
