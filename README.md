# VerseLight

Daily Bible devotional Flutter app — Android MVP.

Package: `com.versestudio.verselight`

## Status

- Firebase Core initialized (no Auth/Firestore/Storage yet).
- Local persistence via `shared_preferences`.
- Offline content library, reading plans, journal, audio playback.
- Premium / IAP mock architecture (no real Google Play Billing / Amazon IAP wired).
- AI Prayer Partner is a placeholder — no LLM keys live in the client.

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for full setup and Firebase steps.

## Run locally

```bash
flutter pub get
flutter run
```

## Pre-release checklist (Phase 06 — App Store / Amazon Appstore readiness)

Run these before producing a build for either store. None of the steps below
publish anything — they only verify the local app is store-ready.

### 1. Code health

```bash
flutter analyze
flutter test
flutter build apk --release
```

All three must finish without errors.

### 2. Identity

- [ ] `applicationId` in `android/app/build.gradle.kts` = `com.versestudio.verselight` (do **not** change after first submission).
- [ ] `android:label="VerseLight"` in `android/app/src/main/AndroidManifest.xml`.
- [ ] `version: x.y.z+N` in `pubspec.yaml` bumped for each store upload (`+N` is the integer versionCode).

### 3. Legal / metadata

- [ ] `AppConstants.privacyUrl`, `termsUrl`, `helpUrl`, `supportEmail` in
      [lib/utils/constants.dart](lib/utils/constants.dart) replaced with
      production URLs (currently placeholders, marked with `TODO(store-ready)`).
- [ ] Privacy policy & Terms pages live and reachable from outside the app.
- [ ] Settings → Legal links open in browser successfully on a real device.

### 4. Affiliate disclosure

- [ ] Shop screen shows: "As an Amazon Associate we earn from qualifying purchases."
- [ ] Settings footer shows the same disclosure.
- [ ] `AppConstants.amazonTrackingId` replaced with the real Associates tag once approved.

### 5. Premium / IAP

- [ ] Premium entitlement is still served by the **mock** IAP service — do **not**
      ship to production storefronts until real billing is wired in a later phase.
- [ ] Restore-purchases tile works against the local mock entitlement.

### 6. Secrets / security

- [ ] No `sk-…`, `OPENAI_KEY`, `openAiKey`, or other provider secrets anywhere in
      `lib/`, `android/`, `assets/`, `pubspec.yaml`, or `--dart-define` usage.
- [ ] `lib/firebase_options.dart` contains only the public client config (the
      `apiKey` field there is the Firebase **client** key, which is safe to ship).
- [ ] AI calls (when added) go through a server you control — never directly from
      the Flutter client. See `lib/services/ai_service.dart`.

### 7. Android permissions

- [ ] `android/app/src/main/AndroidManifest.xml` declares only what is actually
      used (currently: no extra permissions — `INTERNET` lives in the debug
      manifest only, which is correct because release-mode networking is not yet
      required outside `url_launcher` opening external apps).
- [ ] Add `INTERNET` to the main manifest **only** when a real network feature
      (Firebase Auth, Analytics, AI backend, etc.) is wired up.

### 8. Visual assets (Phase 07 — in progress)

**Done in this repo:**

- Splash background switched from raw white to brand cream
  (`@color/brand_cream` = `#FFF9F2`) in
  `android/app/src/main/res/values/colors.xml` +
  `drawable[-v21]/launch_background.xml` +
  `values[-night]/styles.xml` — splash now blends smoothly into
  `AppColors.cream` (`lib/utils/theme.dart`).
- App theme already in brand voice: Lora (serif) headlines + Inter body,
  gold primary, sage secondary, warm-brown text, 16/12 card/button radii.

**Still required before first store submission:**

- [ ] **App icon** — `android/app/src/main/res/mipmap-*` still holds the
      default Flutter "F" launcher PNG. Replace with brand artwork:
  - 512×512 master PNG (Play Store + Amazon listing)
  - 1024×1024 master if also targeting iOS later
  - Adaptive icon (Android 8+): 108×108 dp foreground + background
    (`drawable/ic_launcher_foreground.xml` and
    `mipmap-anydpi-v26/ic_launcher.xml`)
  - Round icon variant (`mipmap-*/ic_launcher_round.png`)
  - Recommended tooling: add `flutter_launcher_icons` to `dev_dependencies`
    only when the master PNG is ready. Do **not** add the package without
    artwork — it would silently overwrite the default with empty output.
- [ ] **Splash artwork** — current splash is a solid cream rectangle. Once
      a brand wordmark/symbol exists, drop it into `drawable*/` and
      uncomment the centered `<bitmap>` block in `launch_background.xml`
      (TODOs left in both files). Optional: switch to
      `flutter_native_splash` once artwork is ready.
- [ ] **Store listing graphics** (produced outside this repo):
  - Google Play: 512×512 icon, 1024×500 feature graphic, ≥2 phone
    screenshots (16:9 or 9:16, min 320 px), optional 7-inch / 10-inch
    tablet screenshots.
  - Amazon Appstore: 512×512 icon, 1024×500 small banner, 1920×1080
    promo image (if featured), ≥3 screenshots per supported device class
    (Phone, Fire HD 8 800×1280, Fire HD 10 1200×1920).

### 9. Store screenshots — capture checklist

Screenshots are **not** produced in-repo. When ready, capture each screen
on at least one phone emulator and (if targeting Amazon) one Fire tablet
emulator. Reset local data first (`Settings → Reset local data`) so the
demo state looks clean.

| # | Screen | Route / how to reach | What to show |
|---|--------|----------------------|--------------|
| 1 | Home | `BottomNav → Home` | Verse of the day + today's devotional card |
| 2 | Devotional detail | tap a devotional card | Title, verse, body, journal entry CTA |
| 3 | Journal | `BottomNav → Journal` | List with ≥2 sample entries |
| 4 | Reading Plan detail | `Plans → tap a plan` | Plan title, progress bar, day list |
| 5 | Audio | `Plans → Audio` or bottom nav | Player UI with a sample track loaded |
| 6 | Shop | `BottomNav → Shop` | Affiliate disclosure + at least one banner |
| 7 | Paywall | tap `Upgrade` in Settings or a locked card | Plans, "Restore purchases", legal links |
| 8 | Settings | `BottomNav → Settings` | Premium tile, Legal links, affiliate footer |

Suggested device matrix (none are produced in this phase, just listed):

- Phone: Pixel 6 API 34 emulator (1080×2400).
- Fire tablet: Fire HD 8 emulator profile or a real Fire HD 8 (800×1280).
- Optional: Fire HD 10 (1200×1920) if listing on Amazon.

### 9. Build verification

```bash
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

Currently signed with the **debug** key for local smoke-tests
(see `android/app/build.gradle.kts`). Replace with a real keystore + `key.properties`
before uploading to either store — see SETUP_GUIDE.md step 9.

## Phase status

| Phase | Status |
|-------|--------|
| 01 — MVP local flow | ✅ |
| 02 — Local persistence | ✅ |
| 03 — Content library + reading polish | ✅ |
| 04 — Offline content & plan progress | ✅ |
| 05 — Premium / IAP mock architecture | ✅ |
| 06 — Store readiness audit | ✅ checklist landed |
| 07 — Visual identity basics (splash + theme audit + asset checklist) | ✅ splash on-brand; icon/wordmark pending real artwork |
| 08 — Real Google Play Billing / Amazon IAP | ⏳ |
| 09 — Firebase Auth / Firestore (if needed) | ⏳ |
| 10 — AI Prayer Partner via secure backend | ⏳ |
