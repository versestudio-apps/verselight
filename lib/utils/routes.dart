import 'package:flutter/material.dart';

import '../screens/paywall_screen.dart';
import '../screens/settings_screen.dart';

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
}
