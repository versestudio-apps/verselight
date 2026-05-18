import 'package:flutter/material.dart';

import '../data/content_library.dart';
import '../screens/devotional_detail_screen.dart';
import '../screens/paywall_screen.dart';
import '../screens/plan_detail_screen.dart';
import '../screens/settings_screen.dart';
import 'premium_access.dart';

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
    final devo = ContentLibrary.devotionalById(id);
    if (devo == null) return;

    if (!PremiumAccess.guardNavigation(
      context,
      contentIsPremium: devo.isPremium,
    )) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DevotionalDetailScreen(devotional: devo),
      ),
    );
  }

  static void openPlanDetail(BuildContext context, String id) {
    final plan = ContentLibrary.planById(id);
    if (plan == null) return;

    if (!PremiumAccess.guardNavigation(
      context,
      contentIsPremium: plan.isPremium,
    )) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlanDetailScreen(plan: plan),
      ),
    );
  }
}
