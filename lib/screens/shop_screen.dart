import 'package:flutter/material.dart';

import '../services/affiliate_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Faith resources',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'As an Amazon Associate I earn from qualifying purchases.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Text('Books', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...AffiliateService.bibleBooks.map(
            (book) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AffiliateBanner(
                type: BannerType.amazonBook,
                asin: book['asin'],
                title: book['title']!,
                subtitle: '${book['price']} — Amazon →',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Audiobooks', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const AffiliateBanner(
            type: BannerType.audible,
            title: 'Audible free trial',
            subtitle: 'Bible & Christian audiobooks',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.parchment,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Affiliate tracking ID (placeholder): ${AppConstants.amazonTrackingId}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
