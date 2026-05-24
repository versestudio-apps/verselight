# VerseLight — Phase 09N Tablet Screenshot Capture Plan

> Amazon Appstore requires **≥3 screenshots per supported device class** for
> the listing. The phone screenshots are already covered by README §9; this
> doc focuses on the **Fire tablet** capture pass, which is the gating asset
> for Amazon submission (phone screenshots are bonus on Amazon).
>
> The Audio tab is hidden in the store build (Phase 09J `kEnableAudioTab=false`),
> so the visible bottom-nav order is **Home · Devotional · Journal · Plans · Shop**.
> Do **not** capture the Audio screen even if you flip the flag for dev.

---

## Target devices

| Slot | Device profile | Resolution | Required? |
|------|----------------|------------|-----------|
| Tablet — Fire HD 8 (primary) | Amazon Fire HD 8 emulator OR real Fire HD 8 | 800 × 1280 portrait | ✅ Yes — Amazon's most-installed Fire form factor |
| Tablet — Fire HD 10 (bonus) | Amazon Fire HD 10 emulator OR real Fire HD 10 | 1200 × 1920 portrait | ⏭️ Optional but lifts listing quality |
| Phone — Pixel 6 (already in README §9) | Pixel 6 API 34 emulator | 1080 × 2400 portrait | ✅ Yes — phone class deliverable |

For first submission you only **must** ship 3 tablet shots; pick from the
Fire HD 8 column.

---

## Pre-capture prep (run once on the device)

1. Install the signed APK (Phase 09G or a fresh RC build per Phase 09M strategy).
2. Open the app once so first-run defaults populate.
3. Settings → **Reset local data** so demo state looks clean.
4. Tap through Home once so the verse-of-the-day card has settled.
5. Add ≥2 sample journal entries (short, devotional in tone — e.g.
   "Grateful for quiet mornings", "Pray for clarity at work") so the
   Journal screenshot doesn't look empty.
6. Open Plans → tap any plan once so its `lastOpened` is recent.
7. **Do not** sign in to any account, **do not** enable mock IAP, **do not**
   change locale or font scale. Use defaults.

---

## Capture matrix (Fire HD 8 — 800 × 1280)

Pick at least the first 3. Capture in **portrait** orientation. Save as PNG.

| # | Route | Tab / how to reach | What the frame must show | Required? |
|---|-------|--------------------|---------------------------|-----------|
| 1 | Home | bottom nav → Home | Verse-of-the-day card + today's devotional card both visible. Affiliate banner can show in the lower half. | ✅ |
| 2 | Devotional detail | tap any devotional card on Home OR Devotional tab → tap entry | Title, paraphrased verse with reference, full reflection body. Scroll so the verse and the first paragraph of the reflection are both in frame. | ✅ |
| 3 | Plans list | bottom nav → Plans | Plan cards grid showing ≥3 plans with progress chips. | ✅ |
| 4 | Plan detail | Plans → tap a plan | Plan title, progress bar partway filled, day list with ≥3 days visible. | ⏭️ Strong-to-have. |
| 5 | Journal | bottom nav → Journal | ≥2 sample entries visible with timestamps. | ⏭️ |
| 6 | Shop | bottom nav → Shop | Affiliate disclosure visible at the top **and** at least one affiliate card. The disclosure text is the legally relevant element — must be legible. | ⏭️ Recommended for Amazon listing transparency. |
| 7 | Settings | Settings entry point (top-right gear / overflow) | Legal links section visible (Privacy / Terms / Help). Skip if URLs still show placeholders (capture **after** the Phase 09M §C URL swap). | ⏭️ Capture AFTER real URLs are wired. |

→ **Minimum for submission**: shots #1, #2, #3 from this matrix.

→ **Do NOT capture**: Audio screen (hidden in store build), Paywall (hidden by
   `kEnableMockPurchases=false`; the "COMING SOON" teaser is uninteresting and
   could confuse reviewers into thinking the app advertises a paid tier).

---

## How to capture

### Option A — Android Studio emulator (recommended)

```powershell
# 1. Boot the Fire HD 8 emulator profile (or a generic 8" tablet AVD at 800x1280).
# 2. Install the signed APK:
adb install -r build\app\outputs\flutter-apk\app-release.apk
# 3. Open the app, navigate to the target screen, then:
adb exec-out screencap -p > shot-01-home.png
# Or use the emulator UI camera button (saves to %USERPROFILE%\Desktop by default).
```

Save with the naming pattern below so files are self-describing in the listing flow.

### Option B — Real Fire HD 8

1. Enable Developer Options → USB debugging.
2. Sideload the APK via `adb install -r ...`.
3. Capture with hardware Power + Volume-Down (Fire OS default screenshot combo)
   or use `adb exec-out screencap -p > shot-01-home.png`.

### Option C — Resize phone screenshots (NOT recommended)

Amazon historically accepts phone-resolution screenshots in tablet slots but
the listing renders them with letterboxing. Avoid unless time-critical.

---

## Naming convention

Save captures into `docs/releases/phase-09n-store-image-assets/screenshots/`
with this pattern:

```
fire-hd-8-01-home.png
fire-hd-8-02-devotional-detail.png
fire-hd-8-03-plans-list.png
fire-hd-8-04-plan-detail.png       (optional)
fire-hd-8-05-journal.png           (optional)
fire-hd-8-06-shop.png              (optional)
fire-hd-8-07-settings.png          (optional, AFTER URL swap)
fire-hd-10-01-home.png             (optional bonus device)
...
pixel-6-01-home.png                (phone class)
...
```

The `screenshots/` directory ships with a `.gitkeep` placeholder; drop captures
in and commit (they're owner deliverables, not auto-generated).

---

## Quality bar — reject + recapture if

- Status bar shows a debug "VPN" indicator, full battery icon missing, or carrier
  text other than emulator default. Use airplane mode + fully-charged battery on
  the emulator.
- Soft keyboard is visible (dismiss before capture).
- A snackbar / toast is overlapping the content.
- Affiliate banner shows a placeholder URL warning instead of an Amazon listing.
- A tab indicator overlaps the screenshot region (use the OS screenshot tool, not
  Flutter's `RepaintBoundary`, so the native chrome is captured correctly).
- The cream brand background looks gray (color profile mismatch — verify the
  emulator is set to sRGB).

---

## What this phase does NOT cover

- Capturing the screenshots (requires booting an emulator / device — owner action).
- Pixel-perfect mockups (we ship real captures, not Photoshop frames).
- Localized screenshots for non-English Amazon storefronts (English-only listing
  for first submission).
- Video preview (Amazon supports it but it's optional — defer until post-launch).
