import 'package:flutter/material.dart';

import '../data/sample_audio.dart';
import '../models/audio_track.dart';
import '../utils/premium_access.dart';
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Scripture and devotionals for your commute or quiet time.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sampleAudioTracks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final track = sampleAudioTracks[index];
                    final tile = _AudioTrackCard(
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
    if (!PremiumAccess.guardNavigation(
      context,
      contentIsPremium: track.isPremium,
    )) {
      return;
    }
    final isSame = appState.playingAudioId == track.id;
    appState.setPlayingAudio(isSame ? null : track.id);
    if (!isSame) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing (mock): ${track.title}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _AudioTrackCard extends StatelessWidget {
  const _AudioTrackCard({
    required this.track,
    required this.isPlaying,
    required this.onPlay,
  });

  final AudioTrack track;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPlaying
                      ? AppColors.goldSoft
                      : AppColors.sageLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPlaying
                      ? Icons.pause_rounded
                      : (track.isPremium
                          ? Icons.lock_rounded
                          : Icons.play_arrow_rounded),
                  color: isPlaying ? AppColors.gold : AppColors.sage,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(track.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      track.subtitle,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                track.durationLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.warmBrownMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.warmBrown.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(color: AppColors.goldSoft.withValues(alpha: 0.6)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.goldSoft.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.graphic_eq_rounded,
                    color: AppColors.gold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NOW PLAYING',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: AppColors.gold,
                      ),
                    ),
                    Text(
                      track.title,
                      style: theme.textTheme.titleMedium,
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
