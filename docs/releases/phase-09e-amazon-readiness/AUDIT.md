# VerseLight — Phase 09E Amazon Readiness Audit

> Audit chuẩn bị cho vòng beta nội bộ và lộ trình tiến tới Amazon Appstore.
> Phase này chỉ review/checklist/docs — không sửa code app.

## Status summary

| Hạng mục                                | Trạng thái                         |
|-----------------------------------------|------------------------------------|
| Beta APK sẵn sàng gửi tester nội bộ     | ✅ **READY** (Phase 09G signed APK preferred over Phase 09D debug-signed) |
| Signed APK pipeline                     | ✅ **DONE** in Phase 09G (real upload keystore) — see [`../phase-09g-signed-apk/RELEASE_NOTES.md`](../phase-09g-signed-apk/RELEASE_NOTES.md) |
| APK này sẵn sàng upload Amazon production | ❌ **NOT YET** — signing resolved; mock IAP still blocks store submission |
| Tester docs sẵn sàng                    | ✅ READY (đã fix minSdk inaccuracy) |
| Beta-blocker bugs                       | ❌ Không phát hiện                  |
| Store-blocker items                     | ⚠️ Có (xem `KNOWN_ISSUES.md`)      |

## Snapshot

| Field            | Value                                                              |
|------------------|--------------------------------------------------------------------|
| Current commit   | `739e53b47939af6ad2233c7986caee3299c966ca` (branch `main`)         |
| Phase            | 09E (audit only) — phase trước 09A→09D đã push                     |
| APK artifact     | `docs/releases/phase-09d-beta/VerseLight-v1.0.0-beta-android.apk`  |
| APK size         | 53,979,781 bytes (~51.5 MB)                                        |
| APK SHA256       | `33450A323568DB86CD80B7D05BC3E8D20644E2022D6C1D56A64AFAFDCAF07214` |
| SHA256 verified  | ✅ khớp với `VerseLight-v1.0.0-beta-android.sha256.txt` (re-check)  |
| `.gitignore`     | ✅ `docs/releases/**/*.apk` — APK không bị commit                   |
| Flutter / Dart   | 3.35.3 stable / Dart 3.9.2                                         |

## Amazon readiness checklist

### Identity & versioning

| Item              | Value                              | Status |
|-------------------|------------------------------------|--------|
| `applicationId`   | `com.versestudio.verselight`       | ✅     |
| `namespace`       | `com.versestudio.verselight`       | ✅     |
| App label         | `VerseLight`                       | ✅     |
| `versionName`     | `1.0.0`                            | ✅     |
| `versionCode`     | `1`                                | ⚠️ trước store launch nên bump rule (vd: 1 = beta1) |
| pubspec `version` | `1.0.0+1`                          | ✅     |

### SDK levels (từ release merged manifest)

| Item                | Value             | Status                    |
|---------------------|-------------------|---------------------------|
| `minSdkVersion`     | **24** (Android 7.0 Nougat) | ✅ OK cho Amazon (≥ 21)  |
| `targetSdkVersion`  | **36** (Android 16) | ✅ Rất hiện đại, vượt yêu cầu Amazon hiện tại |

### Permissions trong release APK (merged manifest)

| Permission                                            | Trạng thái                          |
|-------------------------------------------------------|-------------------------------------|
| `com.versestudio.verselight.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | ✅ Auto-injected bởi AndroidX, signature-level, không phải quyền user |
| `android.permission.INTERNET`                         | ❌ **KHÔNG có trong release manifest** (debug/profile thì có) — xem `KNOWN_ISSUES.md` #3 |
| Bất kỳ quyền runtime nhạy cảm nào (READ_CONTACTS, LOCATION, CAMERA, MIC, STORAGE...) | ✅ Không có |

→ Privacy footprint cực thấp. Tốt cho Amazon submission (ít câu hỏi về data collection).

### Signing — RESOLVED (Phase 09F + 09G)

| Item                  | Value                                       | Status |
|-----------------------|---------------------------------------------|--------|
| Release signing config | Conditional: load `android/key.properties` if present, fallback debug ([android/app/build.gradle.kts](../../../android/app/build.gradle.kts)) | ✅ Phase 09F |
| `android/key.properties` | Exists locally, gitignored                | ✅ Phase 09G |
| Upload keystore       | Generated, stored at `%USERPROFILE%\.android\verselight-upload-key.jks` (OUTSIDE repo) | ✅ Phase 09G |
| Signed APK produced   | [`docs/releases/phase-09g-signed-apk/`](../phase-09g-signed-apk/) (binary gitignored, metadata committed) | ✅ Phase 09G |
| Cert SHA-256          | `2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c` | ✅ verified by `apksigner` |

→ Signing blocker resolved. APK now eligible for Amazon Appstore upload from a signing standpoint; remaining blocker is IAP (see [`KNOWN_ISSUES.md` #2](KNOWN_ISSUES.md)).

### Branding assets

| Item                  | Value                                                                 | Status |
|-----------------------|-----------------------------------------------------------------------|--------|
| Launcher icon         | `@mipmap/ic_launcher` (Phase 09A, Catholic Bible + Cross trên cream) | ✅     |
| Adaptive icon (API 26+) | `mipmap-anydpi-v26/ic_launcher.xml` với foreground + background     | ✅     |
| Native splash         | `drawable*/launch_background.xml` — cream + centered foreground (Phase 09C) | ✅     |
| Flutter bootstrap     | `BrandSplash` widget — Lora wordmark + tagline + gold spinner (Phase 09C) | ✅     |
| Status bar style      | `SystemUiOverlayStyle` set transparent + dark icons trong `main.dart` | ✅     |

### Store listing assets (chưa làm — phase sau)

| Item                          | Status            |
|-------------------------------|-------------------|
| Feature graphic (1024×500)    | ❌ Chưa            |
| Screenshot Android phone (≥3) | ❌ Chưa            |
| Screenshot Android tablet     | ❌ Chưa (Amazon optional nhưng nên có) |
| App description short/long    | ❌ Chưa            |
| Age rating questionnaire      | ❌ Chưa            |
| Content rating IARC           | ❌ Chưa            |
| Privacy policy URL            | ❌ Chưa            |
| Support email / website       | ❌ Chưa            |

## Tester docs audit

Reviewed against checklist trong yêu cầu Phase 09E:

| Yêu cầu                                       | Có trong docs? |
|-----------------------------------------------|----------------|
| Tester không kỹ thuật đọc hiểu                | ✅ — Vietnamese, step-by-step |
| Phần báo lỗi với template                     | ✅ — Section I của `TESTER_CHECKLIST.md` |
| Nhắc KHÔNG thanh toán thật                    | ✅ — Section G, nhấn mạnh 3 lần |
| Nhắc IAP mock                                 | ✅ — Section G + `RELEASE_NOTES.md` |
| Nhắc Firebase chưa production                 | ✅ — `RELEASE_NOTES.md` "Phần CHƯA production" |
| Nhắc verify SHA256                            | ✅ — `RELEASE_NOTES.md` + `sha256.txt` |
| Hướng dẫn cài APK ngoài store                 | ✅ — Section A |
| Min Android version hiển thị đúng             | ⚠️ **Đã fix ở phase này** (8.0 → 7.0) |

**Fix duy nhất ở phase này:** sửa `TESTER_CHECKLIST.md` header từ "Android 8.0 (API 26) trở lên" → "Android 7.0 (API 24) trở lên" để khớp với merged manifest thực tế.

## Manual tester instruction summary

1. Gửi tester 3 file (qua Google Drive / OneDrive / link nội bộ):
   - `VerseLight-v1.0.0-beta-android.apk`
   - `VerseLight-v1.0.0-beta-android.sha256.txt`
   - `TESTER_CHECKLIST.md`
2. Tester verify SHA256 trên máy nhận file:
   - Windows: `Get-FileHash .\VerseLight-v1.0.0-beta-android.apk -Algorithm SHA256`
   - Hash phải khớp: `33450A323568DB86CD80B7D05BC3E8D20644E2022D6C1D56A64AFAFDCAF07214`
3. Tester làm theo `TESTER_CHECKLIST.md` mục A–J.
4. Tester gửi lại checklist đã tick + screenshot/video lỗi (nếu có).
5. Team review → quyết định fix tiếp hay tiến tới Phase 09F (release signing).

## Recommended next phases

| Phase           | Mục tiêu                                                                    | Ưu tiên  |
|-----------------|-----------------------------------------------------------------------------|----------|
| **09F**         | Setup release signing (upload keystore, `key.properties`, gradle signingConfig "release"), rebuild signed APK, NEW SHA256 cho store APK | 🔴 Cao (blocker store submission) |
| **09G**         | Thu thập feedback tester từ Phase 09D + fix beta-blocker nếu có             | 🔴 Cao (tùy feedback) |
| **09H**         | Wire Amazon IAP thật (hoặc Google Play Billing nếu launch song song), thay mock `IapService` | 🟡 Trung bình (cần có monetization trước khi public submit) |
| **09I**         | Quyết định Firebase: hoặc gỡ `firebase_core` nếu không dùng, hoặc wire Analytics/Crashlytics + thêm `android.permission.INTERNET` vào release manifest | 🟡 Trung bình |
| **09J**         | Quyết định Audio: gỡ tab nếu chưa wire real playback, hoặc wire `just_audio`/`audioplayers` | 🟡 Trung bình |
| **09K**         | Store listing assets: screenshots, feature graphic, descriptions, privacy policy, age rating | 🔴 Cao (cần khi upload Amazon) |

## Known issues / limitations

Chi tiết trong [`KNOWN_ISSUES.md`](KNOWN_ISSUES.md). Tóm tắt:

1. **Debug signing** — store-blocker.
2. **IAP hoàn toàn mock** — không thực hiện payment thật, chỉ persist local entitlement.
3. **`android.permission.INTERNET` thiếu trong release manifest** — latent, sẽ vỡ khi wire Firestore/Auth/Analytics.
4. **Firebase init but unused** — không gây crash nhưng tăng size APK + complexity không cần thiết.
5. **Audio tab mock** — không có package playback thật.
6. **Affiliate banner** — mở external URL Amazon qua `url_launcher`, không có deeplink tracking.
7. **Devotional/Plan content** — đảm bảo wording Catholic devotional phù hợp Amazon content policy trước store submit (review thủ công).
