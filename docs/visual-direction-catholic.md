# VerseLight — Visual Direction (Bright Catholic Devotional Watercolor)

_Last updated: Phase 07D._

## One-line direction

**Bright Catholic Devotional Watercolor.** Warm ivory backgrounds, Marian
blue accents, soft gold, sage green, golden morning light, soft painterly
realism, family-friendly Catholic devotional feeling.

The app should feel like opening a quiet, sun-lit prayer corner first thing
in the morning — calm, welcoming, hopeful. Not heavy, not Gothic, not
"church-poster", not childish.

## Tone checklist

- ✅ Bright, sunlit, hopeful
- ✅ Warm — gold and cream, never cold blue/grey
- ✅ Painterly watercolor edges, not photo-realistic
- ✅ Catholic devotional vocabulary (rosary, candle, saints, Holy Family)
  but family-friendly and accessible
- ✅ Soft natural light, golden hour
- ❌ No gloom, no dark Gothic / "horror movie" feeling
- ❌ No hyper-realistic CGI of identifiable real people
- ❌ No sales banners, no cluttered "shop" feel
- ❌ No childish cartoon styling

## App-owned artwork — no web/copyrighted sources

All devotional imagery in `assets/images/devotional/` is **generated or
commissioned in-house** for VerseLight. We do **not** drop in images
sourced from the open web, stock libraries we don't have rights to, or
other apps. This is both a copyright safety measure and a brand control
measure.

### Specific rule: shepherd / "pope" imagery

If a screen calls for a "Catholic shepherd" figure, use **generic,
symbolic shepherd artwork only** — a watercolor of a shepherd in robes,
back turned or face indistinct, holding a crook or lifting a lamb. Never
depict a specific, recognizable living Pope or identifiable real person.
File name: `catholic_shepherd.png`.

## Palette

The Flutter palette (`lib/utils/theme.dart`) maps to the brand colors:

| Brand role | Token | Hex | Use |
|---|---|---|---|
| Background | `ivory` / `cream` | `#FAF7F0` | Scaffold, AppBar |
| Soft surface | `softCream` / `parchment` | `#F5EFE3` | Section backgrounds |
| Card surface | `surface` | `#FFFFFF` | Cards, tiles |
| Border | `border` / `goldSoft` | `#E9DFCF` | Card edges, dividers |
| Primary text | `deepNavy` / `warmBrown` | `#1D2636` | Headings, body |
| Secondary text | `slate` / `warmBrownMuted` | `#647084` | Captions, helper |
| Primary accent | `warmGold` / `gold` | `#C9A45C` | Buttons, eyebrows |
| Catholic accent | `marianBlue` | `#5A7BA8` | Verse pills, plan badges |
| Catholic accent tint | `marianBlueLight` | `#E1EAF4` | Pill backgrounds |
| Calm accent | `sageGreen` / `sage` | `#6F8F72` | Read state, prayer |
| Calm accent tint | `sageMist` / `sageLight` | `#EAF1EA` | Prayer section background |
| Warm contrast | `softRose` | `#B96B6B` | Streak / gentle alert |
| Premium emphasis | `warmGold` | `#C9A45C` | Subscription accents |

## Where artwork appears

Resolved through `DevotionalImages` in `lib/utils/devotional_images.dart`.
See [image-asset-brief.md](image-asset-brief.md) for the per-file brief.

| Screen | Asset key | Notes |
|---|---|---|
| Home — verse hero | `DevotionalImages.forDevotionalCategory(today.category)` | Today's devotional category picks the artwork |
| Devotional list | per-card via category | Square thumbnail on the left |
| Devotional detail | per-category hero | 16:9 hero above the verse block |
| Journal empty state | `DevotionalImages.journalHero` | Open journal w/ rosary & candle |
| Plans list | per-plan via `forPlanId` | Square thumbnail on each card |
| Plan detail | per-plan via `forPlanId` | Full-width hero in the plan header |
| Audio cards | per-track via `forAudioId` | Square artwork w/ play icon overlay |
| Shop | `DevotionalImages.shopHero` | 16:9 hero with title overlay |
| Paywall | `DevotionalImages.paywallHero` | 16:9 hero with eyebrow chip |
| Settings | — | Visual stays calm/clean; no big hero |

## Fallback behaviour

If a PNG is missing, `DevotionalImage` renders a soft gradient (Marian
blue → warm gold → ivory) with a faint book icon — so the app keeps
building and shipping while artwork is still in production.

This is intentional: artwork generation can run on its own cadence; the
app does **not** need to wait for all 13 PNGs to ship a release build.
