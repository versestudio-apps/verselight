import 'package:flutter_test/flutter_test.dart';
import 'package:verselight/data/content_library.dart';
import 'package:verselight/data/devotional_filters.dart';
import 'package:verselight/data/sample_devotionals.dart';

void main() {
  test('catalog has 10 devotionals with stable ids', () {
    expect(sampleDevotionals.length, 10);
    expect(ContentLibrary.devotionalIds, contains('devo-1'));
    expect(ContentLibrary.devotionalIds, contains('devo-10'));
  });

  test('filter devotionals by category', () {
    final hope = filterDevotionals(sampleDevotionals, 'Hope');
    expect(hope.every((d) => d.category == 'Hope'), isTrue);
    expect(hope.length, greaterThanOrEqualTo(2));
  });

  test('sanitize drops unknown devotional ids', () {
    final raw = {'devo-1', 'devo-999', 'old-id'};
    final clean = ContentLibrary.sanitizeDevotionalIds(raw);
    expect(clean, equals({'devo-1'}));
  });

  test('plan ids preserved for persistence', () {
    expect(ContentLibrary.planIds, contains('plan-nt-30'));
    expect(ContentLibrary.planIds, contains('plan-gratitude-7'));
  });
}
