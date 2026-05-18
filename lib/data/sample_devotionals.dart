import '../models/devotional.dart';

const List<Devotional> sampleDevotionals = [
  Devotional(
    id: 'devo-1',
    title: 'Trust in the Lord',
    verseText:
        '"Trust in the Lord with all your heart and lean not on your own understanding."',
    verseRef: 'Proverbs 3:5 (NIV)',
    bodyPreview:
        'What does it mean to trust God when life feels uncertain?',
    bodyFull:
        'Trust is not the absence of questions—it is faith in the One who holds every answer. '
        'Today, invite God into one decision you have been trying to control.',
    reflectionPrompt:
        'Where is God asking you to trust Him instead of your own plan?',
    prayerPrompt:
        'Lord, I release what I cannot control. Give me courage for the next faithful step.',
    actionStep: 'Name one worry and surrender it in prayer before noon.',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-2',
    title: 'Peace That Surpasses',
    verseText:
        '"And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus."',
    verseRef: 'Philippians 4:7 (NIV)',
    bodyPreview:
        'Anxiety is real—but so is the peace Christ offers.',
    bodyFull:
        'Paul wrote from prison about peace that defies circumstance. '
        'Thanksgiving makes room for God to guard your heart and mind.',
    reflectionPrompt: 'What worry can you hand to God in prayer right now?',
    prayerPrompt:
        'Father, quiet my mind. Help me receive Your peace that I cannot manufacture.',
    actionStep: 'Write down three blessings and thank God for each one.',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-3',
    title: 'Hope and a Future',
    verseText:
        '"For I know the plans I have for you," declares the Lord, "plans to give you hope and a future."',
    verseRef: 'Jeremiah 29:11 (NIV)',
    bodyPreview:
        'God\'s promises stand even in waiting seasons.',
    bodyFull:
        'This word was spoken to exiles still waiting—not to those who had already arrived. '
        'Hope means faithfulness in the in-between.',
    reflectionPrompt:
        'How can you remain faithful while you wait for God\'s timing?',
    prayerPrompt:
        'God, help me trust Your timeline when I cannot see the full picture.',
    actionStep: 'Read Jeremiah 29:11–13 slowly once today.',
    isPremium: true,
  ),
  Devotional(
    id: 'devo-4',
    title: 'Be Still',
    verseText: '"Be still, and know that I am God."',
    verseRef: 'Psalm 46:10 (NIV)',
    bodyPreview:
        'Stillness is a spiritual discipline in a noisy world.',
    bodyFull:
        'When we stop striving, we declare that God is God and we are not. '
        'Five quiet minutes with Him can reshape the rest of your day.',
    reflectionPrompt:
        'When can you schedule five minutes of stillness this week?',
    prayerPrompt:
        'Lord, slow my pace. Teach me to be present with You without performing.',
    actionStep: 'Set a five-minute timer, breathe, and repeat this verse.',
    isPremium: true,
  ),
];

Devotional? devotionalById(String id) {
  for (final d in sampleDevotionals) {
    if (d.id == id) return d;
  }
  return null;
}
