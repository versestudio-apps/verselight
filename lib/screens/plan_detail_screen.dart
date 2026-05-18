import 'package:flutter/material.dart';

import '../models/plan_day.dart';
import '../models/reading_plan.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';

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
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(plan.emoji, style: const TextStyle(fontSize: 44)),
                          const SizedBox(width: 16),
                          Expanded(
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
                                const SizedBox(height: 6),
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
                        ],
                      ),
                      if (started) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isFinished ? 'Completed' : 'Your progress',
                              style: theme.textTheme.labelLarge,
                            ),
                            Text(
                              isFinished
                                  ? 'All ${plan.durationDays} days'
                                  : 'Day $currentDay of ${plan.durationDays}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.sage,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: isFinished ? 1.0 : progress,
                            minHeight: 8,
                            backgroundColor:
                                AppColors.goldSoft.withValues(alpha: 0.35),
                            color: AppColors.sage,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Daily readings', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ...plan.days.map((day) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PlanDayTile(
                    day: day,
                    isDone: appState.isPlanDayCompleted(plan.id, day.dayNumber),
                    isCurrent:
                        appState.isPlanCurrentDay(plan.id, day.dayNumber),
                    isStarted: started,
                  ),
                );
              }),
              const SizedBox(height: 12),
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
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text('Complete day $currentDay'),
                )
              else
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.celebration_outlined),
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

    return Card(
      color: isCurrent
          ? AppColors.sageLight.withValues(alpha: 0.45)
          : AppColors.surface,
      child: ExpansionTile(
        initiallyExpanded: isCurrent,
        leading: CircleAvatar(
          backgroundColor: isDone
              ? AppColors.sage
              : (isCurrent
                  ? AppColors.goldSoft
                  : AppColors.goldSoft.withValues(alpha: 0.35)),
          child: Icon(
            isDone ? Icons.check_rounded : Icons.menu_book_rounded,
            color: isDone ? Colors.white : AppColors.gold,
            size: 20,
          ),
        ),
        title: Text(
          'Day ${day.dayNumber}: ${day.title}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 15,
          ),
        ),
        subtitle: isCurrent && isStarted
            ? Text(
                'Today\'s reading',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.sage,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(day.verseReference, style: theme.textTheme.bodySmall),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.verseText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                Text(day.reflection, style: theme.textTheme.bodyMedium),
                if (day.actionStep != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Action: ${day.actionStep}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
