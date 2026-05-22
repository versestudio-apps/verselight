# VerseLight — Phase 09K Store Listing + Privacy URL Audit

> Audit-only phase. Goal: kiểm tra mức độ sẵn sàng của metadata store-facing,
> privacy/legal URLs, và listing assets trước khi submit Amazon Appstore.
> KHÔNG sửa signing, keystore, applicationId, versionCode, IAP flag, Audio flag,
> hay pubspec dependencies.

## Snapshot

| Field            | Value                                                          |
|------------------|----------------------------------------------------------------|
| Branch / commit  | `main` @ `5aff2c8` (Phase 09J — hide mock Audio tab)           |
| Working tree     | clean trước khi bắt đầu phase                                  |
| Flutter / Dart   | 3.35.3 stable / Dart 3.9.2                                     |
| pubspec version  | `1.0.0+1` (versionCode bump strategy vẫn pending — issue #8)   |

## Status summary

| Hạng mục                                  | Trạng thái                                |
|-------------------------------------------|-------------------------------------------|
| Privacy policy URL trong app              | ⚠️ **PLACEHOLDER** — TODO chưa flip       |
| Terms of use URL trong app                | ⚠️ **PLACEHOLDER** (trỏ cùng privacyUrl)  |
| Help URL trong app                        | ⚠️ **PLACEHOLDER** (privacyUrl + `#help`) |
| Support email                             | ❌ **PLACEHOLDER** (`support@example.com`) |
| Amazon Associates tracking ID             | ⚠️ **PLACEHOLDER** (`verselight-placeholder-20`) |
| App name / package / label                | ✅ Production-ready                       |
| Launcher icon (mipmap)                    | ✅ Branded (Phase 09A)                    |
| Master icon PNG cho store listing 512×512 | ⚠️ Cần master file độc lập (xem dưới)    |
| Screenshots (phone / Fire tablet)         | ❌ Chưa capture                            |
| Feature graphic / small banner 1024×500   | ❌ Chưa                                    |
| Promo image 1920×1080                     | ❌ Chưa                                    |
| Short description (≤80 ký tự)             | ❌ Chưa viết                               |
| Long description (≤4000 ký tự)            | ❌ Chưa viết                               |
| Content rating / IARC                     | ❌ Chưa làm questionnaire                  |
| Data safety / privacy disclosure          | ⚠️ Cần điền form Amazon — xem dưới        |

---

## 1. AppConstants audit — store-facing strings

Source: [lib/utils/constants.dart](../../../lib/utils/constants.dart).

| Const                    | Value hiện tại                                          | Trạng thái                                   |
|--------------------------|---------------------------------------------------------|----------------------------------------------|
| `appName`                | `VerseLight`                                            | ✅ final                                      |
| `appPackage`             | `com.versestudio.verselight`                            | ✅ final (KHÔNG đổi sau lần submit đầu)      |
| `appVersion`             | `1.0.0`                                                 | ✅ khớp pubspec                              |
| `amazonTrackingId`       | `verselight-placeholder-20`                             | ⚠️ placeholder — chờ Associates approval     |
| `audibleTrialUrl`        | `https://www.amazon.com/.../prime?tag=$amazonTrackingId`| ⚠️ phụ thuộc tracking ID                     |
| `skuPremiumMonthly`      | `verselight_premium_monthly`                            | ✅ final SKU                                  |
| `skuPremiumYearly`       | `verselight_premium_yearly`                             | ✅ final SKU                                  |
| `kEnableAudioTab`        | `false`                                                 | ✅ Phase 09J (locked)                         |
| `kEnableMockPurchases`   | `false`                                                 | ✅ Phase 09H (locked)                         |
| `privacyUrl`             | `https://versestudio-apps.github.io/privacy/`           | ⚠️ **placeholder per TODO comment**           |
| `termsUrl`               | `https://versestudio-apps.github.io/privacy/`           | ⚠️ trỏ cùng privacyUrl                        |
| `helpUrl`                | `https://versestudio-apps.github.io/privacy/#help`      | ⚠️ placeholder (fragment vào privacy page)    |
| `supportEmail`           | `support@example.com`                                   | ❌ RFC 2606 reserved — KHÔNG bao giờ deliver |

### Findings

1. Comment dòng 53–54 đã đánh dấu rõ: `TODO(store-ready): replace placeholder URLs/email with final values before submitting to Google Play / Amazon Appstore.` → Owner đã ý thức được, chưa flip.
2. `privacyUrl` trông giống URL thật (GitHub Pages dưới `versestudio-apps` org) — nhưng phase này KHÔNG xác minh được rằng nó đã live, có nội dung Privacy Policy thật, và đáp ứng yêu cầu Amazon Appstore. Code chỉ giữ URL đang trỏ về đó vì:
   - URL đã được đặt từ phase trước.
   - Không có URL thay thế nào "đúng hơn" để wire vào.
   - Flip URL trong code mà chưa biết URL cuối là LÀM XẤU HƠN, không tốt hơn.
3. `termsUrl == privacyUrl` là dấu hiệu placeholder rõ ràng — Amazon yêu cầu Terms riêng (hoặc khẳng định trong privacy page rằng nó cũng là Terms — không khuyến nghị).
4. `supportEmail = 'support@example.com'` — `example.com` là domain reserved (RFC 2606), email này không tồn tại. Là PLACEHOLDER rõ rệt, không xếp được kiểu "có thể là thật".
5. Settings screen ([lib/screens/settings_screen.dart:97-108](../../../lib/screens/settings_screen.dart)) hiện chỉ ghi subtitle `Placeholder — update before launch` cho **Terms**, không cho Privacy / Help / Contact. → Recommend (KHÔNG thực hiện trong phase này): khi flip URL thật, đồng thời gỡ subtitle placeholder ở Terms.

### Decision (Phase 09K)

- **KHÔNG** thay đổi `privacyUrl`, `termsUrl`, `helpUrl`, `supportEmail`, `amazonTrackingId` trong code.
- **KHÔNG** thêm subtitle placeholder vào Privacy/Help/Contact (đây là polish nhỏ, không cần thiết và làm noisy diff).
- Lý do: phase này là audit + documentation. Bất kỳ flip nào của các URL legal phải đi kèm xác nhận từ owner rằng URL cuối đã live + đáp ứng nội dung Amazon yêu cầu. Không có thông tin đó ở phase này → giữ nguyên code, tài liệu hóa owner action.

---

## 2. Branding assets — đã có

| Asset                                     | Path                                                | Status |
|-------------------------------------------|-----------------------------------------------------|--------|
| Master app icon (cho launcher)            | [assets/branding/app_icon.png](../../../assets/branding/app_icon.png) (~339 KB) | ✅ tồn tại |
| `pubspec.yaml` `flutter_launcher_icons`   | trỏ về `assets/branding/app_icon.png`               | ✅      |
| In-APK launcher icons (mipmap-*)          | `android/app/src/main/res/mipmap-*/ic_launcher.png` | ✅ generated (Phase 09A — commit `c112737`) |
| Adaptive icon (API 26+)                   | `mipmap-anydpi-v26/ic_launcher.xml`                 | ✅      |
| Native splash background                  | `drawable*/launch_background.xml` + cream color    | ✅ Phase 09C |
| Flutter bootstrap (`BrandSplash`)         | `lib/widgets/brand_splash.dart`                     | ✅      |
| Devotional artwork (WebP q85, 16:9 / 3:4) | `assets/images/devotional/` (Phase 08E)             | ✅ in-app |

### Gaps cho store listing

| Item                                      | Resolution gợi ý                                    |
|-------------------------------------------|----------------------------------------------------|
| **App icon 512×512 PNG (store-facing)**   | Owner export riêng từ master `assets/branding/app_icon.png` ở đúng kích thước; không re-encode từ in-APK mipmap. |
| **Feature graphic / small banner 1024×500** | Cần thiết kế riêng (logo + tagline trên background cream). |
| **Promo image 1920×1080** (Amazon featured slot) | Optional nhưng nên có nếu apply featured.       |
| **Screenshots — phone (≥3, 1080×2400 portrait)** | Capture trên Pixel 6 emulator API 34 (đề xuất [README §9](../../../README.md)). Reset local data trước. Capture các route: Home / Devotional detail / Journal / Plan detail / Shop / Settings. |
| **Screenshots — Fire HD 8 (800×1280, ≥3)** | Capture trên Fire HD 8 emulator profile hoặc thiết bị thật. |
| **Screenshots — Fire HD 10 (1200×1920)**  | Optional. Khuyến nghị nếu list trên Amazon.       |

Lưu ý: từ Phase 09J, tab Audio đã ẩn → KHÔNG capture màn Audio. Bottom nav giờ là 5 tab (Home · Devotional · Journal · Plans · Shop). Hướng dẫn screenshot cũ trong [README §9](../../../README.md) (#5 Audio) cần được skip khi capture. (Không thay đổi README trong phase này; chỉ note.)

---

## 3. Store listing copy — chưa làm

| Item                            | Note                                                                     |
|---------------------------------|--------------------------------------------------------------------------|
| Short description (≤80 chars)   | Chưa viết. Đề xuất draft: "Daily Catholic devotionals, prayer plans, journaling, and verse-by-verse reading." (78 chars — ASCII only, không icon) |
| Long description (≤4000 chars)  | Chưa viết. Nên cover: Daily devotional + Bible verse, Reading plans, Journal local-only, No tracking / no ads, Amazon Associates link disclosure. |
| Promotional text                | (Amazon optional) — chưa làm.                                            |
| Keywords / search terms         | Chưa làm.                                                                |
| Category                        | Đề xuất: Books & Reference → Religion & Spirituality (Catholic).         |
| Age rating                      | Đề xuất: 4+ / All Ages — nội dung devotional family-friendly, không ad network. |

**Decision (Phase 09K):** không viết copy production trong phase này. Listing copy là owner deliverable (cần phê duyệt nội dung) — không phải code change.

---

## 4. Privacy / Data safety disclosure — Amazon yêu cầu

App hiện trạng:
- KHÔNG thu thập PII (no auth, no analytics, no crash reporting wired).
- KHÔNG có quyền nhạy cảm (chỉ `INTERNET` từ Phase 09I — normal-category, no runtime prompt).
- Lưu trữ duy nhất: local `shared_preferences` (journal entries, plan progress, premium entitlement bypass).
- `firebase_core` init nhưng KHÔNG gọi product API nào — KHÔNG truyền data ra ngoài (Phase 09I decision, [phase-09i-firebase-network/AUDIT.md](../phase-09i-firebase-network/AUDIT.md)).
- External traffic duy nhất: `url_launcher` mở Amazon affiliate URL trong browser external (không phải in-app webview, không track in-app).

→ Disclosure dự kiến cho Amazon data-safety questionnaire:
- "Does your app collect personal information from end users?" → **No**.
- "Does your app use ads?" → **No** (in-app). External Amazon affiliate links không phải ad network.
- "Does your app use third-party analytics?" → **No** (Firebase chỉ init, không Analytics).
- Affiliate disclosure (FTC US / EU rules): Shop screen và Settings đã có dòng "As an Amazon Associate we earn from qualifying purchases." ([README §4](../../../README.md)) → ✅.

⚠️ Trước khi flip `kEnableMockPurchases = true` hoặc wire Firebase Analytics/Crashlytics, **phải** revisit answers ở đây — disclosure sẽ đổi.

---

## 5. Required owner actions (out of code scope)

1. **Privacy policy page**: xác nhận `https://versestudio-apps.github.io/privacy/` đã live + nội dung đáp ứng Amazon Appstore policy (loại data thu thập, retention, contact). Nếu chưa live: publish trước. Nếu đã live nhưng nội dung chưa đúng: cập nhật.
2. **Terms of use page**: tạo URL riêng (không trùng privacy). Cập nhật `AppConstants.termsUrl` trong cùng commit khi URL ready.
3. **Help / FAQ page**: tạo URL thật, hoặc gỡ Help tile khỏi Settings cho tới khi có. Cập nhật `AppConstants.helpUrl`.
4. **Support email**: thay `support@example.com` bằng email thật (e.g. `support@versestudio.com` hoặc địa chỉ liên hệ thực). Cập nhật `AppConstants.supportEmail`.
5. **Amazon Associates approval**: đăng ký Associates account → khi được duyệt, thay `verselight-placeholder-20` bằng tag thật. Tracking ID đặt sai/chưa duyệt sẽ làm affiliate links không award commission (link vẫn mở Amazon bình thường, không vỡ UX).
6. **Store listing assets**: produce 512×512 icon export, 1024×500 banner, ≥3 phone screenshots, ≥3 Fire HD 8 screenshots, long & short description copy.
7. **Content rating / IARC questionnaire**: trả lời trong Amazon Developer Console.
8. **Bible translation license**: confirm các verse dùng trong [lib/data/sample_devotionals.dart](../../../lib/data/sample_devotionals.dart) (và bất kỳ data file devotional/plan nào) đều thuộc public-domain (KJV/Douay-Rheims) hoặc đã có license cho NIV/ESV/NABRE/RSV. → KHÔNG resolve trong phase này; vẫn là open item từ Phase 09E KNOWN_ISSUES #7.
9. **versionCode bump strategy**: chốt convention trước khi submit store đầu tiên (Phase 09E KNOWN_ISSUES #8 vẫn open).

---

## 6. Files changed in this phase

| File                                                                          | Reason                                  |
|-------------------------------------------------------------------------------|-----------------------------------------|
| `docs/releases/phase-09k-store-listing-privacy/AUDIT.md`                      | NEW — phase audit document (this file). |
| `docs/releases/phase-09e-amazon-readiness/KNOWN_ISSUES.md`                    | Updated — track privacy/listing progress without falsely closing legal items. |

**Không** thay đổi: `lib/utils/constants.dart`, `lib/screens/settings_screen.dart`, signing config, keystore, `key.properties`, `applicationId`, namespace, `versionCode`/`versionName`, Firebase config, `google-services.json`, `firebase_options.dart`, pubspec dependencies, launcher icon, IAP flag, Audio flag.

---

## 7. Verification

| Command                       | Result                                                         |
|-------------------------------|----------------------------------------------------------------|
| `flutter analyze`             | ✅ `No issues found! (ran in 3.2s)`                            |
| `flutter test`                | ✅ All tests passed (13 tests)                                 |
| `flutter build apk --release` | ✅ `Built build\app\outputs\flutter-apk\app-release.apk (51.4MB)` |
| `git diff --check`            | ✅ no whitespace errors                                        |
| `git status --short`          | new `docs/releases/phase-09k-store-listing-privacy/AUDIT.md` + modified `docs/releases/phase-09e-amazon-readiness/KNOWN_ISSUES.md` (docs only) |
| `git diff --stat`             | docs-only diff                                                 |

Build APK xuất hiện không kèm thay đổi runtime → safe.

---

## 8. Store / privacy / network implication

- Privacy URL không đổi trong code → user-facing behavior **không đổi**. Settings → Privacy policy vẫn mở `https://versestudio-apps.github.io/privacy/` qua external browser (`url_launcher`).
- Không thêm permission, không thêm network call, không thêm dependency.
- Disclosure picture vẫn đúng như Phase 09I/09J: no PII, no ads, no analytics, INTERNET permission declared nhưng không phát sinh outbound traffic ngoài user-initiated affiliate link.
- Affiliate banner vẫn dùng placeholder tag (`verselight-placeholder-20`) → links mở Amazon OK nhưng KHÔNG award commission cho tới khi Associates approved + tag thật replaced.

---

## 9. Recommended next phase (09L)

Phase 09L (hoặc thay tên phù hợp): **Owner deliverables landing**:
1. Land final privacy/terms/help/support URLs vào `AppConstants` trong 1 commit.
2. Gỡ subtitle `Placeholder — update before launch` của Terms tile khi URL thật được wire.
3. Land 512×512 store icon export + screenshots + listing copy vào `docs/releases/phase-09L-store-listing-final/` (binary có thể commit nếu < few MB; nếu lớn dùng strategy gitignore + metadata như Phase 09G).
4. Resolve Bible translation license review (Phase 09E #7) trước khi bump versionCode cho production.
5. Chốt versionCode bump convention (Phase 09E #8).

Phase 09K hoàn thành audit và snapshot — chưa unblock store submission, nhưng đã liệt kê toàn bộ owner deliverables còn lại và xác nhận codebase đang ở trạng thái không tạo thêm risk mới.
