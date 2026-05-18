import '../models/devotional.dart';

/// Local filter chips for the Devotional screen (Phase 04).
const List<String> devotionalFilterCategories = [
  'All',
  'Hope',
  'Anxiety',
  'Faith',
  'Gratitude',
  'Morning',
  'Night',
];

List<Devotional> filterDevotionals(
  List<Devotional> source,
  String category,
) {
  if (category == 'All') return List.from(source);
  return source.where((d) => d.matchesCategory(category)).toList();
}
