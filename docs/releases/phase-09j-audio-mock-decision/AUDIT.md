# VerseLight — Phase 09J Audio Mock Decision

> Resolve Phase 09E pre-launch item #5: the Audio tab is UI-only / mock.
> Phase 09J hides the tab from production navigation behind a feature flag,
> matching the Phase 09H IAP pattern. Audio code is preserved so the flag
> can flip back once a real playback engine and audio assets are wired.

## Status summary

| Item                                                         | Status |
|--------------------------------------------------------------|--------|
| Mock "Playing: …" UI reachable in store build                | ❌ Removed (Audio tab hidden) |
| `AudioScreen`, `sample_audio.dart`, `AudioTrack` preserved   | ✅ Kept — flag-gated, not deleted |
| Real audio playback engine wired (`just_audio` / `audioplayers`) | ❌ Out of scope |
| New permissions added                                        | ❌ None |
| Privacy / data-safety implication                            | ❌ None |

## Audit findings

### Audio source map

| Surface | File | What it does |
|---------|------|--------------|
| Screen UI | [lib/screens/audio_screen.dart](../../../lib/screens/audio_screen.dart) | Track list + `_AudioTrackCard` + `_NowPlayingBar`. `_onPlay` only flips `playingAudioId` in `AppState`; no audio engine. |
| Data | [lib/data/sample_audio.dart](../../../lib/data/sample_audio.dart) | 4 hardcoded metadata-only `AudioTrack` entries (Psalm 23, Morning Devotional — Trust, Gospel of John sample, Worship Playlist — Peace). No matching audio asset files anywhere in the repo. |
| Model | [lib/models/audio_track.dart](../../../lib/models/audio_track.dart) | `AudioTrack` data class with `id` / `title` / `subtitle` / `durationLabel` / `isPremium`. |
| State | [lib/state/app_state.dart](../../../lib/state/app_state.dart) — `playingAudioId`, `setPlayingAudio()` | In-memory + persisted "selected track" id. No timing, no progress, no controls beyond toggle. |
| Persistence | [lib/services/local_storage_service.dart](../../../lib/services/local_storage_service.dart) — `loadPlayingAudioId` / `savePlayingAudioId` | shared_preferences string key `playing_audio_id_v1`. |
| Navigation | [lib/widgets/bottom_nav_shell.dart](../../../lib/widgets/bottom_nav_shell.dart) | Audio at tab index 4 (between Plans and Shop). |
| Home quick-access | [lib/screens/home_screen.dart](../../../lib/screens/home_screen.dart) | "Audio · Listen & reflect" tile in the 2×2 Quick Access grid, calling `appState.selectTab(4)`. |
| Tests | none | No audio tests in `test/`. |

### Real-playback prerequisites — currently absent

- `pubspec.yaml` does **not** list `just_audio`, `audioplayers`, `audio_service`, or any other Flutter audio plugin.
- `pubspec.yaml` does **not** declare any `assets/audio/` (or similar) asset directory.
- `assets/` on disk contains only `branding/` + `images/devotional/` — no audio files.

### Risk if shipped as-is

- Amazon reviewer or end user taps a track → sees "NOW PLAYING" bar appear at the bottom + a "Playing: …" snackbar → **nothing plays**. Classic "advertised feature does not work" reject.
- Quick-access "Audio · Listen & reflect" tile on Home makes the same promise from a more prominent surface.
- Tab labelled "Audio" with headphones icon in the persistent bottom nav implies a working audio library.

## Decision

**Hide Audio from production navigation behind `AppConstants.kEnableAudioTab` (default `false`).**

- ✅ Removes all user-facing entry points to the broken UI without deleting code.
- ✅ Same pattern as Phase 09H's `kEnableMockPurchases` — one grep finds every site that branches on the flag.
- ✅ Flipping the flag back later is a one-line change, plus wiring the real player and bundling assets.
- ✅ `IndexedStack` keeps a stable, smaller children list — no risk of stale tab index pointing at a hidden screen.
- ✅ Zero schema / persistence migration needed; `playingAudioId` in shared_preferences is harmless when nothing reads it.

Alternative considered: **rewrite `AudioScreen` as a "Coming soon" notice**. Rejected because:
- Audio is in the bottom nav — a high-prominence surface. A "Coming soon" tab that does nothing on launch still feels half-finished compared to other production apps in the category.
- Adds another piece of UI to maintain and undo when real playback ships.
- Risks Amazon reviewers asking "why does the app have a tab whose only content is 'coming soon'?".

## Files changed

| File | Change |
|------|--------|
| [lib/utils/constants.dart](../../../lib/utils/constants.dart) | Added `kEnableAudioTab = false` with a doc comment listing the steps to wire real audio later. |
| [lib/widgets/bottom_nav_shell.dart](../../../lib/widgets/bottom_nav_shell.dart) | Converted `_screens` and `_destinations` from `static const` lists to `static` getters with a conditional `if (AppConstants.kEnableAudioTab) ...` element. When the flag is off, the Audio screen and navigation destination drop out of the lists, shifting Shop from index 5 down to index 4. |
| [lib/state/app_state.dart](../../../lib/state/app_state.dart) | `selectTab()` upper bound now derives from the flag (`maxIndex = kEnableAudioTab ? 5 : 4`) so a stray `selectTab(5)` no longer points past the end of `_screens`. Added `import '../utils/constants.dart'`. |
| [lib/screens/home_screen.dart](../../../lib/screens/home_screen.dart) | Quick Access 4th tile branches on the flag: keeps the "Audio · Listen & reflect" tile when the flag is true; when false replaces it with "Shop · Curated resources" pointing to the shifted Shop index (4). Preserves the 2×2 grid balance. |

### Intentionally **not** touched

- `lib/screens/audio_screen.dart`, `lib/data/sample_audio.dart`, `lib/models/audio_track.dart` — preserved for flag-on dev / future re-enable.
- `lib/services/local_storage_service.dart` `playingAudioId` getters/setters — harmless when unused; touching them risks schema migration.
- `pubspec.yaml` — no new dependencies (deliberate: wiring a real audio plugin is a separate decision).
- `android/`, `key.properties`, signing config, `applicationId`, version — untouched.
- IAP, paywall, premium gating — untouched.
- Firebase, INTERNET permission (added in Phase 09I), launcher icon — untouched.

## Verification

- `flutter analyze` → **No issues found! (4.0s)**
- `flutter test` → **All tests passed (13/13)** — no audio tests existed and none are added.
- `flutter build apk --release` → **Built build\app\outputs\flutter-apk\app-release.apk (51.4MB)** in 17.1s; same size class as Phase 09I output (dead-code branches; no asset bundle change).

## What the user sees in a store build (flag=false)

- Bottom navigation: 5 tabs only — **Home · Devotional · Journal · Plans · Shop**. No headphones icon. No "Audio" label.
- Home Quick Access: 4 tiles in 2×2 — **Devotional · Journal** / **Plans · Shop**. Shop tile shows storefront icon and "Curated resources" subtitle.
- No way to reach `AudioScreen` from any user flow.
- `Home` `affiliate banner` still mentions "Audible — faith audiobooks" → that's an **external** Amazon Audible affiliate URL opened via `url_launcher`; it does not promise in-app audio. Out of scope; unchanged.
- Paywall (only reachable when `kEnableMockPurchases` flips to true) feature-list bullet "Calming audio library — Scripture and devotionals for quiet time" stays; it's a future-feature promise, paired with the existing "COMING SOON" badge. Consistent with the flag-off paywall posture from Phase 09H. Will be re-evaluated when either flag flips.

## Store / privacy / network implications

| Concern                                    | Status |
|--------------------------------------------|--------|
| App collects new data?                     | ❌ No — no audio analytics, no listening history sent. |
| App makes new outbound network calls?      | ❌ No — `Firebase.initializeApp()` still init-only; no streaming. |
| New sensitive runtime permissions?         | ❌ No — no `RECORD_AUDIO`, no `FOREGROUND_SERVICE`, no media permissions. |
| Amazon data-safety questionnaire impact?   | ❌ None — feature surface shrank. |
| Privacy-policy URL needs update?           | ❌ No — placeholder URL still valid, store-listing polish tracked in Phase 09K. |

## Known issues remaining before Amazon production

| # | Severity | Status | Tóm tắt |
|---|----------|--------|---------|
| 1 | 🔴 Store-blocker | ✅ RESOLVED 09F+09G | Debug signing → upload key |
| 2 | 🔴 Store-blocker | ✅ RESOLVED 09H | Mock IAP UI gated by feature flag |
| 3 | 🟡 Pre-launch | ✅ RESOLVED 09I | INTERNET permission added to release manifest |
| 4 | 🟡 Pre-launch | ⚠️ DEFERRED 09I | Firebase init kept; no Analytics/Crashlytics/Auth wired |
| 5 | 🟡 Pre-launch | ✅ RESOLVED 09J (this phase) | Audio tab hidden behind `kEnableAudioTab` |
| 6 | 🟢 Polish | OPEN | Affiliate banner FTC / EU disclosure |
| 7 | 🟢 Polish | OPEN | Bible translation license review |
| 8 | 🟢 Polish | OPEN | versionCode bump strategy |

→ All 2 🔴 store-blockers and all 3 🟡 pre-launch items now have decisions
(resolved or deliberately deferred). Remaining work is the 3 🟢 polish items
plus **Phase 09K** for store listing assets (screenshots, feature graphic,
real privacy policy URL, age rating, content rating questionnaire).

## When to re-enable Audio

Trigger checklist for a future "Phase 09L — Real audio" or similar:

- [ ] Decide audio strategy: bundled in-APK (size cost) or streamed (server / CDN — usually a Firebase Storage + signed URL flow, or a static CDN).
- [ ] Add `just_audio` or `audioplayers` to `pubspec.yaml`. Decide on `audio_service` for background playback + lock-screen controls.
- [ ] For streaming: add the chosen CDN domain + Amazon Appstore data-safety disclosure if any user identifiers are sent with the request.
- [ ] For background playback on Android 9+: add `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_MEDIA_PLAYBACK` permissions to `AndroidManifest.xml`. These ARE flagged by Amazon's review and need disclosure.
- [ ] Produce or license actual audio files for the 4 sample tracks (or replace the catalog).
- [ ] Replace `_onPlay` in [audio_screen.dart](../../../lib/screens/audio_screen.dart) to drive the real player; wire `_NowPlayingBar` controls (play/pause/seek/stop).
- [ ] Add audio tests around the new player wrapper.
- [ ] Flip `AppConstants.kEnableAudioTab` to `true`. Re-verify bottom nav + Home Quick Access.
- [ ] Update Phase 09E `KNOWN_ISSUES.md` if anything new surfaces.
