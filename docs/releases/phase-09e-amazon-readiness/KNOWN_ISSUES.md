# VerseLight — Known Issues / Limitations (Phase 09E, updated through 09K)

> Snapshot rủi ro/limit khởi tạo tại commit `739e53b`. Phase 09F–09M cập nhật
> trực tiếp tài liệu này. KHÔNG phải bug blocker tester nội bộ; phần lớn là
> store-readiness items cần xử lý trước khi upload Amazon Appstore.
>
> Phase trail: 09E baseline → 09F+09G signing → 09H IAP gating → 09I Firebase/network →
> 09J Audio tab gating → 09K Store listing + privacy URL audit →
> 09L Bible translation license review →
> 09M versionCode strategy + Release Candidate checklist (THIS).

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

## 6. 🟡 Affiliate banner là external link + tracking tag placeholder

**Nơi:** [lib/widgets/affiliate_banner.dart](../../../lib/widgets/affiliate_banner.dart) — dùng `url_launcher` để mở Amazon ASIN/Audible URL trong browser external. Tag từ [`AppConstants.amazonTrackingId`](../../../lib/utils/constants.dart) = `verselight-placeholder-20`.

**Implication:**
- ✅ Không vi phạm Amazon Appstore policy (mở external Amazon là welcome).
- ✅ Phase 09K xác nhận disclosure UI đã có (Shop screen + Settings footer: "As an Amazon Associate we earn from qualifying purchases.") — đáp ứng baseline FTC US / EU rules.
- ⚠️ Tracking tag vẫn là placeholder — links mở Amazon OK, KHÔNG award commission cho tới khi Amazon Associates approval xong và tag thật được wire.

**Còn lại trước store submit:**
1. Đăng ký Amazon Associates → khi duyệt, thay `verselight-placeholder-20` bằng tag thật.
2. (Optional) Review disclosure copy có cần đậm hơn cho EU không (Phase 09K không phát hiện vi phạm).

---

## 7. ✅ ~~🟡 Bible translation license risk~~ — RESOLVED (Phase 09L)

**Status:** Phase 09L audited all scripture content trong [`lib/data/sample_devotionals.dart`](../../../lib/data/sample_devotionals.dart) (10 verses) và [`lib/data/sample_plans.dart`](../../../lib/data/sample_plans.dart) (35 verses across 5 plans). Phát hiện toàn bộ 45 verseText được tag `(NIV)` và wording khớp NIV verbatim — copyrighted by Biblica, không có license.

**Resolution:** mọi `verseText` được thay bằng **original devotional paraphrase** viết riêng cho VerseLight; mọi `verseReference` được strip suffix `(NIV)`. Mock audio title `"Psalm 23 — NIV"` được đổi thành `"Psalm 23 — narration"`. App giờ không ship bất kỳ translation copyrighted nào.

**Affiliate product titles** ("NIV Study Bible" trong [affiliate_service.dart](../../../lib/services/affiliate_service.dart) và [home_screen.dart](../../../lib/screens/home_screen.dart)) được giữ — đây là tên sản phẩm Amazon thật được dùng để link affiliate, không phải quote Bible content.

Full breakdown trong [`../phase-09l-bible-license-review/AUDIT.md`](../phase-09l-bible-license-review/AUDIT.md).

**Còn lại (out of 09L scope):**
- (Optional) Decide whether to license a real translation (NABRE / RSV-CE) hoặc swap về public-domain Douay-Rheims khi muốn ship literal scripture thay vì paraphrase.
- Tab Shop affiliate dẫn về Amazon book listings → đảm bảo các ASIN trỏ đúng và còn hợp lệ (tracking ID placeholder thuộc issue #6).
- General content policy items (không xúc phạm tôn giáo khác, không claim chữa bệnh) — không phát hiện vi phạm trong content hiện tại, nhưng vẫn nên review lại reflection/prayer prompt trước khi mỗi đợt content mới được merge.

---

## 8. ✅ ~~🟡 versionCode = 1, chưa có bump strategy~~ — RESOLVED-AS-STRATEGY (Phase 09M)

**Status:** Phase 09M chốt strategy + RC checklist. KHÔNG bump pubspec ngay
(repo HEAD vẫn `1.0.0+1`); bump sẽ áp dụng trong submission commit kế tiếp.

**Strategy đã chốt:**
- `versionName` = SemVer (MAJOR.MINOR.PATCH) theo phạm vi thay đổi user-facing.
- `versionCode` = monotonic +1 mỗi signed artifact mới (beta sideload HOẶC store upload).
- Reserved bands: `1` đã burned (09G sideload); `2-9` headroom cho RC builds;
  `10` cho first Amazon production submission; `20` cho `1.0.1`; `30` cho `1.1.0`.
- Date-based scheme considered và rejected (overkill cho cadence hiện tại).

**Submission-day bump:** thay `version: 1.0.0+1` → `version: 1.0.0+10` trong
[pubspec.yaml](../../../pubspec.yaml) (one-line change) rồi rebuild — không
cần đụng Gradle hay manifest.

Full rationale + reserved table trong [`../phase-09m-versioncode-and-rc-checklist/AUDIT.md`](../phase-09m-versioncode-and-rc-checklist/AUDIT.md).
Submission runbook trong [`../phase-09m-versioncode-and-rc-checklist/RC_CHECKLIST.md`](../phase-09m-versioncode-and-rc-checklist/RC_CHECKLIST.md) §C.

---

## 9. 🟡 Privacy / Terms / Help URLs + support email là placeholders

**Phase tracked:** [Phase 09K AUDIT](../phase-09k-store-listing-privacy/AUDIT.md).

**Status:** Phase 09K audit-only — KHÔNG flip URL/email trong code, vì không có URL "đúng hơn" để wire vào và không xác minh được URL hiện tại có nội dung Amazon yêu cầu hay không.

**Snapshot tại Phase 09K** ([lib/utils/constants.dart](../../../lib/utils/constants.dart) dòng 53-61):

| Const           | Value hiện tại                                          | Type        |
|-----------------|---------------------------------------------------------|-------------|
| `privacyUrl`    | `https://versestudio-apps.github.io/privacy/`           | Placeholder (per TODO comment) |
| `termsUrl`      | `https://versestudio-apps.github.io/privacy/`           | Placeholder (= privacyUrl)     |
| `helpUrl`       | `https://versestudio-apps.github.io/privacy/#help`      | Placeholder                    |
| `supportEmail`  | `support@example.com`                                   | RFC 2606 reserved — chắc chắn placeholder |

**Owner action trước khi submit Amazon:**
1. Publish / xác minh real Privacy Policy URL, đáp ứng yêu cầu Amazon.
2. Publish Terms URL **riêng** (không trùng privacy).
3. Publish Help / FAQ URL, hoặc gỡ Help tile khỏi Settings nếu không có.
4. Cung cấp support email thật, KHÔNG dùng `example.com`.
5. Wire 4 giá trị mới vào `AppConstants` trong 1 commit; cùng commit gỡ subtitle "Placeholder — update before launch" trên Terms tile ở [lib/screens/settings_screen.dart](../../../lib/screens/settings_screen.dart) dòng 101.

---

## 10. 🟡 Store listing assets + copy chưa làm

**Phase tracked:** [Phase 09K AUDIT](../phase-09k-store-listing-privacy/AUDIT.md) §2-§3.

**Status:** Branding internals OK (launcher icon, splash, devotional artwork). Store-facing listing assets chưa làm.

**Còn lại:**
- 512×512 PNG icon export (cho store listing slot).
- 1024×500 feature graphic / small banner.
- 1920×1080 promo image (optional, Amazon featured).
- ≥3 phone screenshots (Pixel 6 API 34, 1080×2400) — Audio tab ĐÃ ẨN ở Phase 09J nên skip route #5 trong checklist cũ [README §9](../../../README.md).
- ≥3 Fire HD 8 screenshots (800×1280).
- Optional: Fire HD 10 (1200×1920).
- Short description (≤80 ký tự).
- Long description (≤4000 ký tự).
- Content rating / IARC questionnaire.
- Data safety questionnaire (Phase 09K xác nhận: no PII / no ads / no analytics — vẫn đúng).

**Fix:** Owner deliverable, không thể produce từ code thuần. Phase tiếp theo (Phase 09L gợi ý) sẽ land các artifact này.
