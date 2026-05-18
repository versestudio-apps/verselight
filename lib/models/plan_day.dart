/// One day in an offline reading plan.
class PlanDay {
  const PlanDay({
    required this.dayNumber,
    required this.title,
    required this.verseReference,
    required this.verseText,
    required this.reflection,
    this.actionStep,
  });

  final int dayNumber;
  final String title;
  final String verseReference;
  final String verseText;
  final String reflection;
  final String? actionStep;
}
