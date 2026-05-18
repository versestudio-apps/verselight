import 'package:flutter/material.dart';

import '../services/affiliate_service.dart';
import '../utils/theme.dart';
import 'soft_icon_badge.dart';

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
        ? AppColors.deepIndigo
        : AppColors.warmGold;
    final icon = type == BannerType.audible
        ? Icons.headphones_rounded
        : Icons.menu_book_rounded;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.hairline,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SoftIconBadge(icon: icon, color: accent, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category != null) ...[
                        Text(
                          category!.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 10,
                            letterSpacing: 1.1,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.north_east_rounded,
                  size: 18,
                  color: AppColors.slate,
                ),
              ],
            ),
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
