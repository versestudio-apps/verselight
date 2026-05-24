# VerseLight — Phase 09S Amazon Submission Release Notes

> First release-signed APK produced specifically for upload to the Amazon
> Appstore. Built from the `1.0.0+10` pubspec bump (Phase 09S) on top of
> the Phase 09Q (Shop gate) + Phase 09R (real support email, hidden
> Terms/Help) cleanup commits. APK binary is gitignored under `/build/`;
> only this `RELEASE_NOTES.md` and the sibling `sha256.txt` are tracked.

## Build identity

| Field                  | Value                                                                  |
|------------------------|------------------------------------------------------------------------|
| Source commit          | `97f6bf5` (`release: bump to 1.0.0+10 for Amazon Appstore submission`) |
| Branch                 | `main`                                                                 |
| versionName            | `1.0.0`                                                                |
| versionCode            | `10`                                                                   |
| Package                | `com.versestudio.verselight`                                           |
| Build type             | Android release APK (`flutter build apk --release`)                    |
| Build script           | [`scripts/build-submission-apk.ps1`](../../../scripts/build-submission-apk.ps1) |
| Built on               | 2026-05-25 04:42:55 (+07:00, local)                                    |
| Flutter / Dart         | 3.35.3 stable / Dart 3.9.2                                             |
| Min Android            | API 24 (Android 7.0 Nougat)                                            |
| Target Android         | API 36 (Android 16)                                                    |

## APK artifact

| Field           | Value                                                                  |
|-----------------|------------------------------------------------------------------------|
| Local path      | `build/app/outputs/flutter-apk/app-release.apk`                        |
| Size (bytes)    | `53,864,293`                                                           |
| Size (MB)       | `51.37 MB`                                                             |
| SHA-256         | `E8BA9B81A6345B40DC6CD48886672CCE9AB4D16DFBAEA5153FA439690EDCA8E3`     |

The APK binary is **not** committed to the repository (gitignored via the
existing `/build/` rule and the `docs/releases/**/*.apk` rule). To
reproduce the same APK from this commit, run:

```powershell
PowerShell -ExecutionPolicy Bypass -File scripts\build-submission-apk.ps1
```

The script hard-cleans every cache layer that has been observed to
short-circuit in Phases 09O / 09P / 09R (Gradle incremental cache
producing stale Dart code), runs analyze + test + build, and verifies
the APK with aapt and apksigner before printing a green summary. A
fresh build of this commit should produce an APK with the same
versionCode (`10`) and the same signing cert; the SHA-256 hash will
differ slightly per build because Gradle embeds build timestamps.

## Signing identity

| Field                  | Value                                                                  |
|------------------------|------------------------------------------------------------------------|
| Signer DN              | `CN=VerseLight, OU=Mobile, O=Verse Studio, L=Bien Hoa, ST=Dong Nai, C=VN` |
| Signing cert SHA-256   | `2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c`     |
| Keystore source        | VerseLight upload key generated in Phase 09F / 09G                     |
| Keystore location      | `%USERPROFILE%\.android\verselight-upload-key.jks` (OUTSIDE repo)      |

The cert SHA-256 above is the **permanent identity of VerseLight on
Android**. Every future submission must be signed with the same keystore
— Amazon (and Play) will reject an update whose signing cert differs
from the first accepted one, and existing user installs cannot be
upgraded across a cert change. See
[`docs/releases/phase-09g-signed-apk/RELEASE_NOTES.md`](../phase-09g-signed-apk/RELEASE_NOTES.md)
for the full keystore-handling protocol.

## Engineering gates passed

| Gate                                                                  | Result |
|-----------------------------------------------------------------------|--------|
| `flutter analyze`                                                     | `No issues found! (ran in 4.7s)` |
| `flutter test`                                                        | 13 / 13 passed                   |
| Hard clean build (`flutter clean` + wipe build/.dart_tool/.gradle/app-build) | 53 seconds (above the 25 s cache-shortcircuit threshold) |
| `flutter build apk --release`                                         | `Built build\app\outputs\flutter-apk\app-release.apk (51.4MB)` |
| `aapt dump badging` — versionCode / versionName / package / SDK / permissions | versionCode=`10`, versionName=`1.0.0`, package=`com.versestudio.verselight`, sdkVersion=24, targetSdkVersion=36, INTERNET-only permission, application-label='VerseLight' |
| `apksigner verify --print-certs` — Signer DN + cert SHA-256           | DN matches `CN=VerseLight, O=Verse Studio, ...`, SHA-256 matches Phase 09G upload key fingerprint exactly |
| `git diff --check`                                                    | clean (no whitespace errors)     |

## Notes on what is and isn't in v1.0.0+10

This first Amazon production submission is **deliberately scoped down**
compared to the full feature set planned for VerseLight. The following
surfaces are gated off behind feature flags in
[`lib/utils/constants.dart`](../../../lib/utils/constants.dart) so the
store reviewer (and end users) never encounter half-built or
not-yet-verified functionality:

- **Shop tab + affiliate banners** are hidden (`kEnableShopTab = false`
  — Phase 09Q). Phase 09P Fire Tablet QA verified all 4 ASINs in
  `AffiliateService.bibleBooks` returned 404 from Amazon, which would
  fail the Amazon Appstore review and breach the Amazon Associates
  Operating Agreement. The Shop bottom-nav tab, the Home Quick-Access
  Shop tile, the Home "Curated for you" section (NIV + Audible
  banners), and the Audible footer banner on the Devotional list are
  all hidden until live ASINs and a real Associates tag are wired.
- **Audio tab + mock player** are hidden (`kEnableAudioTab = false` —
  Phase 09J). Re-enables in one flag flip once real audio playback
  (e.g. `just_audio`) is wired with bundled or streamed assets.
- **Mock in-app purchase surface** is gated (`kEnableMockPurchases =
  false` — Phase 09H). No Subscribe / Restore buttons, no price labels,
  no `(mock)` / `(beta)` purchase copy reaches the user. The Paywall
  route survives as a "Premium coming soon" teaser without a purchase
  path.
- **Terms of Use tile** in Settings is hidden (`kEnableTermsLink =
  false` — Phase 09R). No standalone Terms page exists yet; pointing
  the tile at the Privacy URL with a "Placeholder" subtitle would
  confuse a store reviewer.
- **Help & FAQ tile** in Settings is hidden (`kEnableHelpLink = false`
  — Phase 09R). No Help / FAQ page exists yet; the previous link
  pointed at a non-existent `#help` anchor on the Privacy page.

What **is** in v1.0.0+10 and live for the user:

- Daily devotionals (10 items) with original paraphrase verse text (no
  copyrighted translation wording — Phase 09L).
- Reading plans (5 plans × 7 days = 35 devotionals).
- Prayer journal with local persistence via `shared_preferences`.
- Privacy Policy link to a live, verified-content URL.
- Real support email `versestudio.privacy@gmail.com` matching the
  contact email published in the Privacy Policy.
- Brand splash + launcher icon + cream/gold devotional artwork.
- Bottom navigation with four tabs (Home · Devotional · Journal · Plans).

## How to verify APK integrity (recipient side)

**Windows PowerShell:**

```powershell
Get-FileHash .\app-release.apk -Algorithm SHA256
```

**macOS / Linux:**

```bash
shasum -a 256 app-release.apk
```

Hash must equal:

```
E8BA9B81A6345B40DC6CD48886672CCE9AB4D16DFBAEA5153FA439690EDCA8E3
```

(See `sha256.txt` sibling for the same value in a machine-friendly
format.)

**Signature verification** (requires Android SDK build-tools + JDK):

```powershell
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
& "$env:LOCALAPPDATA\Android\sdk\build-tools\36.0.0\apksigner.bat" `
    verify --print-certs app-release.apk
```

Confirm `Signer #1 certificate SHA-256 digest` matches:

```
2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c
```

## What still has to happen before Amazon goes live

Out of scope for this archival phase (Phase 09T docs-only). All remaining
items are owner deliverables, not engineering blockers:

1. ≥3 Fire HD 8 screenshots (800 × 1280) and ≥3 phone screenshots
   (Pixel 6, 1080 × 2400) per
   [`SCREENSHOTS_PLAN.md`](../phase-09n-store-image-assets/SCREENSHOTS_PLAN.md).
   With the Phase 09Q gate active the visible surface for screenshots
   is Home / Devotional list / Devotional detail / Plans list / Plan
   detail / Journal / Settings (no Shop, no Audio, no Paywall — the
   capture matrix in the plan still applies but skip Shop entirely).
2. Short description (≤ 80 chars) and long description (≤ 4000 chars).
   Avoid mentioning "shopping" / "affiliate" / "Amazon Associates" in
   the copy since the Shop surface is gated for v1.0.
3. IARC content rating questionnaire.
4. Data safety questionnaire — truthful answer set: no PII collection,
   no third-party tracking, no ads, no in-app purchases, no shopping
   (the Phase 09K disclosure profile still applies, minus the Shop
   row).
5. Amazon Developer console: create the app listing under
   `com.versestudio.verselight`, upload `app-release.apk`, paste copy
   + screenshots + questionnaire answers, submit for review.

After Amazon accepts the listing:

- Tag the source commit:
  ```bash
  git tag -a v1.0.0-amazon -m "First Amazon Appstore release" 97f6bf5
  git push origin v1.0.0-amazon
  ```
- Append the live ASIN + listing URL to this file in a follow-up commit.

## Files in this phase

| File                                                                                            | Tracked? |
|-------------------------------------------------------------------------------------------------|----------|
| [`RELEASE_NOTES.md`](RELEASE_NOTES.md)                                                          | yes      |
| [`sha256.txt`](sha256.txt)                                                                      | yes      |
| `app-release.apk` (would live at `build/app/outputs/flutter-apk/app-release.apk`)               | **no** — gitignored |
