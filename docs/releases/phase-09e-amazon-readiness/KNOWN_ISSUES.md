# VerseLight — Known Issues / Limitations (Phase 09E)

> Snapshot rủi ro/limit tại commit `739e53b`. KHÔNG phải bug blocker tester nội bộ;
> phần lớn là store-readiness items cần xử lý trước khi upload Amazon Appstore.

## Severity legend

- 🔴 **Store-blocker** — phải fix trước khi upload Amazon production.
- 🟡 **Pre-launch** — nên fix trước khi public launch, không blocker tester nội bộ.
- 🟢 **Polish / cleanup** — không gấp.

---

## 1. ✅ ~~🔴 APK ký bằng debug keystore~~ — RESOLVED (Phase 09F + 09G)

**Status:** Source config resolved by Phase 09F; first real signed APK produced by Phase 09G.

- Phase 09F (commit `a07dbf1`): [android/app/build.gradle.kts](../../../android/app/build.gradle.kts) load `android/key.properties` (gitignored) khi tồn tại và dùng release signing; fallback debug khi vắng file (chỉ cho local dev).
- Phase 09G: Generated VerseLight upload keystore (lưu OUTSIDE repo tại `%USERPROFILE%\.android\verselight-upload-key.jks`), populated local `android/key.properties`, built signed APK with cert
  - DN: `CN=VerseLight, OU=Mobile, O=Verse Studio, L=Bien Hoa, ST=Dong Nai, C=VN`
  - SHA-256: `2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c`
  - Artifact: [`docs/releases/phase-09g-signed-apk/`](../phase-09g-signed-apk/) (APK gitignored, metadata committed)

Keystore + password remain local only, never committed. See [Phase 09G RELEASE_NOTES](../phase-09g-signed-apk/RELEASE_NOTES.md).

---

## 2. ✅ ~~🔴 In-app purchase hoàn toàn mock~~ — STORE-BLOCKER RESOLVED (Phase 09H)

**Status:** Phase 09H gated the entire mock IAP surface behind
[`AppConstants.kEnableMockPurchases`](../../../lib/utils/constants.dart) (default `false`). In the store build:

- No Subscribe / Restore buttons are visible (paywall, settings).
- No prices ($2.99/month, $19.99/year) are displayed.
- No "(mock)" / "(beta)" copy reaches the user.
- `PremiumGate` and `PremiumAccess` bypass the gate → all premium-marked content accessible.
- Paywall route survives as a "COMING SOON" teaser advertising upcoming features, without a purchase path.

`IapService` mock logic preserved (tests unchanged) so the flag can flip back for dev or be replaced by real Amazon IAP / Play Billing in a later phase. Full breakdown in [`../phase-09h-iap-risk/AUDIT.md`](../phase-09h-iap-risk/AUDIT.md).

**Still required before public production launch (out of 09H scope):**
1. Amazon Developer console: create In-App Items / Subscriptions for SKUs `verselight_premium_monthly` / `verselight_premium_yearly`.
2. Wire real Amazon IAP (no official Flutter plugin → platform channel) or `in_app_purchase` + Google Play Billing.
3. Replace TODO methods in [`lib/services/iap_service.dart`](../../../lib/services/iap_service.dart) — keep public API stable so UI doesn't change.
4. Add `android.permission.INTERNET` to release manifest (issue #3) for store SDK network calls.
5. Flip `kEnableMockPurchases = true` (or replace with build-flavor check).

---

## 3. ✅ ~~🟡 `android.permission.INTERNET` thiếu trong release manifest~~ — RESOLVED (Phase 09I)

**Status:** Phase 09I added `<uses-permission android:name="android.permission.INTERNET" />` to [android/app/src/main/AndroidManifest.xml](../../../android/app/src/main/AndroidManifest.xml) (with a comment explaining the rationale). Release merged manifest now declares INTERNET at line 18, matching debug/profile builds.

INTERNET is a normal-category permission (no runtime prompt, no Amazon data-safety implication on its own). App still doesn't make any outbound network calls — this entry just removes the latent "works in dev fails in release" failure mode for the next time Firebase / IAP store SDK / HTTP work is added. See [`../phase-09i-firebase-network/AUDIT.md`](../phase-09i-firebase-network/AUDIT.md).

---

## 4. ⚠️ ~~🟡 Firebase initialized but unused~~ — DEFERRED (Phase 09I decision)

**Decision (Phase 09I):** Keep `firebase_core` init as-is. Don't wire Analytics/Auth/Crashlytics in this phase. Don't rip out either.

**Reasoning:**
- Setup cost is already sunk (plugin, `google-services.json`, `firebase_options.dart`).
- Two `lib/services/*.dart` TODO callsites already reference Firebase as the planned backend ([affiliate_service.dart](../../../lib/services/affiliate_service.dart) line 43, [ai_service.dart](../../../lib/services/ai_service.dart) line 6).
- `Firebase.initializeApp()` without follow-up calls does NOT collect data, does NOT make network calls, does NOT change privacy disclosure requirements.
- Wiring each Firebase product (Analytics, Crashlytics, Auth, Firestore) is its own decision with its own privacy implications — should be a deliberate phase, not a side-effect of "fix the latent risk".
- INTERNET permission (issue #3) is now in place, so when Firebase APIs DO get wired, network calls won't silently fail.

Full rationale in [`../phase-09i-firebase-network/AUDIT.md`](../phase-09i-firebase-network/AUDIT.md).

**Still to decide before public launch (own future phase):**
- Add `firebase_crashlytics` for crash reporting? (Recommended before scale.)
- Add `firebase_analytics` for install/event analytics? (Triggers privacy policy update + Amazon data-safety questionnaire.)
- Or replace Firebase with Sentry / PostHog / nothing — depends on monitoring strategy.

---

## 5. ✅ ~~🟡 Audio tab là mock UI~~ — RESOLVED (Phase 09J)

**Status:** Phase 09J gated Audio behind [`AppConstants.kEnableAudioTab`](../../../lib/utils/constants.dart) (default `false`). In the store build:

- Bottom navigation drops the Audio destination — 5 tabs visible (Home · Devotional · Journal · Plans · Shop).
- [`bottom_nav_shell.dart`](../../../lib/widgets/bottom_nav_shell.dart) removes `AudioScreen` from `IndexedStack` children when the flag is off, so no stale index ever points at it.
- [Home Quick Access](../../../lib/screens/home_screen.dart) replaces the "Audio · Listen & reflect" tile with "Shop · Curated resources" pointing to the shifted Shop index.
- [`AppState.selectTab()`](../../../lib/state/app_state.dart) upper bound shrinks from 5 → 4 when the flag is off.
- `AudioScreen`, `sample_audio.dart`, `AudioTrack` are intentionally kept in the codebase so flipping the flag re-enables the surface in one line. No pubspec dependencies were added or removed.

Full rationale + re-enable checklist in [`../phase-09j-audio-mock-decision/AUDIT.md`](../phase-09j-audio-mock-decision/AUDIT.md).

---

## 6. 🟢 Affiliate banner là external link

**Nơi:** [lib/widgets/affiliate_banner.dart](../../../lib/widgets/affiliate_banner.dart) — dùng `url_launcher` để mở Amazon ASIN/Audible URL trong browser external.

**Implication:**
- ✅ Không vi phạm Amazon Appstore policy (mở external Amazon là welcome).
- ⚠️ Cần đảm bảo affiliate tag (Amazon Associates ID) hợp lệ và disclosure phù hợp luật quảng cáo địa phương (FTC cho US, EU rules cho EU).

**Fix:** review affiliate disclosure khi chuẩn bị store listing (Phase 09K).

---

## 7. 🟢 Content review — Catholic devotional wording

**Nơi:** [lib/data/sample_devotionals.dart](../../../lib/data/sample_devotionals.dart), [lib/data/sample_plans.dart](../../../lib/data/sample_plans.dart) (nếu có), assets `assets/images/devotional/`.

**Implication:**
- Amazon Appstore content policy cho Religion/Spirituality category: chấp nhận, nhưng cần:
  - Không xúc phạm bất kỳ tôn giáo nào khác.
  - Không claim chữa bệnh / phép màu / lời khuyên y tế.
  - Bible verses dùng public-domain translation (KJV) hoặc license phù hợp (NIV/ESV cần permission).
- Tab Shop affiliate dẫn về Amazon book listings → đảm bảo các ASIN trỏ đúng và còn hợp lệ.

**Fix:** review nội dung devotional content + verse translation license trước Phase 09K (store listing).

---

## 8. 🟢 versionCode = 1, chưa có bump strategy

**Nơi:** pubspec `version: 1.0.0+1`.

**Implication:**
- versionCode=1 là OK cho beta đầu tiên.
- Trước Phase 09F (release signing) hoặc 09K (store upload), nên định strategy bump:
  - Ví dụ: `1.0.0+10` cho beta1, `1.0.0+11` cho beta2, `1.0.0+100` cho store v1.0.0 production.
  - Hoặc dùng date-based: `1.0.0+202605191` (YYYYMMDDN).

**Fix:** chốt versioning convention trong phase tiếp theo, không gấp.
