import 'package:flutter/material.dart';

import '../data/sample_devotionals.dart';
import '../models/devotional.dart';
import '../utils/constants.dart';
import '../utils/devotional_images.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/app_section_header.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/daily_verse_card.dart';
import '../widgets/soft_icon_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Devotional get _today => todayDevotional();

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
          if (AppConstants.kEnableMockPurchases)
            IconButton(
              tooltip: 'Premium',
              icon: const Icon(Icons.auto_awesome_outlined),
              onPressed: () => AppRoutes.openPaywall(context),
            ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => AppRoutes.openSettings(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
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
              const SizedBox(height: 18),
              _StreakCard(streakDays: appState.streakDays),
              const SizedBox(height: 26),
              const AppSectionHeader(title: "Today's devotional"),
              DailyVerseCard(
                title: today.title,
                verseText: today.verseText,
                verseRef: today.verseRef,
                preview: today.bodyPreview,
                imagePath:
                    DevotionalImages.forDevotionalCategory(today.category),
                isCompleted: completed,
                onTap: () =>
                    AppRoutes.openDevotionalDetail(context, today.id),
                onRead: () {
                  appState.selectTab(1);
                  AppRoutes.openDevotionalDetail(context, today.id);
                },
              ),
              const SizedBox(height: 26),
              const AppSectionHeader(title: 'Quick access'),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.menu_book_rounded,
                      color: AppColors.warmGold,
                      label: 'Devotional',
                      subtitle: 'Daily readings',
                      onTap: () => appState.selectTab(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.favorite_rounded,
                      color: AppColors.sageGreen,
                      label: 'Journal',
                      subtitle: 'Prayer notes',
                      onTap: () => appState.selectTab(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.route_rounded,
                      color: AppColors.deepIndigo,
                      label: 'Plans',
                      subtitle: 'Bible journeys',
                      onTap: () => appState.selectTab(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppConstants.kEnableAudioTab
                        ? _QuickAction(
                            icon: Icons.headphones_rounded,
                            color: AppColors.softRose,
                            label: 'Audio',
                            subtitle: 'Listen & reflect',
                            onTap: () => appState.selectTab(4),
                          )
                        : _QuickAction(
                            icon: Icons.storefront_rounded,
                            color: AppColors.softRose,
                            label: 'Shop',
                            subtitle: 'Curated resources',
                            // With Audio hidden, Shop shifts from index 5 to 4.
                            onTap: () => appState.selectTab(4),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (AppConstants.kEnableMockPurchases &&
                  !appState.isPremium) ...[
                _GentlePremiumCta(
                  onTap: () => AppRoutes.openPaywall(context),
                ),
                const SizedBox(height: 26),
              ],
              const AppSectionHeader(
                title: 'Curated for you',
                subtitle: 'Hand-picked resources to deepen your walk',
              ),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 18, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.softCream, AppColors.ivory],
        ),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SoftIconBadge(
            icon: Icons.local_fire_department_rounded,
            color: AppColors.softRose,
            size: 44,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streakDays == 1
                      ? '1-day streak'
                      : '$streakDays-day streak',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'A quiet moment with God counts.',
                  style: theme.textTheme.bodySmall,
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
    required this.color,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.hairline,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftIconBadge(icon: icon, color: color, size: 40),
                const SizedBox(height: 12),
                Text(label, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GentlePremiumCta extends StatelessWidget {
  const _GentlePremiumCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.card),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF6E1),
                Color(0xFFFAF7F0),
              ],
            ),
            border: Border.all(color: AppColors.goldTint),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const SoftIconBadge(
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.warmGold,
                  size: 48,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Go deeper with Premium',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Full devotionals, plans & audio — gently unlock when ready.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.warmGold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
