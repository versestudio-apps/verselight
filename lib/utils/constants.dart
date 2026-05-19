/// App-wide constants. No third-party LLM or provider secrets in the client.
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

  /// Master switch for the in-app purchase surface.
  ///
  /// When false (current default — Phase 09H):
  ///   - No Subscribe / Restore buttons are shown anywhere.
  ///   - No price labels are displayed.
  ///   - No "(mock)" / "(beta)" purchase copy is shown.
  ///   - The paywall shows a "Premium coming soon" teaser only.
  ///   - `PremiumAccess` / `PremiumGate` allow access to all content,
  ///     so users can use the full app while real billing isn't wired.
  ///
  /// When wiring real Amazon IAP / Google Play Billing in a later phase,
  /// either flip this to true and add the real SDK calls inside
  /// `IapService`, or replace this constant with a build-flavor check.
  /// All UI sites that branch on this flag can be found with
  /// `grep kEnableMockPurchases lib/`.
  static const bool kEnableMockPurchases = false;

  // TODO(store-ready): replace placeholder URLs/email with final values before
  // submitting to Google Play / Amazon Appstore.
  static const String privacyUrl =
      'https://versestudio-apps.github.io/privacy/';
  static const String termsUrl =
      'https://versestudio-apps.github.io/privacy/';
  static const String helpUrl =
      'https://versestudio-apps.github.io/privacy/#help';
  static const String supportEmail = 'support@example.com';

  static const int freeDevotionalLimit = 3;
}
