/// Central registry of AI-generated devotional artwork paths.
///
/// All artwork lives in `assets/images/devotional/`. The PNG files are
/// expected to ship later — until they do, `DevotionalImage` will render a
/// soft gradient fallback so the app keeps building and running.
///
/// Style brief: Bright Catholic Devotional Watercolor —
/// warm ivory, Marian blue, soft gold, sage green, soft golden morning
/// light, soft painterly realism, family-friendly Catholic devotional tone.
///
/// See `docs/visual-direction-catholic.md` and `docs/image-asset-brief.md`.
class DevotionalImages {
  DevotionalImages._();

  static const String _base = 'assets/images/devotional/';

  // ── Hero / scene assets ──────────────────────────────────────────────
  //
  // Each Saint / shepherd / family scene exists in **two** masters:
  //  * portrait (3:4, 1086×1448) — safe for thumbnails, audio artwork,
  //    square cards. BoxFit.cover crops the sides a little.
  //  * landscape (16:9, 1672×941) — safe for hero / detail / plan-header
  //    slots. Pixel-aligned, no crop.
  //
  // Pick the variant that matches the slot's aspect ratio. See
  // `docs/image-asset-brief.md` for the per-asset brief.

  static const String jesusWelcomeHome = '${_base}jesus_welcome_home.png';
  static const String jesusWithChild = '${_base}jesus_with_child.png';
  static const String marySerene = '${_base}mary_serene.png';
  static const String bibleRosaryCandle = '${_base}bible_rosary_candle.png';
  static const String journalPrayer = '${_base}journal_prayer.png';
  static const String familyPrayer = '${_base}family_prayer.png';
  static const String eucharisticAdoration =
      '${_base}eucharistic_adoration.png';
  static const String guardianAngelChild =
      '${_base}guardian_angel_child.png';

  // Portrait masters (3:4). Use for thumbnail / audio / square slots.
  static const String catholicShepherd = '${_base}catholic_shepherd.png';
  static const String josephFamily = '${_base}joseph_family.png';
  static const String saintFrancis = '${_base}saint_francis.png';
  static const String saintTherese = '${_base}saint_therese.png';
  static const String saintMichael = '${_base}saint_michael.png';

  // Landscape masters (16:9). Use for hero / detail / plan-header slots.
  static const String catholicShepherdLandscape =
      '${_base}catholic_shepherd_landscape.png';
  static const String josephFamilyLandscape =
      '${_base}joseph_family_landscape.png';
  static const String saintFrancisLandscape =
      '${_base}saint_francis_landscape.png';
  static const String saintThereseLandscape =
      '${_base}saint_therese_landscape.png';
  static const String saintMichaelLandscape =
      '${_base}saint_michael_landscape.png';

  /// Every known asset path — used by manifest scripts / docs.
  static const List<String> all = [
    jesusWelcomeHome,
    jesusWithChild,
    marySerene,
    bibleRosaryCandle,
    journalPrayer,
    familyPrayer,
    eucharisticAdoration,
    guardianAngelChild,
    // Portrait masters
    catholicShepherd,
    josephFamily,
    saintFrancis,
    saintTherese,
    saintMichael,
    // Landscape masters
    catholicShepherdLandscape,
    josephFamilyLandscape,
    saintFrancisLandscape,
    saintThereseLandscape,
    saintMichaelLandscape,
  ];

  // ── Screen defaults ──────────────────────────────────────────────────
  static const String homeHero = jesusWelcomeHome;
  static const String journalHero = journalPrayer;
  static const String shopHero = bibleRosaryCandle;
  static const String paywallHero = guardianAngelChild;

  /// Devotional artwork keyed by `Devotional.category`. Falls back to a
  /// gentle default when the category is unknown.
  ///
  /// Returns the **landscape** variant for categories whose subject only
  /// exists as a portrait master (Saints, Family, Courage, Nature) — the
  /// hero / detail slots that consume this helper are 16:9 and would crop
  /// a 3:4 portrait badly. Thumbnails in the Devotional list call site
  /// also remain readable with 16:9 sources via BoxFit.cover.
  static String forDevotionalCategory(String category) {
    switch (category.toLowerCase()) {
      case 'faith':
        return jesusWelcomeHome;
      case 'anxiety':
        return marySerene;
      case 'hope':
        return jesusWithChild;
      case 'morning':
        return jesusWelcomeHome;
      case 'night':
        return guardianAngelChild;
      case 'gratitude':
        return familyPrayer;
      case 'worship':
        return marySerene;
      case 'prayer':
        return journalPrayer;
      case 'saints':
        return saintThereseLandscape;
      case 'family':
        return josephFamilyLandscape;
      case 'courage':
        return saintMichaelLandscape;
      case 'nature':
        return saintFrancisLandscape;
      case 'bible':
      case 'gospels':
        return bibleRosaryCandle;
      default:
        return jesusWithChild;
    }
  }

  /// Plan artwork keyed by `ReadingPlan.id`.
  static String forPlanId(String planId) {
    switch (planId) {
      case 'plan-nt-30':
        return jesusWithChild;
      case 'plan-psalms-30':
        return marySerene;
      case 'plan-prayer-21':
        return journalPrayer;
      case 'plan-jesus-14':
        return jesusWelcomeHome;
      case 'plan-gratitude-7':
        return familyPrayer;
      default:
        return jesusWelcomeHome;
    }
  }

  /// Audio artwork keyed by `AudioTrack.id`.
  static String forAudioId(String audioId) {
    switch (audioId) {
      case 'audio-psalm-23':
        return catholicShepherd;
      case 'audio-morning-trust':
        return jesusWelcomeHome;
      case 'audio-john':
        return jesusWithChild;
      case 'audio-worship-peace':
        return marySerene;
      default:
        return marySerene;
    }
  }
}
