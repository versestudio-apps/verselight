/// Offline devotional content (Firestore-ready shape).
class Devotional {
  const Devotional({
    required this.id,
    required this.title,
    required this.category,
    required this.tags,
    required this.mood,
    required this.durationMinutes,
    required this.verseReference,
    required this.verseText,
    required this.preview,
    required this.reflection,
    required this.prayerPrompt,
    required this.journalPrompt,
    required this.actionStep,
    this.isPremium = false,
  });

  final String id;
  final String title;

  /// Primary filter category: Hope, Anxiety, Faith, Gratitude, Morning, Night, etc.
  final String category;
  final List<String> tags;
  final String mood;
  final int durationMinutes;
  final bool isPremium;

  final String verseReference;
  final String verseText;
  final String preview;
  final String reflection;
  final String prayerPrompt;
  final String journalPrompt;
  final String actionStep;

  // ── Backward-compatible aliases (Phase 01–03 UI) ──────────────────────────
  String get verseRef => verseReference;
  String get bodyPreview => preview;
  String get bodyFull => reflection;
  String get reflectionPrompt => journalPrompt;

  bool matchesCategory(String filterCategory) {
    if (filterCategory == 'All') return true;
    return category.toLowerCase() == filterCategory.toLowerCase();
  }
}
