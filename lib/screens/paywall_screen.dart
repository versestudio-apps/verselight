import 'package:flutter/material.dart';

import '../models/subscription_product.dart';
import '../services/iap_service.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';

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
    ),
    (
      'Guided reading plans',
      'Structured journeys through Scripture',
      Icons.calendar_today_rounded,
    ),
    (
      'Calming audio library',
      'Scripture and devotionals for quiet time',
      Icons.headphones_rounded,
    ),
    (
      'AI prayer prompts',
      'Personalized reflection — coming later',
      Icons.auto_awesome_outlined,
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
      SubscriptionProduct.byId(_selectedProductId) ?? SubscriptionProduct.yearly;

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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'BETA — mock billing only',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 11,
                  color: AppColors.gold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.workspace_premium_rounded,
              size: 56, color: AppColors.premium),
          const SizedBox(height: 12),
          Text(
            'Grow closer to God, one day at a time',
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Gentle devotionals and plans for your faith journey.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ..._features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(f.$3, color: AppColors.sage, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.$1, style: theme.textTheme.titleMedium),
                        Text(f.$2, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.gold, size: 20),
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
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _loading ? null : _subscribe,
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Continue with ${_selectedProduct.title} (mock)'),
          ),
          const SizedBox(height: 12),
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
      color: selected
          ? AppColors.goldSoft.withValues(alpha: 0.45)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.gold : AppColors.goldSoft,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.isBestValue)
                      Text(
                        'BEST VALUE',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 10,
                          color: AppColors.gold,
                          letterSpacing: 1,
                        ),
                      ),
                    Text(product.title, style: theme.textTheme.titleMedium),
                    Text(
                      product.trialLabel,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                product.priceLabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product.periodLabel,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
