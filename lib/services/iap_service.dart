import '../utils/constants.dart';
import 'local_storage_service.dart';

/// Mock in-app purchase service.
/// Replace with Google Play Billing / Amazon IAP when store accounts are ready.
class IapService {
  IapService._();
  static final IapService instance = IapService._();

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future<void> initialize() async {
    // Premium flag is restored via AppState.loadFromStorage (Phase 02).
  }

  Future<bool> purchase(String sku) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (sku == AppConstants.skuPremiumMonthly ||
        sku == AppConstants.skuPremiumYearly) {
      _isPremium = true;
      await LocalStorageService.instance.savePremiumUnlocked(true);
      return true;
    }
    throw IapException('Unknown SKU: $sku');
  }

  Future<void> restorePurchases() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final restored = await LocalStorageService.instance.loadPremiumUnlocked();
    _isPremium = restored;
  }

  void setPremiumForDemo(bool value) => _isPremium = value;
}

class IapException implements Exception {
  IapException(this.message);
  final String message;

  @override
  String toString() => 'IapException: $message';
}
