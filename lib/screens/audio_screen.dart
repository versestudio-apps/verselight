import 'package:flutter/material.dart';

import '../data/sample_audio.dart';
import '../models/audio_track.dart';
import '../utils/premium_access.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/premium_gate.dart';
import '../widgets/screen_app_bar.dart';
import '../widgets/soft_icon_badge.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final theme = Theme.of(context);

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
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
                child: Row(
                  children: [
                    const SoftIconBadge(
                      icon: Icons.spa_rounded,
                      color: AppColors.softRose,
                      size: 36,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Scripture and devotionals for your commute or quiet time.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: isPlaying
                  ? AppColors.warmGold.withValues(alpha: 0.55)
                  : AppColors.border,
            ),
            boxShadow: AppShadows.hairline,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isPlaying
                          ? [
                              AppColors.goldTint
                                  .withValues(alpha: 0.85),
                              AppColors.softCream,
                            ]
                          : [
                              AppColors.softCream,
                              AppColors.ivory,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : (track.isPremium
                            ? Icons.auto_awesome_rounded
                            : Icons.play_arrow_rounded),
                    color: isPlaying
                        ? AppColors.warmGold
                        : (track.isPremium
                            ? AppColors.warmGold
                            : AppColors.sageGreen),
                    size: 26,
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
                const SizedBox(width: 8),
                Text(
                  track.durationLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.slate,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
            color: AppColors.deepNavy.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              const SoftIconBadge(
                icon: Icons.graphic_eq_rounded,
                color: AppColors.warmGold,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NOW PLAYING',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: AppColors.warmGold,
                      ),
                    ),
                    const SizedBox(height: 2),
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
                icon: const Icon(Icons.stop_circle_outlined),
                color: AppColors.slate,
                onPressed: () => appState.setPlayingAudio(null),
                tooltip: 'Stop',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
