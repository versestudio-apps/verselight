import 'package:flutter/material.dart';

import '../utils/routes.dart';

/// Shared AppBar actions: Premium + Settings (Phase 01).
class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScreenAppBar({
    super.key,
    required this.title,
    this.showPremium = true,
    this.showSettings = true,
  });

  final String title;
  final bool showPremium;
  final bool showSettings;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        if (showPremium)
          IconButton(
            tooltip: 'Premium',
            icon: const Icon(Icons.workspace_premium_outlined),
            onPressed: () => AppRoutes.openPaywall(context),
          ),
        if (showSettings)
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => AppRoutes.openSettings(context),
          ),
      ],
    );
  }
}
