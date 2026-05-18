import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/premium_entitlement.dart';
import '../services/iap_service.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final entitlement = appState.premiumEntitlement;
          final isPremium = entitlement.isActive;

          return ListView(
            children: [
              const _SectionLabel('Premium'),
              ListTile(
                leading: Icon(
                  isPremium
                      ? Icons.workspace_premium_rounded
                      : Icons.workspace_premium_outlined,
                  color: isPremium ? AppColors.premium : AppColors.warmBrownMuted,
                ),
                title: Text(isPremium ? 'VerseLight Premium' : 'Free plan'),
                subtitle: Text(
                  isPremium
                      ? _premiumSubtitle(entitlement)
                      : 'Unlock devotionals, plans & audio',
                ),
                isThreeLine: isPremium && entitlement.expiresAt != null,
                trailing: isPremium
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.sage)
                    : const Icon(Icons.chevron_right_rounded),
                onTap: isPremium
                    ? null
                    : () => AppRoutes.openPaywall(context),
              ),
              if (!isPremium)
                ListTile(
                  leading: const Icon(Icons.upgrade_rounded, color: AppColors.gold),
                  title: const Text('Upgrade to Premium'),
                  onTap: () => AppRoutes.openPaywall(context),
                ),
              ListTile(
                leading: const Icon(Icons.restore_rounded),
                title: const Text('Restore purchases'),
                subtitle: const Text('Beta mock — checks saved entitlement'),
                onTap: () => _restorePurchases(context),
              ),
              const _SectionLabel('App'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Daily reminder'),
                subtitle: const Text('Coming soon'),
                value: true,
                onChanged: (_) {},
                activeThumbColor: AppColors.gold,
              ),
              const _SectionLabel('Support'),
              ListTile(
                leading: const Icon(Icons.help_outline_rounded),
                title: const Text('Help & FAQ'),
                subtitle: const Text('Common questions and how-tos'),
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () => launchUrl(Uri.parse(AppConstants.helpUrl)),
              ),
              ListTile(
                leading: const Icon(Icons.mail_outline_rounded),
                title: const Text('Contact support'),
                subtitle: Text(AppConstants.supportEmail),
                onTap: () => launchUrl(
                  Uri.parse('mailto:${AppConstants.supportEmail}'),
                ),
              ),
              const _SectionLabel('Data'),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.warmBrownMuted),
                title: const Text('Reset local data'),
                subtitle: const Text(
                  'Clears journal, entitlement, plans, devotionals & audio',
                ),
                onTap: () => _confirmReset(context),
              ),
              const _SectionLabel('Legal'),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy policy'),
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () => launchUrl(Uri.parse(AppConstants.privacyUrl)),
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of use'),
                subtitle: const Text('Placeholder — update before launch'),
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () => launchUrl(Uri.parse(AppConstants.termsUrl)),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'As an Amazon Associate I earn from qualifying purchases.',
                  style: TextStyle(fontSize: 12, color: AppColors.warmBrownMuted),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    '${AppConstants.appName} v${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _premiumSubtitle(PremiumEntitlement entitlement) {
    final parts = <String>[entitlement.sourceLabel];
    if (entitlement.planId != null) {
      parts.add(entitlement.planId!);
    }
    var text = parts.join(' · ');
    if (entitlement.expiresAt != null) {
      text += '\nRenews ${_formatDate(entitlement.expiresAt!)}';
    }
    return text;
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year}';
  }
}

Future<void> _restorePurchases(BuildContext context) async {
  final entitlement = await IapService.instance.restorePurchases();
  if (!context.mounted) return;
  await AppStateScope.of(context).refreshPremiumEntitlement();
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        entitlement.isActive
            ? 'Restored: ${entitlement.sourceLabel}'
            : 'No active subscription on this device',
      ),
    ),
  );
}

Future<void> _confirmReset(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reset local data?'),
      content: const Text(
        'This removes saved journal notes, premium entitlement, reading plan '
        'progress, completed devotionals, and audio playback on this device.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Reset'),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  await AppStateScope.of(context).resetAllLocalData();
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Local data reset')),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.gold,
              letterSpacing: 1.2,
              fontSize: 11,
            ),
      ),
    );
  }
}
