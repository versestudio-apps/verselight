class Devotional {
  const Devotional({
    required this.id,
    required this.title,
    required this.verseText,
    required this.verseRef,
    required this.bodyPreview,
    required this.bodyFull,
    required this.reflectionPrompt,
    required this.prayerPrompt,
    required this.actionStep,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String verseText;
  final String verseRef;
  final String bodyPreview;
  final String bodyFull;
  final String reflectionPrompt;
  final String prayerPrompt;
  final String actionStep;
  final bool isPremium;
}
