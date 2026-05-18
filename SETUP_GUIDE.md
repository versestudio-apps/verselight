# 🚀 VerseLight — Flutter Setup Guide
> Chạy từng bước theo thứ tự. Copy & paste vào terminal.

---

## BƯỚC 1 — Cài Flutter SDK

Tải Flutter tại: https://docs.flutter.dev/get-started/install/windows

Sau khi cài xong, mở terminal (Command Prompt hoặc PowerShell):

```bash
flutter doctor
```

✅ Mục tiêu: thấy `[✓] Flutter` và `[✓] Android toolchain`

---

## BƯỚC 2 — Tạo project Flutter

```bash
# Mở terminal, cd đến thư mục muốn để project
cd "C:\Users\Admin\Documents\Claude\Projects\Dự Án APP Amazon"

# Tạo project (CHỈ chạy 1 lần!)
flutter create verselight --org com.versestudio --platforms android

# Package name sẽ là: com.versestudio.verselight
# ⚠️ KHÔNG thay đổi package name sau khi submit lên store
```

---

## BƯỚC 3 — Copy source files vào project

Các file đã được tạo sẵn trong folder `verselight/`. Chúng sẽ ghi đè các file mặc định:
- `lib/main.dart` ✅
- `lib/utils/constants.dart` ✅
- `lib/utils/theme.dart` ✅
- `lib/screens/*.dart` ✅ (6 screens)
- `lib/services/*.dart` ✅ (IAP, Affiliate)
- `lib/widgets/*.dart` ✅ (VerseCard, AffiliateBanner)
- `pubspec.yaml` ✅

---

## BƯỚC 4 — Install packages

```bash
cd verselight
flutter pub get
```

---

## BƯỚC 5 — Tải Lora font (bắt buộc)

Tải 3 file font tại: https://fonts.google.com/specimen/Lora

Copy vào: `verselight/assets/fonts/`
- `Lora-Regular.ttf`
- `Lora-Bold.ttf`
- `Lora-Italic.ttf`

---

## BƯỚC 6 — Setup Firebase

```bash
# Cài FlutterFire CLI (chạy 1 lần)
dart pub global activate flutterfire_cli

# Tạo Firebase project tại: https://console.firebase.google.com
# Tên project: verselight-app

# Kết nối Flutter với Firebase (chạy trong folder verselight/)
flutterfire configure
```

Chọn:
- Project: `verselight-app`
- Platforms: `android`

Sau khi chạy xong, sẽ tạo file `lib/firebase_options.dart` tự động.

Sau đó, thêm vào `main.dart`:
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## BƯỚC 7 — Kết nối Fire Tablet (để test)

```bash
# Bật Developer Options trên Fire Tablet:
# Settings → Device Options → Serial Number (tap 7 lần) → Developer Options → USB Debugging ON

# Check kết nối
adb devices

# Chạy app trên tablet
flutter run
```

Nếu không có tablet, test trên Android Emulator:
```bash
flutter emulators --launch Pixel_5_API_33
flutter run
```

---

## BƯỚC 8 — Build APK để submit

```bash
# Build release APK
flutter build apk --release

# File APK ở:
# build/app/outputs/flutter-apk/app-release.apk
```

> **AI / OpenAI:** Không đưa API key LLM vào Flutter app (không dùng `--dart-define`, không hardcode trong code).
> Khi cần tính năng AI, gọi backend bạn kiểm soát (Firebase Function, server riêng, Cloudflare Worker);
> secret chỉ lưu phía server.

---

## BƯỚC 9 — Tạo Keystore (ký APK — chỉ làm 1 lần!)

```bash
# Tạo keystore — LƯU FILE NÀY VÀ MẬT KHẨU RẤT CẨN THẬN!
keytool -genkey -v -keystore verselight-key.jks ^
  -keyalg RSA -keysize 2048 -validity 10000 ^
  -alias versestudio

# Điền thông tin:
# First and Last Name: VerseStudio
# Organization: VerseStudio
# City: Ho Chi Minh
# Country Code: VN
```

Tạo file `android/key.properties`:
```
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=versestudio
storeFile=../../verselight-key.jks
```

---

## CHECKLIST TRƯỚC KHI SUBMIT

- [ ] `flutter build apk --release` không có lỗi
- [ ] App chạy OK trên Android emulator / Fire tablet
- [ ] Privacy Policy URL hoạt động: https://versestudio-apps.github.io/privacy/
- [ ] Amazon Associates tag đúng: `versestudio-apps-20`
- [ ] IAP SKUs đăng ký trong Amazon Developer Console
- [ ] App icon (512×512px PNG) đã chuẩn bị
- [ ] Screenshots Fire HD 8 (800×1280px, tối thiểu 3 tấm)
- [ ] Short description (≤80 ký tự)
- [ ] Long description (≤4000 ký tự)

---

## CÁC LỆNH HAY DÙNG

```bash
flutter pub get          # Install packages
flutter run              # Chạy debug trên device
flutter build apk        # Build APK
flutter clean            # Xóa cache (khi có lỗi lạ)
flutter pub upgrade      # Update packages
dart fix --apply         # Auto-fix Dart warnings
```

---

## TROUBLESHOOTING

**Lỗi: `firebase_options.dart not found`**
→ Chạy `flutterfire configure` trước

**Lỗi: `Font not found`**
→ Copy file .ttf vào `assets/fonts/` rồi `flutter pub get`

**Lỗi: `IAP not working on emulator`**
→ IAP chỉ hoạt động trên Fire tablet thật. Dùng `IapService.instance.mockPremiumForTesting()` khi test.

**Lỗi: `Shop screen import error`**
→ File `shop_screen.dart` có 2 import blocks — gộp lại thành 1

**APK release còn bundle file asset cũ sau khi rename / đổi extension (vd PNG → WebP)**

Trên Windows, `flutter clean` đôi khi không xoá hết `build/` và `.dart_tool/`
nếu Gradle/Java daemon đang giữ file lock (output thường báo "Deleting
build... 44ms" — nhanh bất thường vì một số file bị skip im lặng). Lần
build tiếp theo có thể tái sử dụng cached asset bundle từ đợt build trước
→ APK còn chứa cả file cũ lẫn file mới (vd cả `.png` cũ và `.webp` mới).

Triệu chứng: kích thước APK release lớn bất thường, hoặc giải nén APK
thấy có cả 2 extension dù filesystem chỉ còn 1.

Cách xử lý an toàn (chỉ cần khi rename / đổi extension asset, không cần
cho thay đổi code Dart bình thường):

```powershell
# 1. Dừng mọi Gradle / Java daemon đang chạy
Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force

# 2. Xoá thủ công build & cache dirs
Remove-Item -Recurse -Force build, .dart_tool, android/.gradle `
  -ErrorAction SilentlyContinue

# 3. Build lại từ đầu
flutter build apk --release
```

Hoặc bash equivalent (cần kill Java trước cùng cách):
```bash
rm -rf build .dart_tool android/.gradle .flutter-plugins-dependencies
flutter build apk --release
```

Sau đó verify APK không còn file extension cũ:
```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
$apk = 'build/app/outputs/flutter-apk/app-release.apk'
$zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path $apk))
$zip.Entries | Where-Object { $_.FullName -match '\.png$|\.webp$' } |
  Group-Object { [System.IO.Path]::GetExtension($_.FullName) } |
  Format-Table Name, Count
$zip.Dispose()
```

Lý do `flutter clean` đơn thuần không đủ: Flutter SDK ghi staged assets
vào `build/app/intermediates/flutter/release/flutter_assets/` qua task
`mergeFlutterAssets`. Nếu thư mục này không được xoá triệt để (do file
lock), task này sẽ bỏ qua bước "regenerate", chỉ ghi đè file mới và để
file cũ nguyên — kết quả là cả 2 cùng lọt vào AAR merge → APK final.
