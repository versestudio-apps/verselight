import 'package:flutter/material.dart';

import '../services/affiliate_service.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/app_section_header.dart';
import '../widgets/screen_app_bar.dart';
import '../widgets/soft_icon_badge.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'Shop', showSettings: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
        children: [
          Text(
            'Curated resources',
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 6),
          Text(
            'Books and audio we think may bless your walk.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          const _AffiliateDisclosure(),
          const SizedBox(height: 22),
          _ShopSectionHeader(
            icon: Icons.menu_book_rounded,
            color: AppColors.warmGold,
            title: 'Bible & devotionals',
          ),
          const SizedBox(height: 10),
          ...AffiliateService.bibleBooks.map(
            (book) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AffiliateBanner(
                type: BannerType.amazonBook,
                asin: book['asin'],
                category: 'Recommended',
                title: book['title']!,
                subtitle: '${book['price']} · View on Amazon',
              ),
            ),
          ),
          const SizedBox(height: 18),
          _ShopSectionHeader(
            icon: Icons.headphones_rounded,
            color: AppColors.deepIndigo,
            title: 'Listen & learn',
          ),
          const SizedBox(height: 10),
          const AffiliateBanner(
            type: BannerType.audible,
            category: 'Audiobooks',
            title: 'Audible free trial',
            subtitle: 'Bible, devotionals & Christian authors',
          ),
        ],
      ),
    );
  }
}

class _AffiliateDisclosure extends StatelessWidget {
  const _AffiliateDisclosure();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.softCream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }
}

class _ShopSectionHeader extends StatelessWidget {
  const _ShopSectionHeader({
    required this.icon,
    required this.color,
    required this.title,
  });

  final IconData icon;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SoftIconBadge(icon: icon, color: color, size: 30),
        const SizedBox(width: 10),
        AppSectionHeader(
          title: title,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
