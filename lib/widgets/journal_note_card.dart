import 'package:flutter/material.dart';

import '../models/prayer_entry.dart';
import '../utils/theme.dart';

class JournalNoteCard extends StatelessWidget {
  const JournalNoteCard({
    super.key,
    required this.entry,
    required this.timeLabel,
    required this.onDelete,
  });

  final PrayerEntry entry;
  final String timeLabel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.hairline,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.sageMist,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 14,
                    color: AppColors.sageGreen,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    timeLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.slate,
                      fontSize: 11.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  onPressed: onDelete,
                  tooltip: 'Delete entry',
                  color: AppColors.slate,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              entry.text,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
