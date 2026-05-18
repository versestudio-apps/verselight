import 'package:flutter/material.dart';

import '../data/sample_audio.dart';
import '../models/audio_track.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/premium_gate.dart';
import '../widgets/screen_app_bar.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'Audio', showSettings: false),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final playing = audioTrackById(appState.playingAudioId ?? '');

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sampleAudioTracks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final track = sampleAudioTracks[index];
                    final tile = _AudioTile(
                      track: track,
                      isPlaying: appState.playingAudioId == track.id,
                      onPlay: () => _onPlay(context, track),
                    );
                    if (track.isPremium) {
                      return PremiumGate(child: tile);
                    }
                    return tile;
                  },
                ),
              ),
              if (playing != null) _NowPlayingBar(track: playing),
            ],
          );
        },
      ),
    );
  }

  void _onPlay(BuildContext context, AudioTrack track) {
    final appState = AppStateScope.of(context);
    if (track.isPremium && !appState.isPremium) {
      AppRoutes.openPaywall(context);
      return;
    }
    appState.setPlayingAudio(track.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing (mock): ${track.title}')),
    );
  }
}

class _AudioTile extends StatelessWidget {
  const _AudioTile({
    required this.track,
    required this.isPlaying,
    required this.onPlay,
  });

  final AudioTrack track;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPlaying
              ? AppColors.goldSoft
              : AppColors.sageLight,
          child: Icon(
            isPlaying
                ? Icons.pause_rounded
                : (track.isPremium
                    ? Icons.lock_rounded
                    : Icons.play_arrow_rounded),
            color: isPlaying ? AppColors.gold : AppColors.sage,
          ),
        ),
        title: Text(track.title),
        subtitle: Text('${track.durationLabel} · ${track.subtitle}'),
        trailing: IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
            color: AppColors.gold,
          ),
          onPressed: onPlay,
        ),
        onTap: onPlay,
      ),
    );
  }
}

class _NowPlayingBar extends StatelessWidget {
  const _NowPlayingBar({required this.track});
  final AudioTrack track;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Material(
      elevation: 8,
      color: AppColors.parchment,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.graphic_eq_rounded, color: AppColors.gold),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Now playing (mock)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      track.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => appState.setPlayingAudio(null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
