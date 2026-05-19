import 'package:flutter/material.dart';

import '../models/premium_entitlement.dart';
import '../services/iap_service.dart';
import 'constants.dart';
import 'routes.dart';
import '../widgets/app_state_scope.dart';

/// Central premium gating for devotionals, plans, and audio.
class PremiumAccess {
  PremiumAccess._();

  static bool hasAccess({
    required bool contentIsPremium,
    PremiumEntitlement? entitlement,
  }) {
    if (!AppConstants.kEnableMockPurchases) return true;
    if (!contentIsPremium) return true;
    final active = entitlement ?? IapService.instance.getCurrentEntitlement();
    return active.isActive;
  }

  static bool hasAccessFromAppState(
    BuildContext context, {
    required bool contentIsPremium,
  }) {
    if (!AppConstants.kEnableMockPurchases) return true;
    if (!contentIsPremium) return true;
    return AppStateScope.of(context).isPremium;
  }

  /// Opens paywall when locked; returns true if user may proceed.
  static bool guardNavigation(
    BuildContext context, {
    required bool contentIsPremium,
  }) {
    if (!AppConstants.kEnableMockPurchases) return true;
    if (hasAccessFromAppState(context, contentIsPremium: contentIsPremium)) {
      return true;
    }
    AppRoutes.openPaywall(context);
    return false;
  }
}
