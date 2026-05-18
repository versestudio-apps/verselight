class Devotional {
  const Devotional({
    required this.id,
    required this.title,
    required this.verseText,
    required this.verseRef,
    required this.bodyPreview,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String verseText;
  final String verseRef;
  final String bodyPreview;
  final bool isPremium;
}
