import 'package:flutter/material.dart';

import '../utils/theme.dart';

/// Titled reading block for devotional / plan detail screens.
class ContentSection extends StatelessWidget {
  const ContentSection({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.accent = AppColors.parchment,
    this.iconColor = AppColors.gold,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldSoft.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: iconColor == AppColors.gold
                      ? AppColors.gold
                      : AppColors.sage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
