import 'package:flutter/material.dart';

import '../models/subscription_product.dart';
import '../services/iap_service.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/soft_icon_badge.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selectedProductId = SubscriptionProduct.yearly.id;
  bool _loading = false;
  List<SubscriptionProduct> _products = SubscriptionProduct.catalog;

  static const _features = [
    (
      'Unlock premium devotionals',
      'Hope, anxiety, faith & more — full library',
      Icons.menu_book_rounded,
      AppColors.warmGold,
    ),
    (
      'Guided reading plans',
      'Structured journeys through Scripture',
      Icons.route_rounded,
      AppColors.deepIndigo,
    ),
    (
      'Calming audio library',
      'Scripture and devotionals for quiet time',
      Icons.headphones_rounded,
      AppColors.softRose,
    ),
    (
      'Gentle AI prayer prompts',
      'Personalized reflection — coming later',
      Icons.auto_awesome_rounded,
      AppColors.sageGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await IapService.instance.getProducts();
    if (!mounted) return;
    setState(() => _products = products);
  }

  SubscriptionProduct get _selectedProduct =>
      SubscriptionProduct.byId(_selectedProductId) ??
      SubscriptionProduct.yearly;

  Future<void> _subscribe() async {
    setState(() => _loading = true);
    try {
      await IapService.instance.purchase(_selectedProductId);
      if (!mounted) return;
      await AppStateScope.of(context).onPremiumPurchased();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Premium unlocked (beta mock purchase)'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    final entitlement = await IapService.instance.restorePurchases();
    if (!mounted) return;
    await AppStateScope.of(context).refreshPremiumEntitlement();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          entitlement.isActive
              ? 'Purchases restored (beta)'
              : 'No active subscription found on this device',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('VerseLight Premium'),
        actions: [
          TextButton(onPressed: _restore, child: const Text('Restore')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.softCream,
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'BETA · mock billing only',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 11,
                  color: AppColors.slate,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF6E1),
                    Color(0xFFF5EFE3),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.goldTint),
                boxShadow: AppShadows.soft,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 38,
                color: AppColors.warmGold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Grow closer to God,\none day at a time',
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(height: 1.25),
          ),
          const SizedBox(height: 10),
          Text(
            'Gentle devotionals, plans, and audio for your faith journey.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          ..._features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SoftIconBadge(icon: f.$3, color: f.$4, size: 40),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.$1, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(f.$2, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.sageGreen,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._products.map((product) {
            final selected = product.id == _selectedProductId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProductCard(
                product: product,
                selected: selected,
                onTap: () => setState(() => _selectedProductId = product.id),
              ),
            );
          }),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _loading ? null : _subscribe,
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('Continue with ${_selectedProduct.title} (mock)'),
          ),
          const SizedBox(height: 14),
          Text(
            'No real charge in this beta. Google Play and Amazon Appstore billing '
            'will be enabled before public release.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final SubscriptionProduct product;
  final bool selected;
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
            color: selected
                ? AppColors.goldTint.withValues(alpha: 0.35)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: selected ? AppColors.warmGold : AppColors.border,
              width: selected ? 1.8 : 1,
            ),
            boxShadow: selected ? AppShadows.hairline : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selected ? AppColors.warmGold : AppColors.surface,
                    border: Border.all(
                      color: selected
                          ? AppColors.warmGold
                          : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.isBestValue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warmGold,
                            borderRadius:
                                BorderRadius.circular(AppRadii.pill),
                          ),
                          child: const Text(
                            'BEST VALUE',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      if (product.isBestValue) const SizedBox(height: 6),
                      Text(product.title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        product.trialLabel,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.priceLabel,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepNavy,
                      ),
                    ),
                    Text(
                      product.periodLabel,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
