import 'package:flutter/material.dart';

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
          final progressDay = appState.planProgressDay(plan.id);
          final progress =
              started ? (progressDay / plan.durationDays).clamp(0.0, 1.0) : 0.0;

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
                                  '${plan.durationDays}-day plan',
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
                      const SizedBox(height: 12),
                      Text(plan.description,
                          style: theme.textTheme.bodyMedium),
                      if (started) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your progress',
                              style: theme.textTheme.labelLarge,
                            ),
                            Text(
                              'Day $progressDay of ${plan.durationDays}',
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
                            value: progress,
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
              Text('Reading schedule', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                'Preview of upcoming days',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              ...plan.dayReadings.asMap().entries.map((entry) {
                final dayNum = entry.key + 1;
                final dayLabel = entry.value;
                final isCurrent = started && dayNum == progressDay;
                final isDone = started && dayNum < progressDay;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    color: isCurrent
                        ? AppColors.sageLight.withValues(alpha: 0.5)
                        : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isDone
                            ? AppColors.sage
                            : AppColors.goldSoft.withValues(alpha: 0.5),
                        child: Icon(
                          isDone
                              ? Icons.check_rounded
                              : Icons.menu_book_rounded,
                          color: isDone ? Colors.white : AppColors.gold,
                          size: 20,
                        ),
                      ),
                      title: Text(dayLabel, style: theme.textTheme.bodyLarge),
                      trailing: isCurrent
                          ? Text(
                              'Today',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.sage,
                                fontSize: 12,
                              ),
                            )
                          : const Icon(Icons.chevron_right_rounded, size: 20),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening: $dayLabel (mock)')),
                        );
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: started
                    ? null
                    : () async {
                        await appState.startPlan(plan.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Started "${plan.title}"')),
                        );
                      },
                icon: Icon(
                  started ? Icons.check_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(started ? 'Plan in progress' : 'Start this plan'),
              ),
            ],
          );
        },
      ),
    );
  }
}
