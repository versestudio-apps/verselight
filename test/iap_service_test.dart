import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verselight/models/premium_entitlement.dart';
import 'package:verselight/models/subscription_product.dart';
import 'package:verselight/services/iap_service.dart';
import 'package:verselight/services/local_storage_service.dart';
import 'package:verselight/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.instance.initialize();
    await IapService.instance.clearEntitlement();
  });

  test('PremiumEntitlement.free is not active', () {
    final free = PremiumEntitlement.free();
    expect(free.isPremium, isFalse);
    expect(free.isActive, isFalse);
    expect(free.tier, PremiumEntitlement.tierFree);
  });

  test('mock purchase grants premium and persists', () async {
    final storage = LocalStorageService.instance;
    await storage.initialize();

    final iap = IapService.instance;
    await iap.clearEntitlement();

    final products = await iap.getProducts();
    expect(products.length, 2);
    expect(products.first.id, AppConstants.skuPremiumMonthly);

    final entitlement =
        await iap.purchase(AppConstants.skuPremiumYearly);
    expect(entitlement.isActive, isTrue);
    expect(entitlement.source, EntitlementSource.mock);
    expect(entitlement.planId, AppConstants.skuPremiumYearly);
    expect(iap.isPremium, isTrue);

    final reloaded = IapService.instance;
    await reloaded.initialize();
    expect(reloaded.getCurrentEntitlement().isActive, isTrue);
  });

  test('restore returns persisted entitlement without crash', () async {
    final storage = LocalStorageService.instance;
    await storage.initialize();
    await IapService.instance.purchase(AppConstants.skuPremiumMonthly);

    final fresh = IapService.instance;
    await fresh.initialize();
    final restored = await fresh.restorePurchases();
    expect(restored.isActive, isTrue);
  });

  test('unknown product throws IapException', () async {
    expect(
      IapService.instance.purchase('invalid_sku'),
      throwsA(isA<IapException>()),
    );
  });

  test('SubscriptionProduct catalog contains standard SKUs', () {
    expect(SubscriptionProduct.byId(AppConstants.skuPremiumMonthly), isNotNull);
    expect(SubscriptionProduct.byId(AppConstants.skuPremiumYearly), isNotNull);
  });
}
