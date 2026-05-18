import 'package:flutter/material.dart';

import '../services/affiliate_service.dart';
import '../utils/theme.dart';

enum BannerType { amazonBook, audible }

class AffiliateBanner extends StatelessWidget {
  const AffiliateBanner({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    this.asin,
    this.category,
  });

  final BannerType type;
  final String title;
  final String subtitle;
  final String? asin;
  final String? category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = type == BannerType.audible
        ? const Color(0xFF00A8E1)
        : AppColors.gold;

    return Card(
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  type == BannerType.audible
                      ? Icons.headphones_rounded
                      : Icons.menu_book_rounded,
                  color: accent,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (category != null) ...[
                      Text(
                        category!.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 10,
                          letterSpacing: 1,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.north_east_rounded,
                  size: 18, color: AppColors.warmBrownMuted),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    final service = AffiliateService.instance;
    switch (type) {
      case BannerType.amazonBook:
        if (asin != null) service.openAmazonProduct(asin!);
        break;
      case BannerType.audible:
        service.openAudibleTrial();
        break;
    }
  }
}
