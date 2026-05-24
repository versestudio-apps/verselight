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

  /// Master switch for the Audio tab.
  ///
  /// When false (Phase 09J default): the Audio tab is removed from the bottom
  /// navigation and from the Home quick-access grid. The mock `AudioScreen`,
  /// `sample_audio.dart`, and `AudioTrack` model are intentionally kept in
  /// the codebase so this flag can flip back when real playback is wired
  /// (e.g. via `just_audio`) with bundled or streamed audio assets.
  ///
  /// When wiring real audio later:
  ///   1. Add `just_audio` (or `audioplayers`) to pubspec.
  ///   2. Bundle / stream audio assets for the 4 sample tracks (or replace).
  ///   3. Replace `_onPlay` in `AudioScreen` to drive the real player.
  ///   4. Flip this flag to true.
  static const bool kEnableAudioTab = false;

  /// Master switch for the Shop tab + affiliate banner surface.
  ///
  /// When false (Phase 09Q default): the Shop tab is removed from bottom
  /// navigation, the Shop quick-access tile on Home is replaced by a Settings
  /// tile, the "Curated for you" section on Home is hidden entirely, and the
  /// Audible banner at the end of the Devotional list is hidden. With the
  /// flag off, no UI surface in the app routes a user to an Amazon affiliate
  /// URL, so dead ASINs cannot be hit by a store reviewer or end user.
  ///
  /// Rationale (Phase 09Q): Fire Tablet QA (Phase 09P) verified all 4 ASINs
  /// in `AffiliateService.bibleBooks` return 404 from Amazon. Shipping the
  /// Shop surface with dead links would fail Amazon Appstore review and
  /// breach the Amazon Associates Operating Agreement (linking to products
  /// the operator has not verified exist).
  ///
  /// `ShopScreen`, `AffiliateService`, `AffiliateBanner`, and the ASIN list
  /// in `affiliate_service.dart` are intentionally kept so this flag can flip
  /// back to true in one line once the ASINs are replaced with live products
  /// and the Amazon Associates tag is wired.
  ///
  /// Re-enable checklist (before flipping to true):
  ///   1. Replace each ASIN in `lib/services/affiliate_service.dart` with a
  ///      live Amazon product id. Verify each with
  ///      `curl -s -o /dev/null -L -w "%{http_code}" https://www.amazon.com/dp/<ASIN>`
  ///      and confirm 200.
  ///   2. Replace `amazonTrackingId` placeholder with the real approved
  ///      Amazon Associates tag.
  ///   3. Sanity-check the live shop on a fresh emulator install.
  static const bool kEnableShopTab = false;

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
