import 'plan_day.dart';

/// Offline reading plan (Firestore-ready shape).
class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.durationDays,
    required this.category,
    required this.tags,
    required this.days,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final int durationDays;
  final String category;
  final List<String> tags;
  final List<PlanDay> days;
  final bool isPremium;

  /// Legacy alias for list screens.
  String get description => subtitle;

  PlanDay? dayByNumber(int dayNumber) {
    for (final d in days) {
      if (d.dayNumber == dayNumber) return d;
    }
    return null;
  }
}
