# VerseLight — Phase 09I Firebase / INTERNET Permission Decision

> Resolve Phase 09E pre-launch items #3 (`INTERNET` missing in release manifest)
> and #4 (Firebase init but unused). Decision: keep Firebase Core as-is, add
> `INTERNET` permission to the release manifest so future Firebase / IAP /
> Analytics work doesn't silently fail.

## Status summary

| Item                                                   | Status |
|--------------------------------------------------------|--------|
| `INTERNET` permission in release merged manifest       | ✅ Present (Phase 09I) |
| Firebase Core left in place                            | ✅ Kept (decision) |
| Firebase Auth / Firestore / Analytics / Crashlytics    | ❌ Not wired (out of scope) |
| User data collected by app                             | ✅ None (still local-only) |
| Sensitive runtime permissions added                    | ❌ None — INTERNET is normal (non-runtime) |

## Audit findings

### Firebase dependency surface

| Where                                    | What's there                                |
|------------------------------------------|---------------------------------------------|
| [pubspec.yaml](../../../pubspec.yaml) `dependencies`  | Only `firebase_core: ^4.9.0`. No `firebase_auth`, `cloud_firestore`, `firebase_analytics`, `firebase_crashlytics`, `firebase_messaging`, `firebase_storage`, `firebase_remote_config`, `cloud_functions`. |
| [android/settings.gradle.kts:24](../../../android/settings.gradle.kts#L24) | `com.google.gms.google-services` v4.3.10 plugin applied. |
| [android/app/google-services.json](../../../android/app/google-services.json) | Generated config present (Firebase project `verselight-app`). |
| [lib/firebase_options.dart](../../../lib/firebase_options.dart) | Auto-generated `FlutterFire` config — `android` entry has app ID / api key / storage bucket. |
| [lib/main.dart:10-12](../../../lib/main.dart#L10-L12) | Single call: `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`. Nothing else uses Firebase APIs. |

### TODO markers referring to future Firebase work

| File                                                                   | Note |
|------------------------------------------------------------------------|------|
| [lib/services/affiliate_service.dart:43](../../../lib/services/affiliate_service.dart#L43) | `// TODO: log affiliate_click via analytics when Firebase is added.` |
| [lib/services/ai_service.dart:6](../../../lib/services/ai_service.dart#L6) | Mentions `Firebase Cloud Function` as a future backend option for AI prayer prompts (currently no AI is wired). |

→ Firebase isn't paying for itself yet, but it's already laid down for the
two most likely next wiring points (Analytics + a Cloud-Function-backed
AI prompt service). Ripping it out now would mean re-installing
`firebase_core`, regenerating `firebase_options.dart` via `flutterfire
configure`, re-running `google-services.json`, and re-applying the gradle
plugin — significant churn for no current safety benefit.

### Network surface

| Where                  | What                                                      |
|------------------------|-----------------------------------------------------------|
| `pubspec.yaml`         | No `http`, `dio`, `chopper`, or other HTTP client. Only `url_launcher` which opens external apps and doesn't need INTERNET. |
| `lib/`                 | No `HttpClient` / `http.Client` usage; no socket code; no streaming. |
| `Firebase.initializeApp()` | Doesn't itself make network calls — registers default app from local config. Subsequent Firebase calls (Analytics, Firestore, Auth) WOULD need INTERNET, but none are wired yet. |
| Affiliate banners      | Use `url_launcher` to open Amazon/Audible URLs in the system browser. The app process itself doesn't fetch. |

### INTERNET permission state — BEFORE Phase 09I

| Manifest                                                                                                           | INTERNET? |
|--------------------------------------------------------------------------------------------------------------------|-----------|
| [android/app/src/debug/AndroidManifest.xml](../../../android/app/src/debug/AndroidManifest.xml)                    | ✅ Yes (Flutter template default for hot-reload / VM service) |
| [android/app/src/profile/AndroidManifest.xml](../../../android/app/src/profile/AndroidManifest.xml)                | ✅ Yes (same reason) |
| [android/app/src/main/AndroidManifest.xml](../../../android/app/src/main/AndroidManifest.xml) — BEFORE             | ❌ No |
| Release merged manifest (before Phase 09I) — `build/app/intermediates/merged_manifests/release/.../AndroidManifest.xml` | ❌ Only auto-injected `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` |

**Why this is a latent risk:**

- App boots fine today because `Firebase.initializeApp()` doesn't make network calls.
- Debug / profile builds *do* have INTERNET → any network call works there.
- A developer adding the first Firebase Analytics event / Crashlytics report / HTTP request would test it in debug (passes) → ship to release → **silently fails** with no exception, just dropped network calls.
- Same bug class would hit when Phase 09H+ wires real Amazon IAP (the store SDK needs internet to validate purchases).

## Decision

**Keep Firebase Core. Add `INTERNET` to the main manifest. Don't wire any Firebase APIs in this phase.**

Reasoning:

- **Don't remove Firebase now:** the setup cost is sunk (plugin, config, generated options, google-services.json). Two TODO callsites already reference Firebase as the planned backend. Ripping out and re-adding later costs more than the ~MB of unused init.
- **Don't wire Analytics/Auth/Crashlytics now:** every Firebase product carries its own privacy implications (data collection disclosures, Amazon Appstore data-safety questionnaire). Wiring them is its own decision/phase.
- **Adding `INTERNET` is the smallest fix** that prevents the "works in dev fails in release" bug from happening the next time anyone touches network code. It's a normal-category permission, no runtime prompt, no Amazon privacy concern, and it brings the release manifest into line with debug/profile.

Alternative considered: gate `Firebase.initializeApp()` behind a `kEnableFirebase` flag, similar to Phase 09H. Rejected because Firebase Core init is harmless without follow-up calls — gating it adds complexity without addressing the real risk (forgotten INTERNET).

## Files changed

| File                                                                                | Change |
|-------------------------------------------------------------------------------------|--------|
| [android/app/src/main/AndroidManifest.xml](../../../android/app/src/main/AndroidManifest.xml) | Added `<uses-permission android:name="android.permission.INTERNET" />` with a comment explaining why. No other manifest changes. |

Nothing else touched. Specifically:

- ❌ No pubspec dependency changes.
- ❌ No `lib/` source changes.
- ❌ No `firebase_options.dart` / `google-services.json` changes.
- ❌ No gradle / signing / `applicationId` / `versionCode` changes.
- ❌ No keystore / `key.properties` touch.
- ❌ No launcher icon / branding changes.
- ❌ No IAP / paywall / UI changes.

## Verification

- `flutter analyze` → **No issues found! (4.2s)**
- `flutter test` → **All tests passed (13/13)** — no test depends on permission state.
- `flutter build apk --release` → **Built build\app\outputs\flutter-apk\app-release.apk (51.4MB)** in 28.0s — same size as Phase 09H output (manifest entry adds bytes < kB granularity reported).
- Release merged manifest re-checked:

```
build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml:18:
    <uses-permission android:name="android.permission.INTERNET" />
```

✅ Present at line 18.

## Privacy / store implications

| Concern                                            | Today's answer                          |
|----------------------------------------------------|-----------------------------------------|
| Does the app collect user data?                    | ❌ No — all data (streak, journal, premium entitlement) stored in local `shared_preferences`. |
| Does the app send data over the network?           | ❌ No outbound traffic from app code. `Firebase.initializeApp()` is local. |
| Does the app track users?                          | ❌ No Analytics / no identifiers collected. |
| Does INTERNET permission imply data collection?    | ❌ No. INTERNET is a normal-category permission; Amazon's data-safety review focuses on what data is actually sent and which Firebase / SDK products are wired, not the bare presence of `INTERNET`. |
| Will this change Amazon Appstore content rating?   | ❌ No — content rating doesn't depend on permissions. |
| Do we need a privacy policy if we ship today?      | ⚠️ Still required by Amazon Appstore as part of submission (links exist in `AppConstants.privacyUrl` but point to a placeholder GitHub Pages URL — see [09E KNOWN_ISSUES](../phase-09e-amazon-readiness/KNOWN_ISSUES.md) future polish item). |

→ **No new privacy disclosures triggered by Phase 09I.** When a future phase wires
Firebase Analytics or Crashlytics, that's when Amazon's data-safety questionnaire
gets revisited.

## When to revisit Firebase / network

| Trigger                                                                  | What to do |
|--------------------------------------------------------------------------|------------|
| Want app-level crash reporting before public launch                       | Add `firebase_crashlytics`; update privacy policy with crash-report disclosure. |
| Want install/event analytics                                             | Add `firebase_analytics`; update privacy policy + Amazon data-safety form. |
| Want user accounts / sync across devices                                 | Add `firebase_auth` + `cloud_firestore`; substantial privacy/security work — own phase. |
| Want to wire real Amazon IAP (Phase 09H+ trigger)                        | Already need INTERNET for store SDK ping — covered by this phase. |
| Decide we don't want Firebase at all (e.g. switching to Sentry/PostHog)  | Remove `firebase_core` + `google-services` plugin + `firebase_options.dart` + `google-services.json`; INTERNET stays for the replacement. |

## Known issues remaining before Amazon production

From [09E KNOWN_ISSUES.md](../phase-09e-amazon-readiness/KNOWN_ISSUES.md) (post-update):

| # | Severity | Status | Tóm tắt |
|---|----------|--------|---------|
| 1 | 🔴 Store-blocker | ✅ RESOLVED 09F+09G | Debug signing → upload key |
| 2 | 🔴 Store-blocker | ✅ RESOLVED 09H | Mock IAP UI gated by feature flag |
| 3 | 🟡 Pre-launch | ✅ RESOLVED 09I | INTERNET permission added to release manifest |
| 4 | 🟡 Pre-launch | ⚠️ DEFERRED 09I | Firebase init kept; no Analytics/Crashlytics/Auth wired yet (no privacy disclosure required while still init-only) |
| 5 | 🟡 Pre-launch | OPEN | Audio tab still UI-only mock |
| 6 | 🟢 Polish | OPEN | Affiliate banner FTC / EU disclosure |
| 7 | 🟢 Polish | OPEN | Bible translation license review |
| 8 | 🟢 Polish | OPEN | versionCode bump strategy |

→ Both 🔴 store-blockers and 1 of 3 🟡 items cleared. Issue #4 is technically
"deferred" rather than "resolved" — Firebase remains init-only intentionally,
so it doesn't collect data and doesn't change the privacy story. Next priority:
**09J (Audio mock decision)** and **09K (store listing assets + privacy URL)**.
