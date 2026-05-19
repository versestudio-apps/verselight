# VerseLight — Phase 09D Beta Release Notes

## Build info

| Field            | Value                                                              |
|------------------|--------------------------------------------------------------------|
| Version          | `1.0.0+1` (pubspec) — đóng gói dưới tên beta `v1.0.0-beta`         |
| Commit           | `74648e79c1aecf7ff8495dc77a0d626e586034a3` (branch `main`)         |
| Build type       | Android release APK (`flutter build apk --release`)                |
| applicationId    | `com.versestudio.verselight`                                       |
| Signing          | Debug signing (Flutter default release fallback — chưa upload key) |
| Flutter / Dart   | 3.35.3 stable / Dart 3.9.2                                         |
| Min Android      | API 26 (Android 8.0)                                               |
| APK file         | `VerseLight-v1.0.0-beta-android.apk`                               |
| APK size         | 53,979,781 bytes (~51.5 MB)                                        |
| SHA256           | `33450A323568DB86CD80B7D05BC3E8D20644E2022D6C1D56A64AFAFDCAF07214` |
| Generated        | 2026-05-19 13:32 +07:00                                            |

> Lưu ý: pubspec hiện ở `1.0.0+1`, tên file beta dùng `v1.0.0-beta` để khớp với version thực. Không tự ý đổi pubspec ở phase này.

## What's new (kể từ các phase 09)

- **Phase 09A — Branded launcher icon:** icon launcher mới (nền kem + biểu tượng Kinh Thánh & Thánh giá), adaptive icon API 26+, thay icon Flutter default xanh.
- **Phase 09B — Devotional / Plan image frame fix:** sửa layout khung ảnh ngang trong devotional & plan card / detail, không còn bị crop méo / tràn viền.
- **Phase 09C — Branded splash + bootstrap loading:** native launch screen có biểu tượng VerseLight căn giữa trên nền kem; màn loading Flutter có wordmark "VerseLight" (Lora) + tagline + spinner vàng — bridge mượt từ native splash → Home.

## Phần CHƯA phải production

- **IAP / Premium entitlement:** đang là **mock** local (lưu trong shared preferences). Chưa wire vào Google Play Billing thật / Amazon IAP thật. Tester không cần (và không được) test thanh toán thật.
- **Firebase:** mới ở mức `Firebase.initializeApp` từ `firebase_options.dart`. Chưa dùng Firestore / Auth / Analytics ở mức production.
- **Signing:** APK đang ký bằng debug keystore (Flutter mặc định cho release build khi chưa có upload key). **Không** dùng APK này để upload lên Amazon Appstore production — chỉ dùng cho manual testing / internal beta.
- **Store listing:** chưa chuẩn bị (screenshot, mô tả, age rating, privacy policy URL).

## Hướng dẫn gửi tester

1. Gửi 3 file sau cho tester (cùng 1 link drive / cùng 1 thư mục):
   - `VerseLight-v1.0.0-beta-android.apk`
   - `VerseLight-v1.0.0-beta-android.sha256.txt`
   - `TESTER_CHECKLIST.md`
2. Nhắc tester verify SHA256 trước khi cài để chắc APK không bị hỏng / sửa khi truyền.
3. Tester làm theo `TESTER_CHECKLIST.md`, gửi lại bản đã đánh dấu Pass/Fail + screenshot/video lỗi (nếu có).
4. Sau khi nhận đủ checklist từ tester, team review lỗi blocker → quyết định fix tiếp hay tiến tới chuẩn bị upload Amazon Appstore (cần upload keystore thật trước khi đóng gói store build).

## Verify SHA256

**Windows (PowerShell):**

```powershell
Get-FileHash .\VerseLight-v1.0.0-beta-android.apk -Algorithm SHA256
```

**macOS / Linux:**

```bash
shasum -a 256 VerseLight-v1.0.0-beta-android.apk
```

Hash phải khớp:

```
33450A323568DB86CD80B7D05BC3E8D20644E2022D6C1D56A64AFAFDCAF07214
```
