import '../models/audio_track.dart';

const List<AudioTrack> sampleAudioTracks = [
  AudioTrack(
    id: 'audio-psalm-23',
    title: 'Psalm 23 — NIV',
    durationLabel: '3:42',
    subtitle: 'Scripture audio · Free preview',
    isPremium: false,
  ),
  AudioTrack(
    id: 'audio-morning-trust',
    title: 'Morning Devotional — Trust',
    durationLabel: '8:15',
    subtitle: 'Today\'s devotional · Read aloud',
    isPremium: false,
  ),
  AudioTrack(
    id: 'audio-john',
    title: 'Gospel of John (sample)',
    durationLabel: '45:00',
    subtitle: 'Full book preview · Premium',
    isPremium: true,
  ),
  AudioTrack(
    id: 'audio-worship-peace',
    title: 'Worship Playlist — Peace',
    durationLabel: '32:10',
    subtitle: 'Instrumental worship · Premium',
    isPremium: true,
  ),
];

AudioTrack? audioTrackById(String id) {
  for (final t in sampleAudioTracks) {
    if (t.id == id) return t;
  }
  return null;
}
