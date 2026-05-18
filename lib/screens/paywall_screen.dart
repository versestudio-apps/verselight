import 'package:flutter/material.dart';

import '../services/iap_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _yearly = true;
  bool _loading = false;

  static const _features = [
    ('Unlimited devotionals', Icons.menu_book_rounded),
    ('Audio Bible & devotionals', Icons.headphones_rounded),
    ('AI prayer prompts', Icons.auto_awesome_rounded),
    ('Reading plans & journal sync', Icons.cloud_sync_outlined),
  ];

  Future<void> _subscribe() async {
    setState(() => _loading = true);
    try {
      final sku = _yearly
          ? AppConstants.skuPremiumYearly
          : AppConstants.skuPremiumMonthly;
      await IapService.instance.purchase(sku);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Premium enabled (mock purchase)')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Premium'),
        actions: [
          TextButton(
            onPressed: () async {
              await IapService.instance.restorePurchases();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restore complete (mock)')),
              );
            },
            child: const Text('Restore'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.workspace_premium_rounded,
              size: 64, color: AppColors.premium),
          const SizedBox(height: 12),
          Text(
            'VerseLight Premium',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Deepen your daily walk with Scripture',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ..._features.map(
            (f) => ListTile(
              leading: Icon(f.$2, color: AppColors.sage),
              title: Text(f.$1),
              trailing: const Icon(Icons.check_circle_rounded,
                  color: AppColors.gold, size: 22),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PlanOption(
                  label: 'Monthly',
                  price: r'$2.99',
                  selected: !_yearly,
                  onTap: () => setState(() => _yearly = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PlanOption(
                  label: 'Yearly',
                  price: r'$19.99',
                  badge: 'Best value',
                  selected: _yearly,
                  onTap: () => setState(() => _yearly = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _subscribe,
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_yearly ? 'Start free trial (mock)' : 'Subscribe (mock)'),
          ),
          const SizedBox(height: 12),
          Text(
            'Purchases are simulated in this MVP. Connect Google Play or Amazon IAP before release.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.label,
    required this.price,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String label;
  final String price;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.goldSoft.withValues(alpha: 0.4) : AppColors.surface,
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
          child: Column(
            children: [
              if (badge != null)
                Text(
                  badge!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(price, style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
      ),
    );
  }
}
