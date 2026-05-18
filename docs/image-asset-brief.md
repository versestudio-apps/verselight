# VerseLight — Image Asset Brief

_Last updated: Phase 08E-2 (WebP q85 batch conversion)._

This is the working brief for the AI-generated devotional artwork that
ships in `assets/images/devotional/`. The Flutter app references these
files through `lib/utils/devotional_images.dart` and renders them through
`lib/widgets/devotional_image.dart` (which falls back to a gradient
placeholder when a file is missing).

## Global style

**Bright Catholic Devotional Watercolor.** See
[visual-direction-catholic.md](visual-direction-catholic.md) for the full
tone description. In short:

- Soft painterly watercolor, light golden hour, warm ivory backgrounds.
- Catholic devotional vocabulary (Holy Family, saints, Marian blue,
  rosary, candle, soft halo light) — never heavy, never gloomy.
- Family-friendly, US faith audience, gentle for daily use.
- All assets are **app-owned**, generated or commissioned in-house.
- No images of identifiable living people (see Pope / shepherd rule).

## Production format

- **Master:** PNG with alpha (so the artwork is editable and re-encodable).
  Keep masters outside the repo; only commit the WebP that ships.
- **Bundled:** WebP **q85** (Phase 08E-2). ~90% smaller than the equivalent
  PNG with no visible watercolor quality loss. Encode with ImageMagick:
  ```
  magick INPUT.png -quality 85 -define webp:method=6 OUTPUT.webp
  ```
- **Master long edge:** ≥ 1600 px so heroes render crisp on tablets.
- **Aspect ratio:** 16:9 for hero/detail/plan-header masters; 3:4 portrait
  for assets that primarily feed thumbnail / audio / square slots. The app
  crops to its slot via BoxFit.cover, so subjects should be centred.
- Avoid embedded text in the artwork (we overlay text in Flutter).
- File names are lowercase + underscores, ending in `.webp`, exactly as
  listed below.

## Assets

### 1. `jesus_welcome_home.webp`
- **Scene:** A welcoming watercolor of Jesus, arms slightly open, soft
  golden morning light, warm ivory background. Gentle, hopeful.
- **Used on:** Home hero (Morning / Faith devotionals), Life-of-Jesus
  plan header, "Morning Trust" audio.

### 2. `jesus_with_child.webp`
- **Scene:** Jesus seated with a child, watercolor, soft sage and Marian
  blue tones, sunlit, intimate but not sad.
- **Used on:** Hope-themed devotional cards, NT-Week plan, premium audio.

### 3. `mary_serene.webp`
- **Scene:** A serene watercolor portrait of the Blessed Mother, Marian
  blue mantle, soft halo light, downcast gaze, warm ivory background.
- **Used on:** Anxiety-themed devotionals, Psalms plan, Worship audio.

### 4. `joseph_family.webp`
- **Scene:** Joseph with Mary and the Christ child — the Holy Family in
  warm soft watercolor, lamp-light or dawn light.
- **Used on:** Family-themed plan day artwork.

### 5. `saint_francis.webp`
- **Scene:** A young friar with brown robe and rope cord, surrounded by
  birds / lambs / olive branches, soft natural light. (Symbolic St
  Francis, not portrait-accurate.)
- **Used on:** Saints / nature devotionals.

### 6. `saint_therese.webp`
- **Scene:** A gentle Carmelite figure with roses, soft pinks and
  ivories. Quiet, gentle, "Little Way" feeling.
- **Used on:** Saints / gentle devotionals.

### 7. `catholic_shepherd.webp` ⚠️
- **Scene:** A **generic symbolic** Catholic shepherd in white/cream
  robes, back turned or face indistinct, holding a crook or carrying a
  lamb, warm dawn light.
- **Rule:** **Do not** depict a specific living Pope or any
  identifiable real person. This is the Good-Shepherd archetype.
- **Used on:** Good Shepherd plan day, Psalm 23 audio.

### 8. `bible_rosary_candle.webp`
- **Scene:** Still life of an open Bible, wooden rosary, and a lit
  candle on a warm linen cloth. Soft golden morning light, watercolor.
- **Used on:** Shop hero, Bible/Gospels devotional category.

### 9. `journal_prayer.webp`
- **Scene:** Open journal with a pen, beside a rosary and a small lit
  candle. Personal prayer corner. Soft cream and gold.
- **Used on:** Journal empty state hero, Prayer-Reset plan.

### 10. `family_prayer.webp`
- **Scene:** A family at table or by candlelight in prayer, generic
  parents and child silhouettes, warm soft tones. Faces optional.
- **Used on:** Gratitude plan, family devotionals.

### 11. `guardian_angel_child.webp`
- **Scene:** A guardian angel watching over a sleeping or praying
  child, soft moonlight or dawn, warm gold and Marian blue.
- **Used on:** Paywall primary hero, Night devotionals.

### 12. `saint_michael.webp`
- **Scene:** Symbolic St Michael — sword and shield, soft watercolor
  light, calm rather than dramatic. Not a battle scene.
- **Used on:** Courage / Faith devotionals, alternate plan artwork.

## Future additions (Phase 07E+)

These are **not** required for Phase 07D but would round out the
devotional library if/when artwork capacity allows:

- `holy_spirit_dove.webp` — Pentecost / Holy Spirit devotionals.
- `cross_dawn.webp` — Easter / resurrection plan day.
- `nativity_scene.webp` — Christmas devotional set.
- `morning_window_bible.webp` — alternate Home hero for variety.
- `sacred_heart_jesus.webp` — devotion-of-the-month feature.
- `chapel_interior_calm.webp` — Mass / adoration plan series.

When adding new assets:
1. Drop the PNG into `assets/images/devotional/` with a lowercase
   underscore name.
2. Add the constant to `lib/utils/devotional_images.dart`.
3. Map it into one of the `for*` switch helpers (or add a new helper).
4. Update this brief.

## Where to *not* use these assets

- Settings screen — keep the visual quiet; no hero image needed.
- AppBars — never as a background; titles must stay legible.
- Affiliate banners — banners use icon badges, not devotional artwork
  (so the affiliate disclosure stays the dominant message).
