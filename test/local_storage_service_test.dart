import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verselight/models/prayer_entry.dart';
import 'package:verselight/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('journal entries round-trip', () async {
    final storage = LocalStorageService.instance;
    await storage.initialize();

    final entries = [
      PrayerEntry(
        id: '1',
        text: 'Thank You Lord',
        createdAt: DateTime(2025, 1, 15, 9, 30),
      ),
    ];
    await storage.saveJournalEntries(entries);

    final loaded = await storage.loadJournalEntries();
    expect(loaded.length, 1);
    expect(loaded.first.text, 'Thank You Lord');
  });

  test('corrupt journal json returns empty list', () async {
    SharedPreferences.setMockInitialValues({
      'journal_entries_v1': 'not-json',
    });
    final storage = LocalStorageService.instance;
    await storage.initialize();

    final loaded = await storage.loadJournalEntries();
    expect(loaded, isEmpty);
  });

  test('premium flag persists', () async {
    final storage = LocalStorageService.instance;
    await storage.initialize();

    expect(await storage.loadPremiumUnlocked(), isFalse);
    await storage.savePremiumUnlocked(true);
    expect(await storage.loadPremiumUnlocked(), isTrue);
  });
}
