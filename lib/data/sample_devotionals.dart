import '../models/devotional.dart';

const List<Devotional> sampleDevotionals = [
  Devotional(
    id: 'devo-1',
    title: 'Trust in the Lord',
    verseText:
        '"Trust in the Lord with all your heart and lean not on your own understanding."',
    verseRef: 'Proverbs 3:5 (NIV)',
    bodyPreview:
        'What does it mean to trust God when life feels uncertain? Today we explore surrender and resting in His plan.',
    bodyFull:
        'Trust is not the absence of questions—it is the presence of faith in the One who holds every answer. '
        'When we lean on our own understanding, we carry burdens we were never meant to bear alone.\n\n'
        'Today, invite God into one decision you have been trying to control. '
        'Acknowledge that His wisdom surpasses your own, and ask for courage to take the next faithful step.',
    reflectionPrompt:
        'Where is God asking you to trust Him today instead of relying on your own plan?',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-2',
    title: 'Peace That Surpasses',
    verseText:
        '"And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus."',
    verseRef: 'Philippians 4:7 (NIV)',
    bodyPreview:
        'Anxiety is real—but so is the peace Christ offers. A short reflection on bringing worries to God in prayer.',
    bodyFull:
        'Paul wrote these words from prison, yet spoke of peace that defies circumstance. '
        'This peace is not a feeling we manufacture; it is a gift we receive through prayer and gratitude.\n\n'
        'Before you move on with your day, name three blessings—large or small—and thank God for each one. '
        'Let thanksgiving quiet your heart and make room for His guard over your mind.',
    reflectionPrompt:
        'What worry can you hand to God in prayer right now?',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-3',
    title: 'Hope and a Future',
    verseText:
        '"For I know the plans I have for you," declares the Lord, "plans to prosper you and not to harm you, plans to give you hope and a future."',
    verseRef: 'Jeremiah 29:11 (NIV)',
    bodyPreview:
        'God\'s promises stand even in waiting seasons. Walk through Jeremiah 29 with fresh eyes for today.',
    bodyFull:
        'This beloved verse was spoken to exiles waiting seventy years—not to people who had already arrived. '
        'Hope, for Israel, meant faithfulness in the in-between.\n\n'
        'If you are in a waiting season, remember: God is still writing your story. '
        'Seek Him in the present moment rather than only in the outcome you are longing for.',
    reflectionPrompt:
        'How can you remain faithful while you wait for God\'s timing?',
    isPremium: true,
  ),
  Devotional(
    id: 'devo-4',
    title: 'Be Still',
    verseText: '"Be still, and know that I am God."',
    verseRef: 'Psalm 46:10 (NIV)',
    bodyPreview:
        'In a noisy world, stillness is a spiritual discipline. Practical steps for a five-minute pause with Scripture.',
    bodyFull:
        'Stillness is an act of trust. When we stop striving, we declare that God is God and we are not.\n\n'
        'Set a timer for five minutes. Breathe slowly, repeat this verse, and let every distraction pass '
        'without judgment. You do not need to perform for God—only to be present with Him.',
    reflectionPrompt:
        'When can you schedule five minutes of stillness with God this week?',
    isPremium: true,
  ),
];

Devotional? devotionalById(String id) {
  for (final d in sampleDevotionals) {
    if (d.id == id) return d;
  }
  return null;
}
