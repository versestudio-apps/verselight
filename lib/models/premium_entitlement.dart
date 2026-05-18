/// Where the active premium entitlement was granted.
enum EntitlementSource {
  none,
  mock,
  googlePlay,
  amazonAppstore,
}

/// User's premium access state (local mock today; store-backed later).
class PremiumEntitlement {
  const PremiumEntitlement({
    required this.isPremium,
    required this.tier,
    required this.planId,
    required this.source,
    this.expiresAt,
    required this.updatedAt,
  });

  final bool isPremium;
  final String tier;
  final String? planId;
  final EntitlementSource source;
  final DateTime? expiresAt;
  final DateTime updatedAt;

  static const String tierFree = 'free';
  static const String tierPremium = 'premium';

  static PremiumEntitlement free() => PremiumEntitlement(
        isPremium: false,
        tier: tierFree,
        planId: null,
        source: EntitlementSource.none,
        updatedAt: DateTime.now(),
      );

  bool get isActive {
    if (!isPremium) return false;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }

  String get sourceLabel {
    switch (source) {
      case EntitlementSource.none:
        return 'Free';
      case EntitlementSource.mock:
        return 'Beta (mock)';
      case EntitlementSource.googlePlay:
        return 'Google Play';
      case EntitlementSource.amazonAppstore:
        return 'Amazon Appstore';
    }
  }

  Map<String, dynamic> toJson() => {
        'isPremium': isPremium,
        'tier': tier,
        'planId': planId,
        'source': source.name,
        'expiresAt': expiresAt?.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static PremiumEntitlement? fromJson(Map<String, dynamic> json) {
    try {
      final sourceName = json['source'] as String? ?? 'none';
      final source = EntitlementSource.values.firstWhere(
        (s) => s.name == sourceName,
        orElse: () => EntitlementSource.none,
      );
      return PremiumEntitlement(
        isPremium: json['isPremium'] as bool? ?? false,
        tier: json['tier'] as String? ?? tierFree,
        planId: json['planId'] as String?,
        source: source,
        expiresAt: json['expiresAt'] != null
            ? DateTime.tryParse(json['expiresAt'] as String)
            : null,
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }
}
