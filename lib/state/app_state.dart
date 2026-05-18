import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/prayer_entry.dart';
import '../services/iap_service.dart';
import '../services/local_storage_service.dart';

/// App session state with Phase 02 local persistence.
class AppState extends ChangeNotifier {
  int tabIndex = 0;
  final List<PrayerEntry> journalEntries = [];
  final Set<String> startedPlanIds = {};
  final Set<String> completedDevotionalIds = {};
  String? playingAudioId;

  /// Mock streak for Home UI (not persisted in Phase 02).
  int streakDays = 7;

  bool get isPremium => IapService.instance.isPremium;

  final LocalStorageService _storage = LocalStorageService.instance;

  Future<void> loadFromStorage() async {
    try {
      journalEntries
        ..clear()
        ..addAll(await _storage.loadJournalEntries());

      startedPlanIds
        ..clear()
        ..addAll(await _storage.loadStartedPlanIds());

      completedDevotionalIds
        ..clear()
        ..addAll(await _storage.loadCompletedDevotionalIds());

      playingAudioId = await _storage.loadPlayingAudioId();

      final premium = await _storage.loadPremiumUnlocked();
      IapService.instance.setPremiumForDemo(premium);
    } catch (e, st) {
      debugPrint('[AppState] load failed, using defaults: $e\n$st');
    }
    notifyListeners();
  }

  Future<void> resetAllLocalData() async {
    await _storage.clearAll();
    journalEntries.clear();
    startedPlanIds.clear();
    completedDevotionalIds.clear();
    playingAudioId = null;
    IapService.instance.setPremiumForDemo(false);
    notifyListeners();
  }

  void selectTab(int index) {
    if (index < 0 || index > 5) return;
    if (tabIndex == index) return;
    tabIndex = index;
    notifyListeners();
  }

  Future<void> addJournalEntry(String text) async {
    journalEntries.insert(
      0,
      PrayerEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
    unawaited(_storage.saveJournalEntries(List.from(journalEntries)));
  }

  Future<void> removeJournalEntry(String id) async {
    journalEntries.removeWhere((e) => e.id == id);
    notifyListeners();
    unawaited(_storage.saveJournalEntries(List.from(journalEntries)));
  }

  Future<void> setPlayingAudio(String? trackId) async {
    playingAudioId = trackId;
    notifyListeners();
    unawaited(_storage.savePlayingAudioId(trackId));
  }

  Future<void> markDevotionalCompleted(String id) async {
    if (id.isEmpty) return;
    if (!completedDevotionalIds.add(id)) return;
    notifyListeners();
    unawaited(_storage.saveCompletedDevotionalIds(completedDevotionalIds));
  }

  bool isDevotionalCompleted(String id) => completedDevotionalIds.contains(id);

  Future<void> startPlan(String planId) async {
    if (planId.isEmpty) return;
    if (!startedPlanIds.add(planId)) return;
    notifyListeners();
    unawaited(_storage.saveStartedPlanIds(startedPlanIds));
  }

  bool isPlanStarted(String planId) => startedPlanIds.contains(planId);

  /// Mock local progress: day 1 once a plan is started (Phase 03).
  int planProgressDay(String planId) => isPlanStarted(planId) ? 1 : 0;

  Future<void> onPremiumPurchased() async {
    IapService.instance.setPremiumForDemo(true);
    notifyListeners();
    unawaited(_storage.savePremiumUnlocked(true));
  }

  void onPremiumUpdated() => notifyListeners();
}
