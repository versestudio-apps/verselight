# VerseLight devotional artwork

This folder holds the AI-generated, app-owned devotional artwork referenced by
`lib/utils/devotional_images.dart`.

**Style brief:** Bright Catholic Devotional Watercolor —
warm ivory background, Marian blue, soft gold, sage green, soft golden
morning light, soft painterly realism, family-friendly Catholic devotional
feeling. See [`docs/visual-direction-catholic.md`](../../../docs/visual-direction-catholic.md)
and [`docs/image-asset-brief.md`](../../../docs/image-asset-brief.md) for the
full brief.

**Important:**
- All artwork in this folder must be created in-house (AI-generated, edited,
  or commissioned). Do **not** drop in images sourced from the open web.
- Generic symbolic Catholic shepherd imagery only — never depict a specific
  living Pope or other identifiable person.

The Flutter app references these paths through `DevotionalImages` (see
`lib/utils/devotional_images.dart`). If a file is missing the UI falls back
to a gradient placeholder via `DevotionalImage`, so the app keeps building
and running even before the artwork ships.

## Format

Assets are stored as **WebP q85** (Phase 08E-2) — encoded from the original
PNG masters via ImageMagick:

```
magick INPUT.png -quality 85 -define webp:method=6 OUTPUT.webp
```

This is ~90% smaller than the equivalent PNG with no visible quality loss
on the watercolor source. To regenerate, work from the original masters
(kept outside the repo) and re-encode with the command above. Replace
`.webp` files in this folder; no Dart code change is needed because all
path constants in `DevotionalImages` already point at `.webp`.

## Expected files

| File | Used on |
|---|---|
| `jesus_welcome_home.webp` | Home hero · Morning / Faith devotionals · Life-of-Jesus plan · Morning audio |
| `jesus_with_child.webp` | Hope devotionals · NT-Week plan · Premium audio |
| `mary_serene.webp` | Anxiety devotionals · Psalms plan · Worship audio |
| `joseph_family.webp` (portrait 3:4) | Thumbnail / square slots for family scenes |
| `saint_francis.webp` (portrait 3:4) | Thumbnail / square slots for nature devotionals |
| `saint_therese.webp` (portrait 3:4) | Thumbnail / square slots for Saints devotionals |
| `catholic_shepherd.webp` (portrait 3:4) | Psalm 23 audio artwork (56×56). Generic shepherd — never a specific living person |
| `saint_michael.webp` (portrait 3:4) | Thumbnail / square slots for Courage devotionals |
| `joseph_family_landscape.webp` (16:9) | Family devotional detail hero · alt Home hero · family plan header |
| `saint_francis_landscape.webp` (16:9) | Nature devotional detail hero |
| `saint_therese_landscape.webp` (16:9) | Saints devotional detail hero · Paywall alternate |
| `catholic_shepherd_landscape.webp` (16:9) | Good Shepherd plan-day hero · alt Home. Generic shepherd only |
| `saint_michael_landscape.webp` (16:9) | Courage devotional detail hero · alt plan |
| `bible_rosary_candle.webp` | Shop hero · Bible category devotionals |
| `journal_prayer.webp` | Journal hero / empty state · Prayer-Reset plan |
| `family_prayer.webp` | Gratitude plan · family devotionals |
| `guardian_angel_child.webp` | Paywall hero · Night devotionals |
