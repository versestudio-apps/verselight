import 'package:flutter/material.dart';

import '../data/sample_plans.dart';
import '../utils/routes.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/reading_plan_card.dart';
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
            itemCount: samplePlans.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text(
                  'Structured journeys through Scripture—at your pace.',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              final plan = samplePlans[index - 1];
              return ReadingPlanCard(
                plan: plan,
                isStarted: appState.isPlanStarted(plan.id),
                progressDay: appState.planProgressDay(plan.id),
                onTap: () => AppRoutes.openPlanDetail(context, plan.id),
              );
            },
          );
        },
      ),
    );
  }
}
