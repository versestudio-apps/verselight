import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/prayer_entry.dart';
import '../models/premium_entitlement.dart';

/// Keys versioned so schema can evolve without corrupting old installs.
abstract final class _Keys {
  static const journalEntries = 'journal_entries_v1';
  static const premiumUnlocked = 'premium_unlocked_v1';
  static const premiumEntitlement = 'premium_entitlement_v1';
  static const startedPlanIds = 'started_plan_ids_v1';
  static const completedDevotionalIds = 'completed_devotional_ids_v1';
  static const playingAudioId = 'playing_audio_id_v1';
  static const planProgress = 'plan_progress_v1';
}

/// Local persistence via [SharedPreferences] (Phase 02).
class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _store {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('LocalStorageService.initialize() must be called first');
    }
    return prefs;
  }

  // ── Journal ───────────────────────────────────────────────────────────

  Future<List<PrayerEntry>> loadJournalEntries() async {
    try {
      final raw = _store.getString(_Keys.journalEntries);
      if (raw == null || raw.isEmpty) return [];

      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      final entries = <PrayerEntry>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final entry = PrayerEntry.fromJson(item);
          if (entry != null) entries.add(entry);
        } else if (item is Map) {
          final entry = PrayerEntry.fromJson(Map<String, dynamic>.from(item));
          if (entry != null) entries.add(entry);
        }
      }
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    } catch (e, st) {
      debugPrint('[LocalStorage] journal load failed: $e\n$st');
      return [];
    }
  }

  Future<void> saveJournalEntries(List<PrayerEntry> entries) async {
    try {
      final payload = jsonEncode(entries.map((e) => e.toJson()).toList());
      await _store.setString(_Keys.journalEntries, payload);
    } catch (e, st) {
      debugPrint('[LocalStorage] journal save failed: $e\n$st');
    }
  }

  // ── Premium (mock) ──────────────────────────────────────────────────────

  Future<bool> loadPremiumUnlocked() async {
    try {
      return _store.getBool(_Keys.premiumUnlocked) ?? false;
    } catch (e, st) {
      debugPrint('[LocalStorage] premium load failed: $e\n$st');
      return false;
    }
  }

  Future<void> savePremiumUnlocked(bool value) async {
    try {
      await _store.setBool(_Keys.premiumUnlocked, value);
    } catch (e, st) {
      debugPrint('[LocalStorage] premium save failed: $e\n$st');
    }
  }

  Future<PremiumEntitlement?> loadPremiumEntitlement() async {
    try {
      final raw = _store.getString(_Keys.premiumEntitlement);
      if (raw == null || raw.isEmpty) return null;

      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;

      return PremiumEntitlement.fromJson(
        Map<String, dynamic>.from(decoded),
      );
    } catch (e, st) {
      debugPrint('[LocalStorage] entitlement load failed: $e\n$st');
      return null;
    }
  }

  Future<void> savePremiumEntitlement(PremiumEntitlement entitlement) async {
    try {
      await _store.setString(
        _Keys.premiumEntitlement,
        jsonEncode(entitlement.toJson()),
      );
      await savePremiumUnlocked(entitlement.isActive);
    } catch (e, st) {
      debugPrint('[LocalStorage] entitlement save failed: $e\n$st');
    }
  }

  // ── String sets ─────────────────────────────────────────────────────────

  Future<Set<String>> loadStringSet(String key) async {
    try {
      final raw = _store.getString(key);
      if (raw == null || raw.isEmpty) return {};

      final decoded = jsonDecode(raw);
      if (decoded is! List) return {};

      return decoded
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet();
    } catch (e, st) {
      debugPrint('[LocalStorage] set load failed ($key): $e\n$st');
      return {};
    }
  }

  Future<void> saveStringSet(String key, Set<String> values) async {
    try {
      await _store.setString(key, jsonEncode(values.toList()));
    } catch (e, st) {
      debugPrint('[LocalStorage] set save failed ($key): $e\n$st');
    }
  }

  Future<Set<String>> loadStartedPlanIds() =>
      loadStringSet(_Keys.startedPlanIds);

  Future<void> saveStartedPlanIds(Set<String> ids) =>
      saveStringSet(_Keys.startedPlanIds, ids);

  Future<Set<String>> loadCompletedDevotionalIds() =>
      loadStringSet(_Keys.completedDevotionalIds);

  Future<void> saveCompletedDevotionalIds(Set<String> ids) =>
      saveStringSet(_Keys.completedDevotionalIds, ids);

  // ── Audio ───────────────────────────────────────────────────────────────

  Future<String?> loadPlayingAudioId() async {
    try {
      final id = _store.getString(_Keys.playingAudioId);
      if (id == null || id.isEmpty) return null;
      return id;
    } catch (e, st) {
      debugPrint('[LocalStorage] audio load failed: $e\n$st');
      return null;
    }
  }

  Future<Map<String, int>> loadPlanProgress() async {
    try {
      final raw = _store.getString(_Keys.planProgress);
      if (raw == null || raw.isEmpty) return {};

      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};

      final result = <String, int>{};
      decoded.forEach((key, value) {
        if (key is String && value is int && value > 0) {
          result[key] = value;
        } else if (key is String && value is num && value > 0) {
          result[key] = value.toInt();
        }
      });
      return result;
    } catch (e, st) {
      debugPrint('[LocalStorage] plan progress load failed: $e\n$st');
      return {};
    }
  }

  Future<void> savePlanProgress(Map<String, int> progress) async {
    try {
      await _store.setString(_Keys.planProgress, jsonEncode(progress));
    } catch (e, st) {
      debugPrint('[LocalStorage] plan progress save failed: $e\n$st');
    }
  }

  Future<void> savePlayingAudioId(String? id) async {
    try {
      if (id == null || id.isEmpty) {
        await _store.remove(_Keys.playingAudioId);
      } else {
        await _store.setString(_Keys.playingAudioId, id);
      }
    } catch (e, st) {
      debugPrint('[LocalStorage] audio save failed: $e\n$st');
    }
  }

  // ── Reset ───────────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    try {
      await _store.remove(_Keys.journalEntries);
      await _store.remove(_Keys.premiumUnlocked);
      await _store.remove(_Keys.premiumEntitlement);
      await _store.remove(_Keys.startedPlanIds);
      await _store.remove(_Keys.completedDevotionalIds);
      await _store.remove(_Keys.playingAudioId);
      await _store.remove(_Keys.planProgress);
    } catch (e, st) {
      debugPrint('[LocalStorage] clear failed: $e\n$st');
    }
  }
}
