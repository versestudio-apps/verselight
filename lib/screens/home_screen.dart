import 'package:flutter/material.dart';

import '../data/sample_devotionals.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/verse_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _featured = sampleDevotionals.first;

  @override
  Widget build(BuildContext context) {
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
          Text(
            _greeting(),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 4),
          Text(
            _formattedDate(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          VerseCard(
            title: "Today's focus",
            verseText: _featured.verseText,
            verseRef: _featured.verseRef,
            bodyPreview: _featured.bodyPreview,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickTile(
                  icon: Icons.menu_book_rounded,
                  label: 'Devotional',
                  color: AppColors.sageLight,
                  onTap: () => _hintSwitchTab(context, 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickTile(
                  icon: Icons.edit_note_rounded,
                  label: 'Journal',
                  color: AppColors.goldSoft.withValues(alpha: 0.5),
                  onTap: () => _hintSwitchTab(context, 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Recommended',
            style: Theme.of(context).textTheme.titleLarge,
          ),
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
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  void _hintSwitchTab(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Use the bottom bar — tab ${index + 1}'),
        duration: const Duration(seconds: 2),
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, color: AppColors.sage, size: 28),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
