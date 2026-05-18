class PrayerEntry {
  const PrayerEntry({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String text;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  static PrayerEntry? fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String?;
      final text = json['text'] as String?;
      final createdRaw = json['createdAt'] as String?;
      if (id == null || text == null || createdRaw == null) return null;
      final createdAt = DateTime.tryParse(createdRaw);
      if (createdAt == null) return null;
      return PrayerEntry(id: id, text: text, createdAt: createdAt);
    } catch (_) {
      return null;
    }
  }
}
