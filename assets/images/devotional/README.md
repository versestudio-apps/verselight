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
`lib/utils/devotional_images.dart`). If a PNG is missing the UI falls back to
a gradient placeholder via `DevotionalImage`, so the app keeps building and
running even before the artwork ships.

## Expected files

| File | Used on |
|---|---|
| `jesus_welcome_home.png` | Home hero · Morning / Faith devotionals · Life-of-Jesus plan · Morning audio |
| `jesus_with_child.png` | Hope devotionals · NT-Week plan · Premium audio |
| `mary_serene.png` | Anxiety devotionals · Psalms plan · Worship audio |
| `joseph_family.png` (portrait 3:4) | Thumbnail / square slots for family scenes |
| `saint_francis.png` (portrait 3:4) | Thumbnail / square slots for nature devotionals |
| `saint_therese.png` (portrait 3:4) | Thumbnail / square slots for Saints devotionals |
| `catholic_shepherd.png` (portrait 3:4) | Psalm 23 audio artwork (56×56). Generic shepherd — never a specific living person |
| `saint_michael.png` (portrait 3:4) | Thumbnail / square slots for Courage devotionals |
| `joseph_family_landscape.png` (16:9) | Family devotional detail hero · alt Home hero · family plan header |
| `saint_francis_landscape.png` (16:9) | Nature devotional detail hero |
| `saint_therese_landscape.png` (16:9) | Saints devotional detail hero · Paywall alternate |
| `catholic_shepherd_landscape.png` (16:9) | Good Shepherd plan-day hero · alt Home. Generic shepherd only |
| `saint_michael_landscape.png` (16:9) | Courage devotional detail hero · alt plan |
| `bible_rosary_candle.png` | Shop hero · Bible category devotionals |
| `journal_prayer.png` | Journal hero / empty state · Prayer-Reset plan |
| `family_prayer.png` | Gratitude plan · family devotionals |
| `guardian_angel_child.png` | Paywall hero · Night devotionals |
