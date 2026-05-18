class AudioTrack {
  const AudioTrack({
    required this.id,
    required this.title,
    required this.durationLabel,
    required this.subtitle,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String durationLabel;
  final String subtitle;
  final bool isPremium;
}
