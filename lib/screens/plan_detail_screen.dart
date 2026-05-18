import 'package:flutter/material.dart';

import '../models/plan_day.dart';
import '../models/reading_plan.dart';
import '../utils/devotional_images.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/devotional_image.dart';

class PlanDetailScreen extends StatelessWidget {
  const PlanDetailScreen({super.key, required this.plan});

  final ReadingPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final started = appState.isPlanStarted(plan.id);
          final currentDay = appState.planProgressDay(plan.id);
          final completedCount =
              started ? (currentDay - 1).clamp(0, plan.durationDays) : 0;
          final progress = started
              ? (completedCount / plan.durationDays).clamp(0.0, 1.0)
              : 0.0;
          final isFinished = started && currentDay > plan.durationDays;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppShadows.soft,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DevotionalImage(
                      assetPath: DevotionalImages.forPlanId(plan.id),
                      height: 160,
                      width: double.infinity,
                      borderRadius: BorderRadius.zero,
                      semanticLabel: plan.title,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan.title,
                              style: theme.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            plan.subtitle,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.marianBlueLight,
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.pill),
                                ),
                                child: Text(
                                  '${plan.durationDays} days · ${plan.category}',
                                  style: theme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppColors.marianBlue,
                                    fontSize: 11.5,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (started) ...[
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isFinished
                                      ? 'Completed'
                                      : 'Your progress',
                                  style: theme.textTheme.labelLarge,
                                ),
                                Text(
                                  isFinished
                                      ? 'All ${plan.durationDays} days'
                                      : 'Day $currentDay of ${plan.durationDays}',
                                  style:
                                      theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.sageGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: isFinished ? 1.0 : progress,
                                minHeight: 8,
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
              const SizedBox(height: 26),
              Text('Daily readings', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ...plan.days.map((day) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _PlanDayTile(
                    day: day,
                    isDone: appState.isPlanDayCompleted(plan.id, day.dayNumber),
                    isCurrent:
                        appState.isPlanCurrentDay(plan.id, day.dayNumber),
                    isStarted: started,
                  ),
                );
              }),
              const SizedBox(height: 14),
              if (!started)
                FilledButton.icon(
                  onPressed: () async {
                    await appState.startPlan(plan.id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Started "${plan.title}"')),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start this plan'),
                )
              else if (!isFinished)
                FilledButton.icon(
                  onPressed: () async {
                    await appState.completeCurrentPlanDay(plan.id);
                    if (!context.mounted) return;
                    final day = appState.planProgressDay(plan.id);
                    final message = day > plan.durationDays
                        ? 'Plan complete — great work!'
                        : 'Day marked complete. On to day $day.';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: Text('Complete day $currentDay'),
                )
              else
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.celebration_rounded),
                  label: const Text('Plan completed'),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PlanDayTile extends StatelessWidget {
  const _PlanDayTile({
    required this.day,
    required this.isDone,
    required this.isCurrent,
    required this.isStarted,
  });

  final PlanDay day;
  final bool isDone;
  final bool isCurrent;
  final bool isStarted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderColor = isCurrent
        ? AppColors.warmGold.withValues(alpha: 0.55)
        : AppColors.border;
    final cardColor =
        isCurrent ? AppColors.softCream : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isCurrent,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.sageGreen
                  : (isCurrent
                      ? AppColors.goldTint.withValues(alpha: 0.7)
                      : AppColors.softCream),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: isDone
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    '${day.dayNumber}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isCurrent
                          ? AppColors.warmGold
                          : AppColors.slate,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          title: Text(
            day.title,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
          ),
          subtitle: isCurrent && isStarted
              ? Text(
                  "Today's reading",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(day.verseReference, style: theme.textTheme.bodySmall),
          iconColor: AppColors.slate,
          collapsedIconColor: AppColors.slate,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${day.verseText}"',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(day.reflection, style: theme.textTheme.bodyMedium),
                  if (day.actionStep != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.goldTint.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.directions_walk_rounded,
                            size: 16,
                            color: AppColors.warmGold,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              day.actionStep!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.deepNavy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
