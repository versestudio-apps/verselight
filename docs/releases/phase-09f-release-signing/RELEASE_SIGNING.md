# VerseLight — Phase 09F Release Signing Setup

> Hướng dẫn setup upload keystore và build signed release APK cho Amazon Appstore.
> File này **KHÔNG** chứa secret nào. Mọi password / keystore thật đều phải nằm
> ngoài repo và được nhập thủ công trên máy build.

## Mục tiêu Phase 09F

- Thay debug signing (Flutter default) bằng **release signing thật** dùng upload keystore của VerseLight.
- Build ra APK đủ điều kiện upload Amazon Appstore (release-signed, stable cert).
- Đảm bảo keystore + password **không bao giờ** lọt vào git history.
- Local dev / beta sideload vẫn build được khi chưa có keystore (fallback về debug — KHÔNG dùng cho store).

## Các file KHÔNG được commit

Đã được `.gitignore` chặn từ Phase 09F:

```
android/key.properties        ← config thật, chứa password
key.properties                ← phòng trường hợp đặt sai chỗ
*.jks                         ← keystore Java
*.keystore                    ← keystore (alt naming)
*.p12                         ← PKCS#12 keystore
*.pem                         ← PEM cert/key
*.key                         ← raw private key
```

File **được** commit (chỉ template placeholder):

```
android/key.properties.example  ← template, CHANGE_ME placeholders only
```

Khi review PR, nếu thấy bất kỳ file `.jks`/`.keystore`/`key.properties` (không `.example`) trong diff → **stop và investigate**, không merge.

## 1. Tạo upload keystore (chạy 1 lần, lưu ngoài repo)

Trên Windows (PowerShell hoặc cmd). Yêu cầu JDK đã cài (đi kèm Android Studio hoặc cài riêng — `keytool` nằm trong `$env:JAVA_HOME\bin\` hoặc Android Studio `jbr/bin/`).

**Vị trí lưu keystore đề xuất (ngoài repo):**

```
C:\Users\Admin\.android\verselight-upload-key.jks
```

> Lý do: thư mục `.android` của user-profile đã có sẵn các config Android local, không bao giờ nằm trong workspace git, ít rủi ro accidentally commit.

**Lệnh tạo keystore:**

```powershell
# Tạo thư mục nếu chưa có
New-Item -ItemType Directory -Force "$env:USERPROFILE\.android" | Out-Null

# Generate keystore (sẽ prompt nhập password 2 lần + Distinguished Name)
keytool -genkey -v `
  -keystore "$env:USERPROFILE\.android\verselight-upload-key.jks" `
  -alias verselight-upload `
  -keyalg RSA -keysize 2048 -validity 9125
```

Trong quá trình, `keytool` sẽ hỏi:
- **Keystore password** — chọn password mạnh, ghi lại nơi an toàn (password manager).
- **First and last name** — VerseLight (hoặc tên studio).
- **Organizational unit** — Mobile.
- **Organization** — Verse Studio (hoặc tên pháp nhân).
- **City / State / Country code** — phù hợp.
- **Key password** — Enter để dùng cùng password với keystore (đơn giản hơn) hoặc đặt khác.

> ⚠️ **Validity 9125 ngày ≈ 25 năm.** Google Play yêu cầu ≥ 25 năm cho upload key; Amazon Appstore không có yêu cầu cứng nhưng nên giữ giống convention.

**Output:** file `verselight-upload-key.jks` (~2-3 KB) ở `$env:USERPROFILE\.android\`.

## 2. Tạo `android/key.properties` local từ template

Trong repo có sẵn template `android/key.properties.example`. Copy nó thành `android/key.properties` (file thật, đã gitignored):

```powershell
Copy-Item android\key.properties.example android\key.properties
```

Mở `android/key.properties` bằng editor và điền giá trị thật:

```properties
storePassword=<password keystore của bạn>
keyPassword=<password key — thường bằng storePassword>
keyAlias=verselight-upload
storeFile=C:\\Users\\Admin\\.android\\verselight-upload-key.jks
```

> Path Windows trong file `.properties` phải escape backslash thành `\\`.

**Sanity check (KHÔNG được skip):**

```powershell
# Phải in ra dòng .gitignore match — nghĩa là file SẼ bị git ignore.
git check-ignore -v android\key.properties
```

Output mong đợi (đại loại):

```
.gitignore:NN:android/key.properties    android/key.properties
```

Nếu không thấy match, **stop ngay** và kiểm tra `.gitignore` trước khi build.

## 3. Build signed release APK

```powershell
flutter clean
flutter pub get
flutter build apk --release
```

Output:

```
build\app\outputs\flutter-apk\app-release.apk
```

Gradle sẽ tự động phát hiện `android/key.properties` (nhờ logic trong [android/app/build.gradle.kts](../../../android/app/build.gradle.kts#L14-L21)) và dùng release signing thay vì debug.

## 4. Verify APK đã signed bằng upload key

Dùng `apksigner` (đi kèm Android SDK build-tools):

```powershell
# Tìm đường dẫn apksigner (Windows, qua Android Studio SDK)
$apksigner = "$env:LOCALAPPDATA\Android\Sdk\build-tools\*\apksigner.bat"
$apksigner = (Get-Item $apksigner | Sort-Object Name -Descending | Select-Object -First 1).FullName

# Verify
& $apksigner verify --print-certs build\app\outputs\flutter-apk\app-release.apk
```

Output cần có:

```
Signer #1 certificate DN: CN=VerseLight, OU=Mobile, O=Verse Studio, ...
Signer #1 certificate SHA-256 digest: <SHA256 của cert>
```

**KHÔNG được thấy** `CN=Android Debug, O=Android, C=US` — nếu thấy nghĩa là vẫn debug-signed (key.properties không được pick up hoặc thiếu).

## 5. Sinh SHA256 cho APK

```powershell
Get-FileHash .\build\app\outputs\flutter-apk\app-release.apk -Algorithm SHA256
```

Ghi lại hash vào release artifact của phase tiếp theo (ví dụ `docs/releases/phase-09f-release-signing/`). Hash này sẽ KHÁC hash của APK debug-signed Phase 09D vì content sigblock đã thay đổi.

## 6. Checklist trước khi upload Amazon Appstore

- [ ] Keystore lưu ngoài repo (`C:\Users\Admin\.android\verselight-upload-key.jks`) — KHÔNG nằm trong workspace `c:\Code\...\VerseLight\`.
- [ ] `git check-ignore android\key.properties` → match.
- [ ] `git status` → không thấy `*.jks` / `*.keystore` / `key.properties` (không `.example`) trong untracked/staged.
- [ ] `apksigner verify --print-certs` confirm cert DN là VerseLight/Verse Studio, KHÔNG phải Android Debug.
- [ ] Keystore + password đã backup vào **password manager** + 1 copy offline an toàn.
- [ ] versionCode đã bump (Phase 09K hoặc trước khi store upload) — chi tiết trong [KNOWN_ISSUES.md #8](../phase-09e-amazon-readiness/KNOWN_ISSUES.md).
- [ ] Đã chạy `flutter analyze` / `flutter test` clean.
- [ ] Đã smoke test trên thiết bị thật ít nhất 1 lần với APK signed mới (sideload qua adb).

## 7. Recovery / mất keystore

**Đây là phần cực kỳ quan trọng. Đọc kỹ trước khi xong Phase 09F.**

Nếu mất upload keystore của VerseLight:

- **Amazon Appstore:** mỗi app dùng cert key riêng. Mất key đồng nghĩa **không thể publish update** cho app đã upload với key đó — phải submit như app mới (với applicationId mới `com.versestudio.verselight2` hoặc tương tự), người dùng cũ phải cài lại từ đầu, không giữ được data.
- **Google Play (nếu launch song song):** tương tự, nếu chưa enroll Play App Signing thì mất key = mất app. Nếu đã enroll Play App Signing, có thể request Google reset upload key (mất ~48h).

**Bảo vệ keystore:**

1. **Password manager (1Password, Bitwarden, KeePass)** — lưu password + alias.
2. **Backup file `.jks`** vào ít nhất 2 nơi an toàn:
   - Encrypted USB drive offline.
   - Encrypted cloud (vd: Backblaze B2 với encryption key tự quản, hoặc 1Password file attachment).
3. **KHÔNG** gửi keystore qua email/Slack/Discord/Telegram, kể cả "tạm thời" cho đồng nghiệp.
4. **KHÔNG** lưu trong `Documents`, `Desktop`, `Downloads`, hoặc bất kỳ thư mục nào đang sync OneDrive/iCloud/Dropbox mặc định (trừ khi folder đó đã encrypted).
5. **Ghi nhớ:** keystore này dùng cho mọi version update tương lai của VerseLight. Đối xử với nó như private key SSH của production server.

## Trạng thái Gradle config sau Phase 09F

[android/app/build.gradle.kts](../../../android/app/build.gradle.kts) đã được cập nhật:

- Đọc `key.properties` từ root project (`android/key.properties`).
- Nếu file tồn tại → tạo `signingConfigs.release` và buildTypes.release dùng nó.
- Nếu file KHÔNG tồn tại → buildTypes.release fallback về `signingConfigs.debug` (giữ local dev / beta sideload chạy được).
- **KHÔNG** hardcode password/path nào trong gradle.

→ Code committed an toàn cho mọi developer (không có secret), nhưng trên máy có `key.properties` thật sẽ build ra signed APK production.
