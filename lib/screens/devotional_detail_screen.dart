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
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sageMist,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.sageGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Read',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.sageGreen,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(
                label: devotional.category,
                color: AppColors.deepIndigo,
                background: AppColors.softCream,
              ),
              _MetaChip(
                icon: Icons.schedule_rounded,
                label: '${devotional.durationMinutes} min read',
                color: AppColors.sageGreen,
                background: AppColors.sageMist,
              ),
              if (devotional.isPremium)
                _MetaChip(
                  icon: Icons.auto_awesome_rounded,
                  label: 'Premium',
                  color: AppColors.warmGold,
                  background: AppColors.goldTint.withValues(alpha: 0.55),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.surface, AppColors.softCream],
              ),
              borderRadius: BorderRadius.circular(AppRadii.card),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      color: AppColors.warmGold,
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      devotional.verseRef.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        color: AppColors.warmGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  devotional.verseText,
                  style: GoogleFonts.lora(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                    color: AppColors.deepNavy,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          ContentSection(
            icon: Icons.wb_sunny_rounded,
            title: 'Reflection',
            body: devotional.reflection,
            accent: AppColors.warmGold,
          ),
          const SizedBox(height: 14),
          ContentSection(
            icon: Icons.favorite_rounded,
            title: 'Prayer',
            body: devotional.prayerPrompt,
            accent: AppColors.sageGreen,
            background: AppColors.sageMist,
          ),
          const SizedBox(height: 14),
          ContentSection(
            icon: Icons.directions_walk_rounded,
            title: 'Action step',
            body: devotional.actionStep,
            accent: AppColors.deepIndigo,
            background: AppColors.softCream,
          ),
          const SizedBox(height: 24),
          Text(
            'JOURNAL PROMPT',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.slate,
              letterSpacing: 1.1,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            devotional.journalPrompt,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.deepNavy,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  final IconData? icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
