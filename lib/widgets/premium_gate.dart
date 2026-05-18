import 'package:flutter/material.dart';

import '../utils/routes.dart';
import '../utils/theme.dart';
import 'app_state_scope.dart';
import 'soft_icon_badge.dart';

/// Wraps premium-only UI; taps open the paywall when not subscribed.
class PremiumGate extends StatelessWidget {
  const PremiumGate({
    super.key,
    required this.child,
    this.blurWhenLocked = true,
  });

  final Widget child;
  final bool blurWhenLocked;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        if (appState.isPremium) return child;

        return Stack(
          children: [
            if (blurWhenLocked)
              Opacity(opacity: 0.5, child: IgnorePointer(child: child))
            else
              child,
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => AppRoutes.openPaywall(context),
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppRadii.card),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SoftIconBadge(
                            icon: Icons.auto_awesome_rounded,
                            color: AppColors.warmGold,
                            size: 44,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Premium feature',
                            style:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to unlock with VerseLight Premium',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
