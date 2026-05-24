# VerseLight — Release Candidate Checklist (First Amazon Appstore Submission)

> Consolidated, single-source-of-truth checklist for what remains before the
> first production submission of VerseLight `1.0.0` to Amazon Appstore.
> Folds in the status from Phases 09D → 09L. Use this file (not the original
> README §1-§9 checklist) as the working tracker — README's pre-release block
> remains as a generic per-build smoke-test, not a submission gate.
>
> Legend: ✅ done · ⚠️ owner action required · 🔒 strategy locked but not yet
> applied (apply at submission time).

---

## A. Code-side blockers (engineering-owned)

| Item | Status | Source phase | Notes |
|------|--------|--------------|-------|
| Release signing config wired (`key.properties` + `signingConfigs`) | ✅ | 09F | `android/app/build.gradle.kts` loads gitignored `key.properties`. |
| Upload keystore generated + stored outside repo | ✅ | 09G | `%USERPROFILE%\.android\verselight-upload-key.jks`, SHA-256 `2abe1d86…f96c`. |
| First release-signed APK produced + verified | ✅ | 09G | `apksigner verify` cert DN = `CN=VerseLight, …`. |
| Mock IAP surface gated behind feature flag | ✅ | 09H | `kEnableMockPurchases=false`; no Subscribe/Restore visible. |
| `INTERNET` permission in release merged manifest | ✅ | 09I | Declared at `AndroidManifest.xml:8`. |
| Firebase init decision (keep skeleton, don't wire products) | ✅ | 09I | Documented; no data collected. |
| Mock Audio tab gated behind feature flag | ✅ | 09J | `kEnableAudioTab=false`; bottom nav shows 5 tabs. |
| Affiliate disclosure visible (Shop + Settings footer) | ✅ | 09K | "As an Amazon Associate we earn from qualifying purchases." |
| No copyrighted Bible translation wording shipped | ✅ | 09L | All `verseText` paraphrased; `(NIV)` suffixes stripped. |
| `versionCode` / `versionName` bump strategy decided | ✅ | 09M | Monotonic +1 vc, SemVer name — see [AUDIT.md §2](AUDIT.md). |
| `versionCode` bumped to `10` in pubspec (`1.0.0+10`) | 🔒 | 09M | Apply at submission commit, not earlier. See [AUDIT.md §2.5](AUDIT.md). |
| `flutter analyze` clean | ✅ | 09M | `No issues found`. |
| `flutter test` all passing | ✅ | 09M | 13/13. |
| `flutter build apk --release` succeeds | ✅ | 09M | 51.4 MB APK produced. |
| `git diff --check` clean | ✅ | 09M | No whitespace errors. |

→ **All code-side blockers are either ✅ or 🔒 (one-line bump pending).**

---

## B. Owner-side blockers (asset / URL / account work — not in code)

| Item | Status | Source phase | Notes |
|------|--------|--------------|-------|
| Real Privacy Policy URL published + reachable | ⚠️ | 09K | Replace `https://versestudio-apps.github.io/privacy/` placeholder in [`AppConstants.privacyUrl`](../../../lib/utils/constants.dart). |
| Real Terms of Service URL (separate from privacy) | ⚠️ | 09K | `AppConstants.termsUrl` currently = `privacyUrl`. |
| Real Help / FAQ URL | ⚠️ | 09K | `AppConstants.helpUrl` placeholder. Optional: remove Help tile if no page. |
| Real support email (not `@example.com`) | ⚠️ | 09K | `AppConstants.supportEmail = 'support@example.com'` — RFC 2606 reserved. |
| Amazon Associates account approved | ⚠️ | 09K | Required before real tracking tag. |
| Real Amazon Associates tracking tag wired | ⚠️ | 09K | Replace `verselight-placeholder-20` in `AppConstants.amazonTrackingId`. |
| 512×512 store icon (PNG, sRGB) | ⚠️ | 09K | Export from brand artwork; separate from launcher icon. |
| 1024×500 feature graphic / small banner | ⚠️ | 09K | Amazon "small banner" slot. |
| 1920×1080 promo image (optional, for featuring) | ⚠️ | 09K | Optional but recommended. |
| ≥3 phone screenshots (Pixel 6, 1080×2400) | ⚠️ | 09K | Routes per README §9 minus Audio (now hidden). |
| ≥3 Fire HD 8 screenshots (800×1280) | ⚠️ | 09K | Required for Amazon Fire tablet coverage. |
| Fire HD 10 screenshots (1200×1920) — optional | ⚠️ | 09K | Boosts Fire tablet listing quality. |
| Short description (≤80 chars) | ⚠️ | 09K | Listing copy. |
| Long description (≤4000 chars) | ⚠️ | 09K | Listing copy. |
| Content rating / IARC questionnaire answered | ⚠️ | 09K | App likely "Everyone" (no ads, no UGC, devotional content). |
| Data safety questionnaire answered | ⚠️ | 09K | Truthful answer set: no PII collection, no third-party tracking, local-only data. |
| Bible translation licensing (NABRE / RSV-CE / etc.) | ⏭️ | 09L | Optional — paraphrase ships now; licensed translation is a post-launch content phase. |
| Real Amazon IAP wired (replace mock) | ⏭️ | 09H roadmap | Optional for 1.0.0 — submit without paywall, add in 1.1.0. |
| Crashlytics / Analytics decision | ⏭️ | 09I | Optional for 1.0.0 — adding either triggers a privacy-policy revision. |

→ **All ⚠️ items are owner deliverables that cannot be produced from code.**
The ⏭️ items are post-launch options, not first-submission blockers.

---

## C. Submission-day runbook

When owner has cleared all ⚠️ items in §B, the submission commit looks like:

1. Pull latest `main` and confirm clean working tree.
2. Edit [`pubspec.yaml`](../../../pubspec.yaml) line 5:
   `version: 1.0.0+1` → `version: 1.0.0+10`.
3. Edit [`lib/utils/constants.dart`](../../../lib/utils/constants.dart) — wire real
   `privacyUrl`, `termsUrl`, `helpUrl`, `supportEmail`, `amazonTrackingId`.
4. Remove the "Placeholder — update before launch" subtitle on the Terms tile
   in [`lib/screens/settings_screen.dart:101`](../../../lib/screens/settings_screen.dart).
5. `flutter clean && flutter pub get`.
6. `flutter analyze && flutter test`.
7. `flutter build apk --release` — confirms versionCode in APK metadata:
   ```
   aapt dump badging build/app/outputs/flutter-apk/app-release.apk | findstr "versionCode versionName package"
   ```
   Expected: `versionCode='10' versionName='1.0.0'`.
8. `apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk`
   — confirm cert SHA-256 matches the Phase 09G fingerprint.
9. Rename + archive APK under `docs/releases/phase-09N-amazon-submission/`
   as `VerseLight-v1.0.0-vc10-amazon.apk` (APK gitignored; commit the
   `RELEASE_NOTES.md` + `.sha256.txt` siblings only — same pattern as 09G).
10. Commit with a single conventional-commit message describing the
    submission (`release(android): bump to 1.0.0+10 for Amazon Appstore submission`).
11. Upload `app-release.apk` to Amazon Developer console, paste in the
    listing copy + screenshots from §B, submit for review.

If Amazon rejects: bump `versionCode` to `11`, fix the rejection cause,
re-upload. Repeat (`12`, `13`, …) until accepted.

---

## D. Post-acceptance hygiene

Once Amazon accepts and the listing goes live:

- Tag the git commit: `git tag -a v1.0.0-amazon -m "First Amazon Appstore release"`.
- Add an entry to (or create) `docs/releases/CHANGELOG.md` noting `vc=10`
  shipped on `YYYY-MM-DD`.
- Capture the live Amazon listing URL + ASIN in
  `docs/releases/phase-09N-amazon-submission/RELEASE_NOTES.md`.
- Open Phase 10 (or whichever the team picks next) — typically real IAP
  wiring + Crashlytics, since live users mean real crash data becomes
  valuable.
