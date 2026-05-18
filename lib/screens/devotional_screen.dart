import 'package:flutter/material.dart';

import '../data/sample_devotionals.dart';
import '../utils/routes.dart';
import '../widgets/affiliate_banner.dart';
import '../widgets/premium_gate.dart';
import '../widgets/verse_card.dart';

class DevotionalScreen extends StatelessWidget {
  const DevotionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devotional'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined),
            onPressed: () => AppRoutes.openPaywall(context),
          ),
        ],
      ),
      body: ListView.separated(
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
            onTap: devo.isPremium
                ? () => AppRoutes.openPaywall(context)
                : null,
          );

          if (devo.isPremium) {
            return PremiumGate(
              blurWhenLocked: true,
              child: card,
            );
          }
          return card;
        },
      ),
    );
  }
}
