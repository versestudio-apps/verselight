import 'package:flutter/material.dart';

import '../data/devotional_filters.dart';
import '../data/sample_devotionals.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/premium_gate.dart';
import '../widgets/screen_app_bar.dart';
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    'Short readings with reflection, prayer, and a simple action step.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
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
                            selectedColor:
                                AppColors.goldSoft.withValues(alpha: 0.55),
                            checkmarkColor: AppColors.gold,
                            side: BorderSide(
                              color: selected
                                  ? AppColors.gold
                                  : AppColors.goldSoft,
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
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No devotionals in this category yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
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
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
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
