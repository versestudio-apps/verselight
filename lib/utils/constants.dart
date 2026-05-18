/// App-wide constants. No real API keys — use dart-define or remote config later.
class AppConstants {
  AppConstants._();

  static const String appName = 'VerseLight';
  static const String appPackage = 'com.versestudio.verselight';
  static const String appVersion = '1.0.0';

  /// Amazon Associates tracking ID — replace after Associates approval.
  static const String amazonTrackingId = 'verselight-placeholder-20';

  static String amazonProductUrl(String asin) =>
      'https://www.amazon.com/dp/$asin?tag=$amazonTrackingId';

  static const String audibleTrialUrl =
      'https://www.amazon.com/hz/audible/mlp/membership/prime?tag=$amazonTrackingId';

  static const String skuPremiumMonthly = 'verselight_premium_monthly';
  static const String skuPremiumYearly = 'verselight_premium_yearly';

  static const String privacyUrl =
      'https://versestudio-apps.github.io/privacy/';
  static const String supportEmail = 'support@example.com';

  static const int freeDevotionalLimit = 3;
}
