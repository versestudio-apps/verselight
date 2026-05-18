import 'package:flutter/material.dart';

import '../models/reading_plan.dart';
import '../utils/devotional_images.dart';
import '../utils/theme.dart';
import 'devotional_image.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DevotionalImage(
                      assetPath: DevotionalImages.forPlanId(plan.id),
                      width: 78,
                      height: 78,
                      borderRadius: BorderRadius.circular(16),
                      semanticLabel: plan.title,
                    ),
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
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 18,
                                  color: AppColors.warmGold,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
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
                              '${plan.durationDays} days · ${plan.category}',
                              style:
                                  theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.marianBlue,
                                fontSize: 11,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plan.subtitle,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.slate,
                    ),
                  ],
                ),
                if (isStarted) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: finished
                              ? AppColors.goldTint.withValues(alpha: 0.6)
                              : AppColors.sageMist,
                          borderRadius:
                              BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Text(
                          finished ? 'Completed' : 'In progress',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 11,
                            color: finished
                                ? AppColors.warmGold
                                : AppColors.sageGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          finished
                              ? '${plan.durationDays} days done'
                              : 'Day $progressDay · $completedDays of ${plan.durationDays}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppColors.border,
                      color: AppColors.sageGreen,
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
