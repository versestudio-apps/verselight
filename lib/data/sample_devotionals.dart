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
    isPremium: true,
  ),
  Devotional(
    id: 'devo-4',
    title: 'Be Still',
    verseText: '"Be still, and know that I am God."',
    verseRef: 'Psalm 46:10 (NIV)',
    bodyPreview:
        'In a noisy world, stillness is a spiritual discipline. Practical steps for a five-minute pause with Scripture.',
    isPremium: true,
  ),
];
