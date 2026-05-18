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

### 8. Visual assets (deferred — Phase 07)

- [ ] **App icon**: `android/app/src/main/res/mipmap-*` still contains the
      default Flutter launcher icon. Replace with a 512×512 master + adaptive
      icon foreground/background before the first store submission. Recommended:
      `flutter_launcher_icons` package.
- [ ] **Splash**: `android/app/src/main/res/drawable/launch_background.xml` is
      still a plain white background. Replace with branded splash before
      submission. Recommended: `flutter_native_splash` package.
- [ ] **Store listing assets**: 512×512 store icon, feature graphic, and ≥3
      screenshots per device class — produced outside this repo.

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
| 06 — Store readiness audit (this phase) | ✅ checklist landed |
| 07 — Real icon / splash / store assets | ⏳ |
| 08 — Real Google Play Billing / Amazon IAP | ⏳ |
| 09 — Firebase Auth / Firestore (if needed) | ⏳ |
| 10 — AI Prayer Partner via secure backend | ⏳ |
