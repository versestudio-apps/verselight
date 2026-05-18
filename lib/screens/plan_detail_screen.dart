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

    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(plan.emoji, style: const TextStyle(fontSize: 40)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.title, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(
                          '${plan.durationDays} days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(plan.description, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Reading schedule', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Sample days (full plan in a future release)',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          ...plan.dayReadings.map(
            (day) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.goldSoft.withValues(alpha: 0.5),
                    child: const Icon(Icons.menu_book_rounded,
                        color: AppColors.gold, size: 20),
                  ),
                  title: Text(day, style: theme.textTheme.bodyLarge),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening: $day (mock)')),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: AppStateScope.of(context),
            builder: (context, _) {
              final started =
                  AppStateScope.of(context).isPlanStarted(plan.id);
              return FilledButton.icon(
                onPressed: started
                    ? null
                    : () async {
                        await AppStateScope.of(context).startPlan(plan.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Started "${plan.title}"'),
                          ),
                        );
                      },
                icon: Icon(
                  started ? Icons.check_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(started ? 'Plan in progress' : 'Start plan'),
              );
            },
          ),
        ],
      ),
    );
  }
}
