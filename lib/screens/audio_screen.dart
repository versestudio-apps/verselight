import 'package:flutter/material.dart';

import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/premium_gate.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  static const _tracks = [
    _AudioItem(
      title: 'Psalm 23 — NIV',
      duration: '3:42',
      isPremium: false,
    ),
    _AudioItem(
      title: 'Morning Devotional — Trust',
      duration: '8:15',
      isPremium: false,
    ),
    _AudioItem(
      title: 'Gospel of John (sample)',
      duration: '45:00',
      isPremium: true,
    ),
    _AudioItem(
      title: 'Worship Playlist — Peace',
      duration: '32:10',
      isPremium: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined),
            onPressed: () => AppRoutes.openPaywall(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tracks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final track = _tracks[index];
          final tile = _AudioTile(
            track: track,
            onPlay: () {
              if (track.isPremium) {
                AppRoutes.openPaywall(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Playing (mock): ${track.title}')),
                );
              }
            },
          );

          if (track.isPremium) {
            return PremiumGate(child: tile);
          }
          return tile;
        },
      ),
    );
  }
}

class _AudioItem {
  const _AudioItem({
    required this.title,
    required this.duration,
    required this.isPremium,
  });

  final String title;
  final String duration;
  final bool isPremium;
}

class _AudioTile extends StatelessWidget {
  const _AudioTile({required this.track, required this.onPlay});

  final _AudioItem track;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.sageLight,
          child: Icon(
            track.isPremium ? Icons.lock_rounded : Icons.play_arrow_rounded,
            color: AppColors.sage,
          ),
        ),
        title: Text(track.title),
        subtitle: Text(track.duration),
        trailing: IconButton(
          icon: const Icon(Icons.headphones_rounded),
          onPressed: onPlay,
        ),
        onTap: onPlay,
      ),
    );
  }
}
