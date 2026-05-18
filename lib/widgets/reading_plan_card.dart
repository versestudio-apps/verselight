import 'package:flutter/material.dart';

import '../models/reading_plan.dart';
import '../utils/theme.dart';

class ReadingPlanCard extends StatelessWidget {
  const ReadingPlanCard({
    super.key,
    required this.plan,
    required this.isStarted,
    required this.progressDay,
    required this.onTap,
  });

  final ReadingPlan plan;
  final bool isStarted;
  final int progressDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedDays =
        isStarted ? (progressDay - 1).clamp(0, plan.durationDays) : 0;
    final finished = isStarted && progressDay > plan.durationDays;
    final progress = finished
        ? 1.0
        : (isStarted
            ? (completedDays / plan.durationDays).clamp(0.0, 1.0)
            : 0.0);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                plan.title,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            if (plan.isPremium)
                              const Icon(Icons.lock_rounded,
                                  size: 18, color: AppColors.premium),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${plan.durationDays} days · ${plan.category}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.warmBrownMuted),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                plan.subtitle,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isStarted) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: finished
                            ? AppColors.goldSoft.withValues(alpha: 0.5)
                            : AppColors.sageLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        finished ? 'Completed' : 'In progress',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 11,
                          color: finished ? AppColors.gold : AppColors.sage,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      finished
                          ? '${plan.durationDays} days done'
                          : 'Day $progressDay · $completedDays completed',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.goldSoft.withValues(alpha: 0.35),
                    color: AppColors.sage,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
