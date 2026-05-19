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

## 2. 🔴 In-app purchase hoàn toàn mock

**Nơi:**
- [lib/services/iap_service.dart](../../../lib/services/iap_service.dart) — class `IapService` chỉ persist entitlement vào `shared_preferences`, không gọi store SDK.
- `pubspec.yaml` không có package `in_app_purchase` / không có Amazon IAP SDK.

**Implication:**
- Tester nhấn "Subscribe (mock)" → app set entitlement local → unlock premium content. Không có thanh toán thật.
- `TESTER_CHECKLIST.md` Section G đã nhắc tester KHÔNG thử thẻ thật.
- Upload Amazon trong trạng thái này = vi phạm policy (quảng cáo subscription nhưng không có billing thực).

**Fix (Phase 09H):**
1. Quyết định strategy: Amazon IAP (cho Amazon Appstore) hoặc Google Play Billing (cho Play Store) — hoặc cả hai với flavor.
2. Thêm package phù hợp (`amazon_iap` chưa có official Flutter plugin → có thể cần platform channel; hoặc dùng `in_app_purchase` của Flutter cho Google Play).
3. Thay private methods TODO trong `IapService` để gọi real store SDK, giữ giao diện public ổn định để các màn paywall không phải sửa.

---

## 3. 🟡 `android.permission.INTERNET` thiếu trong release manifest

**Nơi:** merged release manifest tại
`build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml`
— chỉ có `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (signature-level, auto-injected).

Debug và profile builds có `<uses-permission android:name="android.permission.INTERNET"/>` ở
[android/app/src/debug/AndroidManifest.xml:6](../../../android/app/src/debug/AndroidManifest.xml#L6)
và [android/app/src/profile/AndroidManifest.xml:6](../../../android/app/src/profile/AndroidManifest.xml#L6),
nhưng `main/AndroidManifest.xml` thì không.

**Implication hiện tại (Phase 09E beta):**
- ✅ `Firebase.initializeApp(...)` trong `main.dart` không gọi network → không crash.
- ✅ `url_launcher` mở browser/Amazon app external → không cần INTERNET của app này.
- ✅ Devotional/plan content là static assets → không cần network.
- → Beta hiện tại **chạy bình thường** không INTERNET.

**Implication tương lai:**
- ❌ Khi wire Firestore/Auth/Analytics/Crashlytics → tất cả network calls sẽ fail silently trong release build.
- ❌ Khi wire real IAP store SDK → có thể không refresh được product catalog.

**Fix (cùng Phase 09I khi wire Firebase, hoặc sớm hơn nếu safe):**
Thêm `<uses-permission android:name="android.permission.INTERNET"/>` vào
[android/app/src/main/AndroidManifest.xml](../../../android/app/src/main/AndroidManifest.xml)
(ngoài thẻ `<application>`).

---

## 4. 🟡 Firebase initialized but unused

**Nơi:**
- [lib/main.dart:10-12](../../../lib/main.dart#L10-L12) — `await Firebase.initializeApp(...)`.
- [lib/firebase_options.dart](../../../lib/firebase_options.dart) — auto-generated config.
- `pubspec.yaml`: chỉ có `firebase_core: ^4.9.0`, KHÔNG có `firebase_auth` / `cloud_firestore` / `firebase_analytics` / `firebase_crashlytics`.

**Implication:**
- Tăng size APK (`google_services.json` + firebase_core native code) mà chưa thu được giá trị nào.
- Không crash, không leak data → không phải store-blocker.

**Fix (Phase 09I):** chọn 1 trong 2 hướng:
- **(a) Gỡ Firebase** nếu phase tiếp theo không có kế hoạch dùng — remove `firebase_core`, `firebase_options.dart`, init call, `google-services.json`, `com.google.gms.google-services` plugin trong gradle.
- **(b) Wire thật** — thêm Analytics + Crashlytics ít nhất (cần thiết cho production app), đồng thời fix issue #3 (INTERNET permission).

---

## 5. 🟡 Audio tab là mock UI

**Nơi:** [lib/screens/audio_screen.dart](../../../lib/screens/audio_screen.dart), không có `just_audio` / `audioplayers` / `audio_service` trong pubspec.

**Implication:**
- Tab Audio hiển thị danh sách track + "Now Playing" UI, nhưng nhấn Play KHÔNG phát audio thật (chỉ thay đổi state).
- Tester `TESTER_CHECKLIST.md` Section H đã ghi rõ "mock playback".
- Upload store với tab Audio non-functional → khả năng cao bị Amazon reviewer reject vì "advertised feature does not work".

**Fix (Phase 09J):** chọn 1 trong 2 hướng:
- **(a) Tạm ẩn tab Audio** trước khi store submit, đưa quay lại sau.
- **(b) Wire `just_audio`** + bundle vài track audio (hoặc stream URL) + thêm INTERNET permission nếu stream.

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
