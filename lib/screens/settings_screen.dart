import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionLabel('Account'),
          ListTile(
            leading: const Icon(Icons.workspace_premium_rounded,
                color: AppColors.premium),
            title: const Text('VerseLight Premium'),
            subtitle: const Text('Unlock devotionals, audio & more'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => AppRoutes.openPaywall(context),
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
            onTap: () =>
                launchUrl(Uri.parse('mailto:${AppConstants.supportEmail}')),
          ),
          const _SectionLabel('Data'),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded,
                color: AppColors.warmBrownMuted),
            title: const Text('Reset local data'),
            subtitle: const Text(
              'Clears journal, premium mock, plans, devotionals & audio',
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
      ),
    );
  }
}

Future<void> _confirmReset(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reset local data?'),
      content: const Text(
        'This removes saved journal notes, premium unlock, reading plan '
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
