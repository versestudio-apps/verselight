import '../models/devotional.dart';

/// Offline devotional catalog (10 entries). Stable ids: devo-1 … devo-10.
const List<Devotional> sampleDevotionals = [
  Devotional(
    id: 'devo-1',
    title: 'Trust in the Lord',
    category: 'Faith',
    tags: ['trust', 'wisdom'],
    mood: 'Steady',
    durationMinutes: 4,
    verseReference: 'Proverbs 3:5 (NIV)',
    verseText:
        '"Trust in the Lord with all your heart and lean not on your own understanding."',
    preview: 'When life feels uncertain, surrender is an act of faith—not failure.',
    reflection:
        'Trust is not the absence of questions. It is choosing God\'s wisdom over the weight of trying to control everything alone.',
    prayerPrompt:
        'Lord, I release what I cannot control. Give me courage for the next faithful step.',
    journalPrompt:
        'Where is God asking you to trust Him instead of your own plan?',
    actionStep: 'Name one worry and surrender it in prayer before noon.',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-2',
    title: 'Peace for Anxious Hearts',
    category: 'Anxiety',
    tags: ['peace', 'worry'],
    mood: 'Calm',
    durationMinutes: 4,
    verseReference: 'Philippians 4:6–7 (NIV)',
    verseText:
        '"Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God."',
    preview: 'Anxiety is real—and so is the peace God offers when we bring Him our worries.',
    reflection:
        'Paul wrote about peace that guards hearts and minds. Thanksgiving opens the door for that guard to take its post.',
    prayerPrompt:
        'Father, quiet my racing thoughts. I bring You what I cannot carry alone.',
    journalPrompt: 'What worry can you hand to God in prayer right now?',
    actionStep: 'Write down three blessings and thank God for each one.',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-3',
    title: 'Hope and a Future',
    category: 'Hope',
    tags: ['hope', 'waiting'],
    mood: 'Hopeful',
    durationMinutes: 5,
    verseReference: 'Jeremiah 29:11 (NIV)',
    verseText:
        '"For I know the plans I have for you," declares the Lord, "plans to give you hope and a future."',
    preview: 'God\'s promise was spoken to people still waiting—not those who had already arrived.',
    reflection:
        'Hope in Scripture often looks like faithfulness in the in-between. God is still writing your story.',
    prayerPrompt:
        'God, help me trust Your timing when I cannot see the full picture.',
    journalPrompt:
        'How can you remain faithful while you wait for God\'s timing?',
    actionStep: 'Read Jeremiah 29:11–13 slowly once today.',
    isPremium: true,
  ),
  Devotional(
    id: 'devo-4',
    title: 'Be Still',
    category: 'Faith',
    tags: ['stillness', 'rest'],
    mood: 'Quiet',
    durationMinutes: 3,
    verseReference: 'Psalm 46:10 (NIV)',
    verseText: '"Be still, and know that I am God."',
    preview: 'Stillness is a gentle discipline in a noisy world.',
    reflection:
        'When we stop striving, we declare that God is God and we are not. Five quiet minutes can reshape a day.',
    prayerPrompt:
        'Lord, slow my pace. Teach me to be present with You without performing.',
    journalPrompt:
        'When can you schedule five minutes of stillness this week?',
    actionStep: 'Set a five-minute timer, breathe, and repeat this verse.',
    isPremium: true,
  ),
  Devotional(
    id: 'devo-5',
    title: 'Morning Mercies',
    category: 'Morning',
    tags: ['morning', 'new day'],
    mood: 'Fresh',
    durationMinutes: 3,
    verseReference: 'Lamentations 3:22–23 (NIV)',
    verseText:
        '"His compassions never fail. They are new every morning; great is your faithfulness."',
    preview: 'Each sunrise is an invitation to receive mercy that was not exhausted yesterday.',
    reflection:
        'You do not have to earn a fresh start. God\'s compassion meets you before your to-do list does.',
    prayerPrompt:
        'Thank You, Lord, for new mercies today. Guide my words and priorities.',
    journalPrompt: 'What are you grateful for before this day gets busy?',
    actionStep: 'Before checking your phone, pray one sentence of gratitude.',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-6',
    title: 'Rest at Night',
    category: 'Night',
    tags: ['sleep', 'rest'],
    mood: 'Gentle',
    durationMinutes: 3,
    verseReference: 'Psalm 4:8 (NIV)',
    verseText:
        '"In peace I will lie down and sleep, for you alone, Lord, make me dwell in safety."',
    preview: 'You can lay down the day—not because everything is solved, but because God keeps watch.',
    reflection:
        'Night is a gift: permission to stop producing and to trust the One who neither slumbers nor sleeps.',
    prayerPrompt:
        'Lord, I release today into Your hands. Guard my rest and quiet my mind.',
    journalPrompt: 'What from today can you leave with God overnight?',
    actionStep: 'Name one burden and whisper, "I give this to You tonight."',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-7',
    title: 'A Grateful Heart',
    category: 'Gratitude',
    tags: ['thanks', 'joy'],
    mood: 'Warm',
    durationMinutes: 4,
    verseReference: '1 Thessalonians 5:18 (NIV)',
    verseText: '"Give thanks in all circumstances; for this is God\'s will for you in Christ Jesus."',
    preview: 'Gratitude does not deny hardship—it chooses to notice grace in the middle of it.',
    reflection:
        'Thanks shifts our gaze from scarcity to presence. Even small gifts become anchors when we name them.',
    prayerPrompt:
        'Thank You for blessings seen and unseen. Make me quick to notice goodness.',
    journalPrompt: 'Name three gifts from today—large or small.',
    actionStep: 'Text one person appreciation for something specific they did.',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-8',
    title: 'Courage to Believe',
    category: 'Faith',
    tags: ['belief', 'courage'],
    mood: 'Bold',
    durationMinutes: 4,
    verseReference: 'Hebrews 11:1 (NIV)',
    verseText:
        '"Faith is confidence in what we hope for and assurance about what we do not see."',
    preview: 'Faith is not blind optimism—it is grounded confidence in a trustworthy God.',
    reflection:
        'Belief often grows in ordinary obedience: showing up, telling the truth, forgiving, trying again.',
    prayerPrompt:
        'Jesus, strengthen my faith where it feels thin. Help me act on what I believe.',
    journalPrompt: 'Where does your faith feel thin right now?',
    actionStep: 'Take one small step you have been postponing out of fear.',
    isPremium: false,
  ),
  Devotional(
    id: 'devo-9',
    title: 'When Worry Knocks',
    category: 'Anxiety',
    tags: ['anxiety', 'cast cares'],
    mood: 'Honest',
    durationMinutes: 4,
    verseReference: '1 Peter 5:7 (NIV)',
    verseText: '"Cast all your anxiety on him because he cares for you."',
    preview: 'Casting anxiety is not a one-time event—it is a rhythm of returning worries to God.',
    reflection:
        'God\'s care is not distant. You are invited to hand Him specifics, not just vague stress.',
    prayerPrompt:
        'Lord, I cast my anxieties on You. Hold what feels too heavy for me today.',
    journalPrompt: 'What specific anxiety will you cast on God today?',
    actionStep: 'Write your top worry on paper, pray over it, then tear it up or file it away.',
    isPremium: true,
  ),
  Devotional(
    id: 'devo-10',
    title: 'Purpose in the Ordinary',
    category: 'Hope',
    tags: ['purpose', 'calling'],
    mood: 'Grounded',
    durationMinutes: 5,
    verseReference: 'Ephesians 2:10 (NIV)',
    verseText:
        '"We are God\'s handiwork, created in Christ Jesus to do good works, which God prepared in advance for us to do."',
    preview: 'Purpose is often found in faithful ordinary moments, not only dramatic milestones.',
    reflection:
        'Your life is not an accident. Today\'s kindness, integrity, and patience can be holy work.',
    prayerPrompt:
        'Father, open my eyes to the good works You prepared for me today.',
    journalPrompt: 'Where might God be inviting you to serve in the ordinary today?',
    actionStep: 'Do one unseen act of service without telling anyone.',
    isPremium: true,
  ),
];

/// Today's featured devotional (Morning category when before noon).
Devotional todayDevotional([DateTime? now]) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour < 12) {
    return sampleDevotionals.firstWhere((d) => d.id == 'devo-5');
  }
  if (hour >= 21) {
    return sampleDevotionals.firstWhere((d) => d.id == 'devo-6');
  }
  return sampleDevotionals.first;
}
