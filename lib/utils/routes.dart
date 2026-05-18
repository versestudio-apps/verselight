import 'package:flutter/material.dart';

import '../data/sample_devotionals.dart';
import '../data/sample_plans.dart';
import '../screens/devotional_detail_screen.dart';
import '../screens/paywall_screen.dart';
import '../screens/plan_detail_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/app_state_scope.dart';

class AppRoutes {
  AppRoutes._();

  static const String settings = '/settings';
  static const String paywall = '/paywall';

  static Map<String, WidgetBuilder> get routes => {
        settings: (_) => const SettingsScreen(),
        paywall: (_) => const PaywallScreen(),
      };

  static void openSettings(BuildContext context) {
    Navigator.of(context).pushNamed(settings);
  }

  static void openPaywall(BuildContext context) {
    Navigator.of(context).pushNamed(paywall);
  }

  static void openDevotionalDetail(BuildContext context, String id) {
    final devo = devotionalById(id);
    if (devo == null) return;

    final appState = AppStateScope.of(context);
    if (devo.isPremium && !appState.isPremium) {
      openPaywall(context);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DevotionalDetailScreen(devotional: devo),
      ),
    );
  }

  static void openPlanDetail(BuildContext context, String id) {
    final plan = planById(id);
    if (plan == null) return;

    final appState = AppStateScope.of(context);
    if (plan.isPremium && !appState.isPremium) {
      openPaywall(context);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlanDetailScreen(plan: plan),
      ),
    );
  }

  static Future<void> notifyPremiumChanged(BuildContext context) async {
    await AppStateScope.of(context).onPremiumPurchased();
  }
}
