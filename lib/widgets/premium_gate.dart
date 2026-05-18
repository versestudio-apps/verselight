import 'package:flutter/material.dart';

import '../utils/routes.dart';
import '../utils/theme.dart';
import 'app_state_scope.dart';

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
              Opacity(opacity: 0.45, child: IgnorePointer(child: child))
            else
              child,
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => AppRoutes.openPaywall(context),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.goldSoft),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.workspace_premium_rounded,
                            color: AppColors.premium,
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Premium feature',
                            style: Theme.of(context).textTheme.titleMedium,
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
