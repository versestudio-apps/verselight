import 'package:flutter/material.dart';

import '../data/sample_devotionals.dart';
import '../utils/routes.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/premium_gate.dart';
import '../widgets/screen_app_bar.dart';
import '../widgets/verse_card.dart';

class DevotionalScreen extends StatelessWidget {
  const DevotionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'Devotional', showSettings: false),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sampleDevotionals.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == sampleDevotionals.length) {
                return const AffiliateBanner(
                  type: BannerType.audible,
                  title: 'Audio devotionals',
                  subtitle: 'Try Audible free →',
                );
              }

              final devo = sampleDevotionals[index];
              final card = VerseCard(
                title: devo.title,
                verseText: devo.verseText,
                verseRef: devo.verseRef,
                bodyPreview: devo.bodyPreview,
                isPremium: devo.isPremium,
                isCompleted: appState.isDevotionalCompleted(devo.id),
                onTap: () => AppRoutes.openDevotionalDetail(context, devo.id),
              );

              if (devo.isPremium) {
                return PremiumGate(child: card);
              }
              return card;
            },
          );
        },
      ),
    );
  }
}
