import '../models/devotional.dart';
import '../models/reading_plan.dart';
import 'sample_devotionals.dart';
import 'sample_plans.dart';

/// Central offline catalog — swap for Firestore later without changing UI ids.
class ContentLibrary {
  ContentLibrary._();

  static final Set<String> devotionalIds =
      sampleDevotionals.map((d) => d.id).toSet();

  static final Set<String> planIds = samplePlans.map((p) => p.id).toSet();

  static Devotional? devotionalById(String id) {
    for (final d in sampleDevotionals) {
      if (d.id == id) return d;
    }
    return null;
  }

  static ReadingPlan? planById(String id) {
    for (final p in samplePlans) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Drops unknown ids after content updates (safe persistence migration).
  static Set<String> sanitizeDevotionalIds(Set<String> ids) =>
      ids.where(devotionalIds.contains).toSet();

  static Set<String> sanitizePlanIds(Set<String> ids) =>
      ids.where(planIds.contains).toSet();

  static Set<String> sanitizeStartedPlanIds(Set<String> ids) =>
      ids.where(planIds.contains).toSet();
}
