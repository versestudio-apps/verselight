import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/premium_entitlement.dart';
import '../services/iap_service.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/soft_icon_badge.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final entitlement = appState.premiumEntitlement;
          final isPremium = entitlement.isActive;

          final showIapUi = AppConstants.kEnableMockPurchases;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              if (showIapUi) ...[
                _PremiumStatusCard(
                  isPremium: isPremium,
                  entitlement: entitlement,
                  onUpgrade: () => AppRoutes.openPaywall(context),
                ),
                const SizedBox(height: 22),
              ],
              const _SectionLabel('App'),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                color: AppColors.deepIndigo,
                title: 'Daily reminder',
                subtitle: 'Coming soon',
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeThumbColor: AppColors.warmGold,
                ),
              ),
              if (showIapUi)
                _SettingsTile(
                  icon: Icons.restore_rounded,
                  color: AppColors.sageGreen,
                  title: 'Restore purchases',
                  subtitle: 'Beta mock — checks saved entitlement',
                  onTap: () => _restorePurchases(context),
                ),
              const SizedBox(height: 18),
              const _SectionLabel('Support'),
              // Help tile is gated behind kEnableHelpLink (Phase 09R) —
              // hidden until a real Help/FAQ page exists. See constants.dart.
              if (AppConstants.kEnableHelpLink)
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  color: AppColors.warmGold,
                  title: 'Help & FAQ',
                  subtitle: 'Common questions and how-tos',
                  onTap: () => launchUrl(Uri.parse(AppConstants.helpUrl)),
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: AppColors.slate,
                  ),
                ),
              _SettingsTile(
                icon: Icons.mail_outline_rounded,
                color: AppColors.softRose,
                title: 'Contact support',
                subtitle: AppConstants.supportEmail,
                onTap: () => launchUrl(
                  Uri.parse('mailto:${AppConstants.supportEmail}'),
                ),
              ),
              const SizedBox(height: 18),
              const _SectionLabel('Legal'),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                color: AppColors.deepIndigo,
                title: 'Privacy policy',
                onTap: () => launchUrl(Uri.parse(AppConstants.privacyUrl)),
                trailing: const Icon(
                  Icons.open_in_new_rounded,
                  size: 16,
                  color: AppColors.slate,
                ),
              ),
              // Terms tile is gated behind kEnableTermsLink (Phase 09R) —
              // hidden until a standalone Terms of Use page exists. The
              // previous tile opened the Privacy URL with a "Placeholder —
              // update before launch" subtitle which would confuse a store
              // reviewer; hiding is safer than mis-routing.
              if (AppConstants.kEnableTermsLink)
                _SettingsTile(
                  icon: Icons.description_outlined,
                  color: AppColors.deepIndigo,
                  title: 'Terms of use',
                  onTap: () => launchUrl(Uri.parse(AppConstants.termsUrl)),
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: AppColors.slate,
                  ),
                ),
              const SizedBox(height: 18),
              const _SectionLabel('Data'),
              _SettingsTile(
                icon: Icons.delete_outline_rounded,
                color: AppColors.softRose,
                title: 'Reset local data',
                subtitle:
                    'Clears journal, entitlement, plans, devotionals & audio',
                onTap: () => _confirmReset(context),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: AppColors.softCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: AppColors.slate,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'As an Amazon Associate, VerseLight may earn from qualifying purchases.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.slate,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  '${AppConstants.appName} v${AppConstants.appVersion}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PremiumStatusCard extends StatelessWidget {
  const _PremiumStatusCard({
    required this.isPremium,
    required this.entitlement,
    required this.onUpgrade,
  });

  final bool isPremium;
  final PremiumEntitlement entitlement;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPremium
              ? const [Color(0xFFFFF6E1), AppColors.softCream]
              : const [AppColors.surface, AppColors.softCream],
        ),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(
          color: isPremium ? AppColors.goldTint : AppColors.border,
        ),
        boxShadow: AppShadows.hairline,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SoftIconBadge(
            icon: isPremium
                ? Icons.auto_awesome_rounded
                : Icons.auto_awesome_outlined,
            color: AppColors.warmGold,
            size: 48,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPremium ? 'VerseLight Premium' : 'Free plan',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  isPremium
                      ? _premiumSubtitle(entitlement)
                      : 'Unlock devotionals, plans & audio',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isPremium)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.sageGreen,
            )
          else
            FilledButton(
              onPressed: onUpgrade,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                textStyle: const TextStyle(fontSize: 13),
              ),
              child: const Text('Upgrade'),
            ),
        ],
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
      text += ' · Renews ${_formatDate(entitlement.expiresAt!)}';
    }
    return text;
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year}';
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  SoftIconBadge(icon: icon, color: color, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.titleSmall),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  trailing ??
                      (onTap != null
                          ? const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.slate,
                            )
                          : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.slate,
              letterSpacing: 1.3,
              fontSize: 11,
            ),
      ),
    );
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
