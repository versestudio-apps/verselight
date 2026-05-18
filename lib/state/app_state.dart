import 'package:flutter/foundation.dart';

import '../models/prayer_entry.dart';
import '../services/iap_service.dart';

/// In-memory session state for Phase 01 (no persistence / Firebase yet).
class AppState extends ChangeNotifier {
  int tabIndex = 0;
  final List<PrayerEntry> journalEntries = [];
  String? playingAudioId;

  /// Mock streak for Home UI.
  int streakDays = 7;

  bool get isPremium => IapService.instance.isPremium;

  void selectTab(int index) {
    if (index < 0 || index > 5) return;
    if (tabIndex == index) return;
    tabIndex = index;
    notifyListeners();
  }

  void addJournalEntry(String text) {
    journalEntries.insert(
      0,
      PrayerEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeJournalEntry(String id) {
    journalEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setPlayingAudio(String? trackId) {
    playingAudioId = trackId;
    notifyListeners();
  }

  void onPremiumUpdated() => notifyListeners();
}
