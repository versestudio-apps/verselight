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

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite_border_rounded,
                    size: 16, color: AppColors.sage),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    timeLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.warmBrownMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  color: AppColors.warmBrownMuted,
                ),
              ],
            ),
            Text(
              entry.text,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
            ),
          ],
        ),
      ),
    );
  }
}
