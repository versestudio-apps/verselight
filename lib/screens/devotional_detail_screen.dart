import 'package:flutter/material.dart';

import '../models/devotional.dart';
import '../utils/theme.dart';

class DevotionalDetailScreen extends StatelessWidget {
  const DevotionalDetailScreen({super.key, required this.devotional});

  final Devotional devotional;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(devotional.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.parchment,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.goldSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  devotional.verseRef,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  devotional.verseText,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Reflection', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(devotional.bodyFull, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.sageLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_rounded,
                        size: 20, color: AppColors.sage),
                    const SizedBox(width: 8),
                    Text(
                      'Journal prompt',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.sage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  devotional.reflectionPrompt,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
