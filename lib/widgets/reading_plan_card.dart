import 'package:flutter/material.dart';

import '../models/reading_plan.dart';
import '../utils/constants.dart';
import '../utils/devotional_images.dart';
import '../utils/theme.dart';
import 'devotional_image.dart';

/// Reading-plan list card. Switches to a banner-on-top layout so
/// landscape plan artwork (Phase 08E masters are 16:9) renders in its
/// native frame instead of being squeezed into a 78×78 square thumbnail.
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

    final imagePath = DevotionalImages.forPlanId(plan.id);
    final showPremiumBadge =
        plan.isPremium && AppConstants.kEnableMockPurchases;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DevotionalHeroImage(
                assetPath: imagePath,
                aspectRatio: 16 / 9,
                alignment: DevotionalImages.alignmentFor(imagePath),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadii.card),
                  topRight: Radius.circular(AppRadii.card),
                ),
                darken: showPremiumBadge ? 0.22 : 0.12,
                semanticLabel: plan.title,
                overlay: showPremiumBadge
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: _BannerPill(
                            icon: Icons.auto_awesome_rounded,
                            label: 'Premium',
                          ),
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
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
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.marianBlue,
                          fontSize: 11,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      plan.subtitle,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isStarted) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: finished
                                  ? AppColors.goldTint
                                      .withValues(alpha: 0.6)
                                  : AppColors.sageMist,
                              borderRadius:
                                  BorderRadius.circular(AppRadii.pill),
                            ),
                            child: Text(
                              finished ? 'Completed' : 'In progress',
                              style:
                                  theme.textTheme.labelMedium?.copyWith(
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
                      const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact pill shown on top of the banner image (white-on-glass).
class _BannerPill extends StatelessWidget {
  const _BannerPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
