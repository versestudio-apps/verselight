import '../utils/constants.dart';

/// Mock in-app purchase service.
/// Replace with Google Play Billing / Amazon IAP when store accounts are ready.
class IapService {
  IapService._();
  static final IapService instance = IapService._();

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future<void> initialize() async {
    // TODO: Google Play Billing or Amazon IAP SDK via platform channel.
  }

  Future<bool> purchase(String sku) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (sku == AppConstants.skuPremiumMonthly ||
        sku == AppConstants.skuPremiumYearly) {
      _isPremium = true;
      return true;
    }
    throw IapException('Unknown SKU: $sku');
  }

  Future<void> restorePurchases() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    // Mock: no restored purchases in skeleton.
  }

  void setPremiumForDemo(bool value) => _isPremium = value;
}

class IapException implements Exception {
  IapException(this.message);
  final String message;

  @override
  String toString() => 'IapException: $message';
}
