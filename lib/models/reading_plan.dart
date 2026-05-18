class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.emoji,
    required this.durationDays,
    required this.description,
    required this.dayReadings,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String emoji;
  final int durationDays;
  final String description;
  final List<String> dayReadings;
  final bool isPremium;
}
