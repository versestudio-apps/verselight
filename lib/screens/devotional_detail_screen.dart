import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/devotional.dart';
import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/content_section.dart';

class DevotionalDetailScreen extends StatefulWidget {
  const DevotionalDetailScreen({super.key, required this.devotional});

  final Devotional devotional;

  @override
  State<DevotionalDetailScreen> createState() => _DevotionalDetailScreenState();
}

class _DevotionalDetailScreenState extends State<DevotionalDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppStateScope.of(context)
          .markDevotionalCompleted(widget.devotional.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final devotional = widget.devotional;
    final theme = Theme.of(context);
    final completed = AppStateScope.of(context)
        .isDevotionalCompleted(devotional.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(devotional.title),
        actions: [
          if (completed)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                avatar: const Icon(Icons.check_rounded,
                    size: 18, color: AppColors.sage),
                label: const Text('Completed'),
                backgroundColor: AppColors.sageLight,
                side: BorderSide.none,
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.sage,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 36),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.goldSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  devotional.verseRef.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 11,
                    letterSpacing: 1.1,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  devotional.verseText,
                  style: GoogleFonts.lora(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: AppColors.warmBrown,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ContentSection(
            icon: Icons.wb_sunny_outlined,
            title: 'Reflection',
            body: devotional.bodyFull,
          ),
          const SizedBox(height: 14),
          ContentSection(
            icon: Icons.favorite_outline_rounded,
            title: 'Prayer',
            body: devotional.prayerPrompt,
            accent: AppColors.sageLight,
            iconColor: AppColors.sage,
          ),
          const SizedBox(height: 14),
          ContentSection(
            icon: Icons.directions_walk_rounded,
            title: 'Action step',
            body: devotional.actionStep,
            accent: AppColors.surface,
            iconColor: AppColors.warmBrown,
          ),
          const SizedBox(height: 20),
          Text(
            'Journal prompt',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.warmBrownMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            devotional.reflectionPrompt,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
