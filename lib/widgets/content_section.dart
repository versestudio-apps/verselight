import 'package:flutter/material.dart';

import '../utils/theme.dart';
import 'soft_icon_badge.dart';

/// Titled reading block for devotional / plan detail screens.
///
/// Visually a soft card with an icon badge, eyebrow label, and body text.
class ContentSection extends StatelessWidget {
  const ContentSection({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.accent = AppColors.warmGold,
    this.background = AppColors.softCream,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftIconBadge(icon: icon, color: accent, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
