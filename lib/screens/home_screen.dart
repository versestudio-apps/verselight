import 'package:flutter/material.dart';

import '../data/sample_devotionals.dart';
import '../models/devotional.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/verse_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Devotional get _today => sampleDevotionals.first;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VerseLight'),
        actions: [
          IconButton(
            tooltip: 'Premium',
            icon: const Icon(Icons.workspace_premium_outlined),
            onPressed: () => AppRoutes.openPaywall(context),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => AppRoutes.openSettings(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Text(_greeting(), style: theme.textTheme.displaySmall),
          const SizedBox(height: 4),
          Text(_formattedDate(), style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          _StreakCard(streakDays: appState.streakDays),
          const SizedBox(height: 20),
          VerseCard(
            title: "Today's focus",
            verseText: _today.verseText,
            verseRef: _today.verseRef,
            bodyPreview: _today.bodyPreview,
            onTap: () => AppRoutes.openDevotionalDetail(context, _today.id),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              appState.selectTab(1);
              AppRoutes.openDevotionalDetail(context, _today.id);
            },
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text("Read today's devotional"),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _QuickTile(
                  icon: Icons.menu_book_rounded,
                  label: 'Devotional',
                  color: AppColors.sageLight,
                  onTap: () => appState.selectTab(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickTile(
                  icon: Icons.edit_note_rounded,
                  label: 'Journal',
                  color: AppColors.goldSoft.withValues(alpha: 0.5),
                  onTap: () => appState.selectTab(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Plans',
                  color: AppColors.parchment,
                  onTap: () => appState.selectTab(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickTile(
                  icon: Icons.headphones_rounded,
                  label: 'Audio',
                  color: AppColors.sageLight.withValues(alpha: 0.7),
                  onTap: () => appState.selectTab(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Recommended', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          const AffiliateBanner(
            type: BannerType.amazonBook,
            asin: 'B07BDCNF2J',
            title: 'NIV Study Bible',
            subtitle: 'View on Amazon →',
          ),
          const SizedBox(height: 8),
          const AffiliateBanner(
            type: BannerType.audible,
            title: 'Listen on Audible',
            subtitle: 'Free trial — Bible & devotionals',
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _formattedDate() {
    final now = DateTime.now();
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streakDays});
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.parchment,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text('🔥', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streakDays day streak',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.gold,
                        ),
                  ),
                  Text(
                    'Keep showing up — grace meets consistency.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Icon(icon, color: AppColors.sage, size: 26),
              const SizedBox(height: 6),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
