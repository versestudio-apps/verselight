# VerseLight — Phase 09H IAP Risk Resolution

> Audit + remediation of the Phase 09E store-blocker #2: VerseLight had a fully
> mock in-app purchase surface (Subscribe / Restore / prices / "(mock)" copy)
> that could mislead Amazon reviewers and beta testers into thinking real
> billing exists. Phase 09H gates that surface behind a single feature flag,
> defaulted off, so the store build shows no purchase UI while leaving the
> mock code in place for later dev testing and easy revert when real IAP is
> wired.

## Status summary

| Item                                                | Status |
|-----------------------------------------------------|--------|
| Mock Subscribe / Restore / prices visible in app    | ❌ Removed (flag off by default) |
| Mock purchase persists fake entitlement on tap      | ❌ Unreachable in store build |
| Premium-locked content blocking users               | ✅ All content accessible (gate bypassed) |
| `IapService` mock code preserved for later use      | ✅ Untouched — tests still pass |
| Single switch to re-enable for dev / wire real IAP  | ✅ `AppConstants.kEnableMockPurchases` |
| Real Amazon IAP / Play Billing SDK wired            | ❌ Out of scope (Phase 09H+) |

## Chosen approach: C (feature flag) + A (UI neutralization)

A combined approach because either alone has a gap:

- **C alone (feature flag only)** would leave the purchase UI visible but the
  flag would just decide what happens when buttons get tapped — Amazon
  reviewers would still see Subscribe/Restore and "(mock)" copy.
- **A alone (rewrite all paywall copy)** would change strings everywhere but
  keep the mock purchase code path live, with no clean way to revert when
  real IAP arrives.

Combining them: one `bool kEnableMockPurchases` constant in `AppConstants`
controls every IAP-surface branch. When false:

- All Subscribe / Restore / price / "BETA mock billing" UI is **hidden**, not
  just relabelled.
- `PremiumGate` and `PremiumAccess` short-circuit so **all** premium-marked
  content is accessible — the app is fully usable without billing.
- The paywall screen survives as a **"Coming soon" teaser** advertising the
  upcoming feature set (header + hero + feature list), with no buttons and no
  prices.

When wiring real Amazon IAP later, flip the flag to `true` and replace the
TODO methods inside `IapService` — no UI surgery required.

## Files changed

### Source — feature flag + behavior

| File                                  | Change                                                                 |
|---------------------------------------|------------------------------------------------------------------------|
| [lib/utils/constants.dart](../../../lib/utils/constants.dart)               | Added `kEnableMockPurchases = false` with doc comment explaining the master switch and how to re-enable. |
| [lib/utils/premium_access.dart](../../../lib/utils/premium_access.dart)     | `hasAccess`, `hasAccessFromAppState`, `guardNavigation` all return `true` immediately when flag is off. |
| [lib/widgets/premium_gate.dart](../../../lib/widgets/premium_gate.dart)     | When flag is off, returns `child` directly (no overlay, no blur). |

### Source — UI hides / copy changes

| File                                  | Change                                                                 |
|---------------------------------------|------------------------------------------------------------------------|
| [lib/screens/paywall_screen.dart](../../../lib/screens/paywall_screen.dart) | When flag off: hides AppBar Restore action; replaces "BETA · mock billing only" badge with "COMING SOON"; hides product price cards; hides Subscribe button; replaces beta disclaimer with "Premium features and subscription will be available in a future update — every devotional, plan, and audio piece you see today is already yours to use, free of charge." Skips `_loadProducts()` in `initState`. |
| [lib/screens/settings_screen.dart](../../../lib/screens/settings_screen.dart) | When flag off: hides `_PremiumStatusCard` entirely (no "Free plan / Upgrade" CTA); hides "Restore purchases" tile. |
| [lib/screens/home_screen.dart](../../../lib/screens/home_screen.dart) | When flag off: hides AppBar Premium IconButton; hides `_GentlePremiumCta` card. |
| [lib/screens/audio_screen.dart](../../../lib/screens/audio_screen.dart) | Drops `(mock)` prefix from playing snackbar — now just `Playing: <title>`. (Audio is still a mock UI; that's tracked separately in [09E KNOWN_ISSUES #5](../phase-09e-amazon-readiness/KNOWN_ISSUES.md).) |
| [lib/widgets/verse_card.dart](../../../lib/widgets/verse_card.dart)         | Premium badge pill on devotional cards is suppressed when flag off. |
| [lib/widgets/reading_plan_card.dart](../../../lib/widgets/reading_plan_card.dart) | Premium badge pill on plan cards is suppressed when flag off. |

### Source — intentionally **not** touched

| File                                              | Why                                              |
|---------------------------------------------------|--------------------------------------------------|
| [lib/services/iap_service.dart](../../../lib/services/iap_service.dart) | Mock purchase logic preserved for tests + future flag-on dev work. |
| [lib/models/premium_entitlement.dart](../../../lib/models/premium_entitlement.dart) | Entitlement model unchanged; tests depend on it; `EntitlementSource.mock` still valid. |
| [lib/models/subscription_product.dart](../../../lib/models/subscription_product.dart) | Catalog ($2.99/$19.99) preserved for when real IAP is wired — values will be replaced by store-fetched products then. |
| `lib/services/local_storage_service.dart`        | Premium persistence keys preserved; harmless when flag off. |
| `test/iap_service_test.dart`                     | All 5 tests still pass without modification — `IapService` API unchanged. |

## What the user sees in a store build (flag=false)

- **Home** — VerseLight title, greeting, streak, today's devotional, quick
  actions, curated affiliate banners. **No** "Go deeper with Premium" CTA,
  **no** Premium icon button in the app bar.
- **Devotional list** — all entries open directly. **No** "Premium" badge on
  any card.
- **Devotional detail** — all content readable.
- **Plans list** — all plans open directly. **No** "Premium" badge.
- **Plan detail** — all days readable.
- **Audio** — all tracks play (still UI-only mock playback; documented).
  Snackbar reads "Playing: \<title\>" — no "(mock)" label.
- **Journal** — unchanged.
- **Shop** — unchanged (affiliate banners).
- **Settings** — App + Support + Legal sections only. **No** premium status
  card, **no** Restore purchases tile.
- **Paywall route** (only reachable via deep link / dev menu if any) — opens
  to a "COMING SOON" teaser: hero image, feature list, and the line *"Premium
  features and subscription will be available in a future update — every
  devotional, plan, and audio piece you see today is already yours to use,
  free of charge."*

## Production risk after Phase 09H

| Risk                                                          | Status |
|---------------------------------------------------------------|--------|
| Visible "BETA · mock billing only" badge                      | ✅ Removed (reads "COMING SOON" if paywall opened) |
| Visible "Subscribe (mock)" / "Restore" buttons                | ✅ Hidden |
| Visible prices ($2.99/month, $19.99/year)                     | ✅ Hidden |
| `(beta)` / `(mock)` snackbar copy reaching the user           | ✅ Removed from user flows |
| Premium-locked content with no purchase path                  | ✅ Resolved — content unlocked |
| Tester accidentally "buying" mock subscription                | ✅ Impossible — no Subscribe UI |
| Amazon reviewer flagging "advertised feature does not work"   | ✅ No subscription is advertised |

→ **Phase 09E store-blocker #2 (IAP mock) is resolved for store-submission
purposes.** The store build no longer advertises subscription as a buyable
feature, while preserving the full IAP code path for when real billing is wired.

## When to wire real Amazon IAP (future Phase 09H+ / 09I+)

Trigger checklist:

- [ ] Amazon Developer console: create In-App Items / Subscriptions for SKUs
      `verselight_premium_monthly` and `verselight_premium_yearly` (matching
      [`AppConstants.skuPremiumMonthly` / `skuPremiumYearly`](../../../lib/utils/constants.dart)).
- [ ] Decide pricing (current $2.99 / $19.99 placeholders or new tiers).
- [ ] Add Amazon IAP integration (no official Flutter plugin — needs a
      platform channel to Amazon's IAP v2 SDK), or add `in_app_purchase`
      Flutter package + Google Play Billing if launching on Play simultaneously.
- [ ] Replace the TODO methods inside [`lib/services/iap_service.dart`](../../../lib/services/iap_service.dart) to call
      the real SDK in `purchase(productId)` and `restorePurchases()` instead
      of synthesizing a local `PremiumEntitlement`.
- [ ] Add `android.permission.INTERNET` to release manifest (currently only
      in debug/profile — see [09E KNOWN_ISSUES #3](../phase-09e-amazon-readiness/KNOWN_ISSUES.md)).
- [ ] Flip `AppConstants.kEnableMockPurchases` to `true` (or replace with a
      build-flavor check that's true for store builds, false elsewhere).
- [ ] Run the existing `test/iap_service_test.dart` — most tests still
      assert valid behavior; add new tests around the real-SDK code path.
- [ ] Update [09E KNOWN_ISSUES #2](../phase-09e-amazon-readiness/KNOWN_ISSUES.md)
      to RESOLVED.

## Verification

- `flutter analyze` → **No issues found! (3.3s)**
- `flutter test` → **All tests passed (13/13)** — `iap_service_test.dart` continues to validate the mock flow because `IapService` is unchanged.
- `flutter build apk --release` → **Built build\app\outputs\flutter-apk\app-release.apk (51.4MB)** — signed by the same VerseLight upload keystore from Phase 09G.

## Known issues remaining before Amazon production

From [09E KNOWN_ISSUES.md](../phase-09e-amazon-readiness/KNOWN_ISSUES.md):

| # | Severity | Status | Tóm tắt |
|---|----------|--------|---------|
| 1 | 🔴 Store-blocker | ✅ RESOLVED 09F+09G | Debug signing → real upload key |
| 2 | 🔴 Store-blocker | ✅ RESOLVED 09H (this phase) | IAP mock UI gated behind feature flag |
| 3 | 🟡 Pre-launch | OPEN | `INTERNET` permission missing in release manifest |
| 4 | 🟡 Pre-launch | OPEN | Firebase init but unused |
| 5 | 🟡 Pre-launch | OPEN | Audio tab still mock UI |
| 6 | 🟢 Polish | OPEN | Affiliate banner FTC disclosure review |
| 7 | 🟢 Polish | OPEN | Content / Bible translation license review |
| 8 | 🟢 Polish | OPEN | versionCode bump strategy |

→ Both 🔴 store-blockers cleared. Remaining items are pre-launch and polish.
Next phase priorities are 09I (decide Firebase: gỡ hoặc wire Analytics) and
09K (store listing assets: screenshots, feature graphic, privacy policy URL,
age rating).
