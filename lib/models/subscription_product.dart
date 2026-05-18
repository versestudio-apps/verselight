import '../utils/constants.dart';

/// Store-agnostic subscription SKU metadata (not a secret).
class SubscriptionProduct {
  const SubscriptionProduct({
    required this.id,
    required this.title,
    required this.priceLabel,
    required this.periodLabel,
    required this.trialLabel,
    this.isBestValue = false,
  });

  final String id;
  final String title;
  final String priceLabel;
  final String periodLabel;
  final String trialLabel;
  final bool isBestValue;

  static const monthly = SubscriptionProduct(
    id: AppConstants.skuPremiumMonthly,
    title: 'Monthly',
    priceLabel: r'$2.99',
    periodLabel: '/ month',
    trialLabel: '7-day free trial',
  );

  static const yearly = SubscriptionProduct(
    id: AppConstants.skuPremiumYearly,
    title: 'Yearly',
    priceLabel: r'$19.99',
    periodLabel: '/ year',
    trialLabel: '7-day free trial',
    isBestValue: true,
  );

  static const List<SubscriptionProduct> catalog = [monthly, yearly];

  static SubscriptionProduct? byId(String id) {
    for (final p in catalog) {
      if (p.id == id) return p;
    }
    return null;
  }
}
