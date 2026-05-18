import 'package:flutter/material.dart';

import '../data/devotional_filters.dart';
import '../data/sample_devotionals.dart';
import '../utils/devotional_images.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/premium_gate.dart';
import '../widgets/screen_app_bar.dart';
import '../widgets/soft_icon_badge.dart';
import '../widgets/verse_card.dart';

class DevotionalScreen extends StatefulWidget {
  const DevotionalScreen({super.key});

  @override
  State<DevotionalScreen> createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends State<DevotionalScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final theme = Theme.of(context);
    final filtered = filterDevotionals(sampleDevotionals, _filter);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'Devotional', showSettings: false),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                  child: Text(
                    'Short readings with reflection, prayer, and a simple action step.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: devotionalFilterCategories.map((cat) {
                        final selected = _filter == cat;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (_) => setState(() => _filter = cat),
                            backgroundColor: AppColors.surface,
                            selectedColor:
                                AppColors.goldTint.withValues(alpha: 0.55),
                            checkmarkColor: AppColors.warmGold,
                            side: BorderSide(
                              color: selected
                                  ? AppColors.warmGold
                                  : AppColors.border,
                            ),
                            labelStyle: theme.textTheme.labelLarge?.copyWith(
                              color: selected
                                  ? AppColors.warmGold
                                  : AppColors.deepNavy,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SoftIconBadge(
                            icon: Icons.menu_book_rounded,
                            color: AppColors.warmGold,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No devotionals here yet',
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try another category — more readings are added in each update.',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  sliver: SliverList.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final devo = filtered[index];
                      final card = VerseCard(
                        title: devo.title,
                        verseText: devo.verseText,
                        verseRef: devo.verseRef,
                        bodyPreview: devo.bodyPreview,
                        imagePath: DevotionalImages.forDevotionalCategory(
                          devo.category,
                        ),
                        isPremium: devo.isPremium,
                        isCompleted:
                            appState.isDevotionalCompleted(devo.id),
                        onTap: () =>
                            AppRoutes.openDevotionalDetail(context, devo.id),
                      );
                      if (devo.isPremium) {
                        return PremiumGate(child: card);
                      }
                      return card;
                    },
                  ),
                ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: AffiliateBanner(
                    type: BannerType.audible,
                    category: 'Listen',
                    title: 'Audio devotionals',
                    subtitle: 'Try Audible free · Bible on audio',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
