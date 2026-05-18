import 'package:flutter/material.dart';

import '../data/sample_plans.dart';
import '../models/reading_plan.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/screen_app_bar.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'Reading Plans', showSettings: false),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: samplePlans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final plan = samplePlans[index];
              return _PlanTile(
                plan: plan,
                isStarted: appState.isPlanStarted(plan.id),
                onTap: () => AppRoutes.openPlanDetail(context, plan.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.isStarted,
    required this.onTap,
  });

  final ReadingPlan plan;
  final bool isStarted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(plan.emoji, style: const TextStyle(fontSize: 28)),
        title: Text(plan.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          isStarted
              ? 'In progress · ${plan.durationDays} days'
              : '${plan.durationDays} days · ${plan.description}',
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: plan.isPremium
            ? const Icon(Icons.lock_rounded, color: AppColors.premium, size: 20)
            : const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
