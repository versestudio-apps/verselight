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
  });

  final BannerType type;
  final String title;
  final String subtitle;
  final String? asin;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (type == BannerType.audible
                          ? const Color(0xFF00A8E1)
                          : AppColors.gold)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  type == BannerType.audible
                      ? Icons.headphones_rounded
                      : Icons.menu_book_rounded,
                  color: type == BannerType.audible
                      ? const Color(0xFF00A8E1)
                      : AppColors.gold,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gold,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: AppColors.warmBrownMuted,
              ),
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
