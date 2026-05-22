import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/content_library.dart';
import '../models/premium_entitlement.dart';
import '../models/prayer_entry.dart';
import '../services/iap_service.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';

/// App session state with Phase 02+ local persistence.
class AppState extends ChangeNotifier {
  int tabIndex = 0;
  final List<PrayerEntry> journalEntries = [];
  final Set<String> startedPlanIds = {};
  final Set<String> completedDevotionalIds = {};
  final Map<String, int> planCurrentDay = {};
  String? playingAudioId;

  int streakDays = 7;

  bool get isPremium => IapService.instance.isPremium;

  PremiumEntitlement get premiumEntitlement =>
      IapService.instance.getCurrentEntitlement();

  final LocalStorageService _storage = LocalStorageService.instance;

  Future<void> loadFromStorage() async {
    try {
      await IapService.instance.initialize();

      journalEntries
        ..clear()
        ..addAll(await _storage.loadJournalEntries());

      startedPlanIds
        ..clear()
        ..addAll(
          ContentLibrary.sanitizeStartedPlanIds(
            await _storage.loadStartedPlanIds(),
          ),
        );

      completedDevotionalIds
        ..clear()
        ..addAll(
          ContentLibrary.sanitizeDevotionalIds(
            await _storage.loadCompletedDevotionalIds(),
          ),
        );

      planCurrentDay
        ..clear()
        ..addAll(await _storage.loadPlanProgress());

      _sanitizePlanProgress();

      playingAudioId = await _storage.loadPlayingAudioId();
    } catch (e, st) {
      debugPrint('[AppState] load failed, using defaults: $e\n$st');
    }
    notifyListeners();
  }

  void _sanitizePlanProgress() {
    final keys = planCurrentDay.keys.toList();
    for (final planId in keys) {
      if (!ContentLibrary.planIds.contains(planId)) {
        planCurrentDay.remove(planId);
        continue;
      }
      final plan = ContentLibrary.planById(planId);
      if (plan == null) continue;
      final day = planCurrentDay[planId]!;
      if (day < 1) {
        planCurrentDay[planId] = 1;
      } else if (day > plan.durationDays) {
        planCurrentDay[planId] = plan.durationDays;
      }
    }
  }

  Future<void> resetAllLocalData() async {
    await _storage.clearAll();
    journalEntries.clear();
    startedPlanIds.clear();
    completedDevotionalIds.clear();
    planCurrentDay.clear();
    playingAudioId = null;
    await IapService.instance.clearEntitlement();
    notifyListeners();
  }

  void selectTab(int index) {
    // Upper bound shrinks by one when the Audio tab is hidden
    // (Phase 09J — AppConstants.kEnableAudioTab=false).
    final maxIndex = AppConstants.kEnableAudioTab ? 5 : 4;
    if (index < 0 || index > maxIndex) return;
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
    if (id.isEmpty || !ContentLibrary.devotionalIds.contains(id)) return;
    if (!completedDevotionalIds.add(id)) return;
    notifyListeners();
    unawaited(_storage.saveCompletedDevotionalIds(completedDevotionalIds));
  }

  bool isDevotionalCompleted(String id) => completedDevotionalIds.contains(id);

  Future<void> startPlan(String planId) async {
    if (planId.isEmpty || !ContentLibrary.planIds.contains(planId)) return;
    if (!startedPlanIds.add(planId)) return;
    planCurrentDay[planId] = 1;
    notifyListeners();
    unawaited(_storage.saveStartedPlanIds(startedPlanIds));
    unawaited(_storage.savePlanProgress(Map.from(planCurrentDay)));
  }

  bool isPlanStarted(String planId) => startedPlanIds.contains(planId);

  int planProgressDay(String planId) {
    if (!isPlanStarted(planId)) return 0;
    return planCurrentDay[planId] ?? 1;
  }

  bool isPlanDayCompleted(String planId, int dayNumber) {
    final current = planProgressDay(planId);
    return current > 0 && dayNumber < current;
  }

  bool isPlanCurrentDay(String planId, int dayNumber) {
    return planProgressDay(planId) == dayNumber;
  }

  Future<void> completeCurrentPlanDay(String planId) async {
    final plan = ContentLibrary.planById(planId);
    if (plan == null) return;
    if (!isPlanStarted(planId)) {
      await startPlan(planId);
    }
    final current = planCurrentDay[planId] ?? 1;
    if (current < plan.durationDays) {
      planCurrentDay[planId] = current + 1;
    }
    notifyListeners();
    unawaited(_storage.savePlanProgress(Map.from(planCurrentDay)));
  }

  Future<void> refreshPremiumEntitlement() async {
    notifyListeners();
  }

  Future<void> onPremiumPurchased() async {
    notifyListeners();
  }

  void onPremiumUpdated() => notifyListeners();
}
