import 'package:flutter/material.dart';

import '../utils/routes.dart';

/// Shared AppBar with friendly Premium + Settings actions.
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
            // auto_awesome reads as a gentle sparkle — friendlier than
            // the heraldic workspace_premium icon.
            icon: const Icon(Icons.auto_awesome_outlined),
            onPressed: () => AppRoutes.openPaywall(context),
          ),
        if (showSettings)
          IconButton(
            tooltip: 'Settings',
            // tune (sliders) feels lighter than the cog wheel.
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => AppRoutes.openSettings(context),
          ),
      ],
    );
  }
}
