import '../models/premium_entitlement.dart';
import '../models/subscription_product.dart';
import '../utils/constants.dart';
import 'local_storage_service.dart';

/// In-app purchase facade — mock/local today; Google Play / Amazon later.
///
/// Replace the private methods marked with TODO when wiring real store SDKs.
class IapService {
  IapService._();
  static final IapService instance = IapService._();

  final LocalStorageService _storage = LocalStorageService.instance;

  PremiumEntitlement _entitlement = PremiumEntitlement.free();

  /// Backward-compatible shortcut used across the app.
  bool get isPremium => getCurrentEntitlement().isActive;

  PremiumEntitlement getCurrentEntitlement() {
    if (_entitlement.isPremium &&
        _entitlement.expiresAt != null &&
        DateTime.now().isAfter(_entitlement.expiresAt!)) {
      return PremiumEntitlement.free();
    }
    return _entitlement;
  }

  Future<void> initialize() async {
    await _loadPersistedEntitlement();
  }

  Future<void> _loadPersistedEntitlement() async {
    final stored = await _storage.loadPremiumEntitlement();
    if (stored != null) {
      _entitlement = stored;
      return;
    }

    final legacyUnlocked = await _storage.loadPremiumUnlocked();
    if (legacyUnlocked) {
      _entitlement = PremiumEntitlement(
        isPremium: true,
        tier: PremiumEntitlement.tierPremium,
        planId: AppConstants.skuPremiumYearly,
        source: EntitlementSource.mock,
        updatedAt: DateTime.now(),
      );
      await _persistEntitlement(_entitlement);
    }
  }

  Future<List<SubscriptionProduct>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return SubscriptionProduct.catalog;
  }

  Future<PremiumEntitlement> purchase(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final product = SubscriptionProduct.byId(productId);
    if (product == null) {
      throw IapException('Unknown product: $productId');
    }

    final now = DateTime.now();
    final expiresAt = productId == AppConstants.skuPremiumYearly
        ? now.add(const Duration(days: 365))
        : now.add(const Duration(days: 30));

    _entitlement = PremiumEntitlement(
      isPremium: true,
      tier: PremiumEntitlement.tierPremium,
      planId: productId,
      source: EntitlementSource.mock,
      expiresAt: expiresAt,
      updatedAt: now,
    );

    await _persistEntitlement(_entitlement);
    return getCurrentEntitlement();
  }

  Future<PremiumEntitlement> restorePurchases() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    await _loadPersistedEntitlement();
    return getCurrentEntitlement();
  }

  Future<void> applyEntitlement(PremiumEntitlement entitlement) async {
    _entitlement = entitlement;
    await _persistEntitlement(_entitlement);
  }

  Future<void> clearEntitlement() async {
    _entitlement = PremiumEntitlement.free();
    await _persistEntitlement(_entitlement);
  }

  Future<void> _persistEntitlement(PremiumEntitlement entitlement) async {
    await _storage.savePremiumEntitlement(entitlement);
  }
}

class IapException implements Exception {
  IapException(this.message);
  final String message;

  @override
  String toString() => 'IapException: $message';
}
