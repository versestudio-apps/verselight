import 'package:flutter/material.dart';

import '../services/affiliate_service.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/screen_app_bar.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'Shop', showSettings: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Curated recommendations',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Books and audio we think may bless your walk. '
            'As an Amazon Associate we earn from qualifying purchases.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _ShopSectionHeader(
            icon: Icons.menu_book_rounded,
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
          const SizedBox(height: 20),
          const _ShopSectionHeader(
            icon: Icons.headphones_rounded,
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

class _ShopSectionHeader extends StatelessWidget {
  const _ShopSectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
