import 'package:flutter/material.dart';

import '../data/sample_devotionals.dart';
import '../models/devotional.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/daily_verse_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Devotional get _today => sampleDevotionals.first;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final theme = Theme.of(context);
    final today = _today;
    final completed = appState.isDevotionalCompleted(today.id);

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
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            children: [
              Text(
                _greeting(),
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 4),
              Text(
                _formattedDate(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),
              _StreakCard(streakDays: appState.streakDays),
              const SizedBox(height: 22),
              Text(
                "Today's devotional",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              DailyVerseCard(
                title: today.title,
                verseText: today.verseText,
                verseRef: today.verseRef,
                preview: today.bodyPreview,
                isCompleted: completed,
                onTap: () =>
                    AppRoutes.openDevotionalDetail(context, today.id),
                onRead: () {
                  appState.selectTab(1);
                  AppRoutes.openDevotionalDetail(context, today.id);
                },
              ),
              const SizedBox(height: 22),
              Text('Quick access', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.menu_book_rounded,
                      label: 'Devotional',
                      subtitle: 'Daily readings',
                      onTap: () => appState.selectTab(1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.edit_note_rounded,
                      label: 'Journal',
                      subtitle: 'Prayer notes',
                      onTap: () => appState.selectTab(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.calendar_today_rounded,
                      label: 'Plans',
                      subtitle: 'Bible journeys',
                      onTap: () => appState.selectTab(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.headphones_rounded,
                      label: 'Audio',
                      subtitle: 'Listen & reflect',
                      onTap: () => appState.selectTab(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Curated for you',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Hand-picked resources to deepen your walk',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              const AffiliateBanner(
                type: BannerType.amazonBook,
                asin: 'B07BDCNF2J',
                category: 'Staff pick',
                title: 'NIV Study Bible',
                subtitle: 'Trusted study edition · Amazon',
              ),
              const SizedBox(height: 10),
              const AffiliateBanner(
                type: BannerType.audible,
                category: 'Listen',
                title: 'Audible — faith audiobooks',
                subtitle: 'Free trial · Listen on the go',
              ),
            ],
          );
        },
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.parchment.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streakDays-day streak',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.gold,
                      ),
                ),
                Text(
                  'A quiet moment with God counts.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.goldSoft.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.sage, size: 24),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
