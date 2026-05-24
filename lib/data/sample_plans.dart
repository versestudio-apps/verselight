import '../models/plan_day.dart';
import '../models/reading_plan.dart';

/// Offline reading plans. Stable ids preserved for local persistence.
///
/// LICENSING NOTE (Phase 09L — Bible translation license review):
/// Every `verseText` below is an **original devotional paraphrase** written
/// for VerseLight, not a quote from any specific copyrighted translation
/// (NIV / ESV / NABRE / RSV / NRSV / CSB / NKJV / NLT). The earlier draft
/// labelled these "(NIV)" — that label has been removed and the wording
/// rewritten so VerseLight can ship to the Amazon Appstore without a Biblica
/// (NIV) or other publisher licensing agreement. `verseReference` keeps the
/// canonical Book Chapter:Verse pointer so users can open their own Bible
/// in any translation they hold a license to read.
///
/// When wiring a licensed translation later, replace each `verseText` with
/// the licensed wording and reinstate a translation suffix in
/// `verseReference`.
const List<ReadingPlan> samplePlans = [
  ReadingPlan(
    id: 'plan-nt-30',
    title: 'New Testament Week',
    subtitle: 'A gentle introduction to Jesus and the early church.',
    emoji: '📖',
    durationDays: 7,
    category: 'Bible',
    tags: ['new testament', 'gospels'],
    isPremium: false,
    days: [
      PlanDay(
        dayNumber: 1,
        title: 'The birth of Jesus',
        verseReference: 'Matthew 1:21',
        verseText:
            'Mary will bear a son, and his name—Jesus—declares his saving mission.',
        reflection: 'God entered our world quietly. Notice where He is present in your ordinary day.',
        actionStep: 'Read Matthew 1–2 slowly.',
      ),
      PlanDay(
        dayNumber: 2,
        title: 'Jesus is baptized',
        verseReference: 'Matthew 3:17',
        verseText:
            'From heaven the Father names Jesus as his beloved Son, in whom his delight rests.',
        reflection: 'Before public ministry, Jesus received the Father\'s blessing. You are loved before you perform.',
        actionStep: 'Write: "I am loved by God" and place it where you will see it.',
      ),
      PlanDay(
        dayNumber: 3,
        title: 'The Sermon on the Mount',
        verseReference: 'Matthew 5:9',
        verseText:
            'Those who make peace are called the children of God.',
        reflection: 'Kingdom life shapes character. Where can you pursue peace today?',
        actionStep: 'Pray for one strained relationship.',
      ),
      PlanDay(
        dayNumber: 4,
        title: 'Jesus calms the storm',
        verseReference: 'Mark 4:39',
        verseText:
            'Jesus speaks to the wind and the waves, and a sudden calm answers his command.',
        reflection: 'Storms do not mean God is absent. He speaks peace over chaos.',
        actionStep: 'Name the "storm" you face and invite Jesus into it.',
      ),
      PlanDay(
        dayNumber: 5,
        title: 'The Good Shepherd',
        verseReference: 'John 10:11',
        verseText:
            'Jesus calls himself the good shepherd—the one who lays down his life for the sheep.',
        reflection: 'Jesus guides, protects, and stays. You are known—not merely numbered.',
        actionStep: 'Spend five minutes in silence, listening.',
      ),
      PlanDay(
        dayNumber: 6,
        title: 'The cross and love',
        verseReference: 'John 3:16',
        verseText:
            'God\'s love for the world was so vast that he gave his only Son, that all who trust him may have eternal life.',
        reflection: 'Love moved toward us first. Receive—not only achieve.',
        actionStep: 'Thank Jesus aloud for one specific gift of grace.',
      ),
      PlanDay(
        dayNumber: 7,
        title: 'The resurrection hope',
        verseReference: 'Matthew 28:6',
        verseText:
            'The angel announces an empty tomb: Christ is risen, just as he promised.',
        reflection: 'Easter hope reframes every ending. What dead place needs resurrection hope?',
        actionStep: 'Share encouragement with someone who is discouraged.',
      ),
    ],
  ),
  ReadingPlan(
    id: 'plan-psalms-30',
    title: 'Psalms of Praise',
    subtitle: 'A week of worship, honesty, and thanksgiving.',
    emoji: '🌿',
    durationDays: 7,
    category: 'Worship',
    tags: ['psalms', 'praise'],
    isPremium: false,
    days: [
      PlanDay(
        dayNumber: 1,
        title: 'Two ways to live',
        verseReference: 'Psalm 1:2',
        verseText:
            'Happy are those whose joy is in God\'s word, meditated on day and night.',
        reflection: 'Delight is a rhythm, not a single moment. What small habit draws you toward God?',
        actionStep: 'Read Psalm 1.',
      ),
      PlanDay(
        dayNumber: 2,
        title: 'The majesty of God',
        verseReference: 'Psalm 8:1',
        verseText:
            'O Lord our God, how glorious is your name across all the earth.',
        reflection: 'Creation preaches. Look up or go outside and notice one detail that points to God.',
        actionStep: 'Take a photo or sketch something that stirs wonder.',
      ),
      PlanDay(
        dayNumber: 3,
        title: 'The Good Shepherd',
        verseReference: 'Psalm 23:1',
        verseText:
            'The Lord shepherds me—there is nothing I truly lack.',
        reflection: 'Sheep are led, not driven. Where do you need guidance more than pressure?',
        actionStep: 'Memorize verse 1.',
      ),
      PlanDay(
        dayNumber: 4,
        title: 'Honest lament',
        verseReference: 'Psalm 13:1',
        verseText:
            'How long, O Lord—will you seem to forget me?',
        reflection: 'Lament is prayer, not failure. God can handle your honest questions.',
        actionStep: 'Write a short honest prayer without editing it.',
      ),
      PlanDay(
        dayNumber: 5,
        title: 'Refuge',
        verseReference: 'Psalm 46:1',
        verseText:
            'God is our shelter and our strength, ever near when trouble arrives.',
        reflection: 'Refuge is close, not far. Breathe and remember help is present.',
        actionStep: 'Repeat the verse slowly three times.',
      ),
      PlanDay(
        dayNumber: 6,
        title: 'Enter with thanks',
        verseReference: 'Psalm 100:4',
        verseText:
            'Approach God\'s presence with thanksgiving; enter his courts with praise.',
        reflection: 'Gratitude is a doorway. List five gifts from this week.',
        actionStep: 'Share one gratitude with a friend.',
      ),
      PlanDay(
        dayNumber: 7,
        title: 'Everlasting love',
        verseReference: 'Psalm 136:1',
        verseText:
            'Give thanks to the Lord—his mercy endures forever.',
        reflection: 'God\'s love is not fragile. Rest in what does not expire.',
        actionStep: 'End the week with a song or hymn you love.',
      ),
    ],
  ),
  ReadingPlan(
    id: 'plan-prayer-21',
    title: 'Prayer Reset',
    subtitle: 'Seven days to deepen your conversation with God.',
    emoji: '🙏',
    durationDays: 7,
    category: 'Prayer',
    tags: ['prayer', 'discipline'],
    isPremium: true,
    days: [
      PlanDay(
        dayNumber: 1,
        title: 'Gratitude first',
        verseReference: 'Psalm 100:4',
        verseText:
            'Enter God\'s presence with thanksgiving on your lips.',
        reflection: 'Begin with thanks before requests. It recalibrates the heart.',
        actionStep: 'List ten gifts, great or small.',
      ),
      PlanDay(
        dayNumber: 2,
        title: 'Honest confession',
        verseReference: '1 John 1:9',
        verseText:
            'When we name our sins honestly, God is faithful—and quick to forgive.',
        reflection: 'Confession is truth-telling that leads to freedom, not shame-staying.',
        actionStep: 'Pray through the Lord\'s Prayer slowly.',
      ),
      PlanDay(
        dayNumber: 3,
        title: 'Intercession',
        verseReference: '1 Timothy 2:1',
        verseText:
            'Lift up requests, prayers, intercession, and thanks for everyone you can think of.',
        reflection: 'Prayer expands outward. Who needs your faithful intercession?',
        actionStep: 'Pray for three people by name.',
      ),
      PlanDay(
        dayNumber: 4,
        title: 'Listening',
        verseReference: 'Psalm 46:10',
        verseText:
            'Be still—remember that the Lord is God.',
        reflection: 'Prayer includes silence. Make space to listen, not only speak.',
        actionStep: 'Sit in silence for five minutes after praying.',
      ),
      PlanDay(
        dayNumber: 5,
        title: 'Scripture-fed prayer',
        verseReference: 'Psalm 119:105',
        verseText:
            'God\'s word lights the ground under your feet and the road ahead.',
        reflection: 'Let Scripture supply the language of prayer today.',
        actionStep: 'Pray through Psalm 23 phrase by phrase.',
      ),
      PlanDay(
        dayNumber: 6,
        title: 'Prayer walking',
        verseReference: '1 Thessalonians 5:17',
        verseText:
            'Let prayer become a steady rhythm running through your day.',
        reflection: 'Continual prayer can be simple breath prayers through the day.',
        actionStep: 'Take a ten-minute walk and pray for your neighborhood.',
      ),
      PlanDay(
        dayNumber: 7,
        title: 'Trust and rest',
        verseReference: 'Philippians 4:7',
        verseText:
            'The peace of God—beyond what we can explain—keeps your heart and mind safe.',
        reflection: 'End this week by entrusting outcomes to God.',
        actionStep: 'Write a prayer of surrender and keep it in your journal.',
      ),
    ],
  ),
  ReadingPlan(
    id: 'plan-jesus-14',
    title: 'Life of Jesus',
    subtitle: 'Follow Christ from Bethlehem to the empty tomb.',
    emoji: '✝️',
    durationDays: 7,
    category: 'Gospels',
    tags: ['jesus', 'gospel'],
    isPremium: true,
    days: [
      PlanDay(
        dayNumber: 1,
        title: 'Incarnation',
        verseReference: 'John 1:14',
        verseText:
            'The eternal Word took on flesh and made his home among us.',
        reflection: 'God drew near. The divine chose proximity.',
        actionStep: 'Read John 1:1–14.',
      ),
      PlanDay(
        dayNumber: 2,
        title: 'Teaching with authority',
        verseReference: 'Matthew 7:28',
        verseText:
            'The crowds were stunned by the weight and clarity of his teaching.',
        reflection: 'Jesus\' words heal and challenge. Which teaching do you need today?',
        actionStep: 'Read the Beatitudes (Matthew 5:1–12).',
      ),
      PlanDay(
        dayNumber: 3,
        title: 'Compassion',
        verseReference: 'Matthew 9:36',
        verseText:
            'When Jesus saw the crowd, his heart was moved with compassion for them.',
        reflection: 'Jesus sees weariness. Let His compassion shape yours.',
        actionStep: 'Do one practical act of kindness.',
      ),
      PlanDay(
        dayNumber: 4,
        title: 'Forgiveness',
        verseReference: 'Luke 23:34',
        verseText:
            'From the cross Jesus prays for those who put him there: Father, forgive them.',
        reflection: 'Forgiveness is costly and freeing. Who is God inviting you to forgive?',
        actionStep: 'Pray for someone who has hurt you.',
      ),
      PlanDay(
        dayNumber: 5,
        title: 'The cross',
        verseReference: 'Galatians 2:20',
        verseText:
            'I have been crucified with Christ—and the life I now live, Christ lives in me.',
        reflection: 'The cross is love and justice meeting. Pause and give thanks.',
        actionStep: 'Spend time in quiet reflection on the cross.',
      ),
      PlanDay(
        dayNumber: 6,
        title: 'The empty tomb',
        verseReference: 'Romans 6:4',
        verseText:
            'As Christ was raised from the dead, so we are raised to walk in newness of life.',
        reflection: 'Resurrection power reaches into daily habits and dead places.',
        actionStep: 'Identify one habit to surrender this week.',
      ),
      PlanDay(
        dayNumber: 7,
        title: 'Go and tell',
        verseReference: 'Matthew 28:19',
        verseText:
            'Go to all nations and make disciples—baptizing and teaching as Jesus commanded.',
        reflection: 'Following Jesus sends us outward with gentleness and truth.',
        actionStep: 'Encourage one person in their faith journey.',
      ),
    ],
  ),
  ReadingPlan(
    id: 'plan-gratitude-7',
    title: 'Gratitude Week',
    subtitle: 'Train your eyes to see grace in everyday life.',
    emoji: '🙌',
    durationDays: 7,
    category: 'Gratitude',
    tags: ['thanks', 'joy'],
    isPremium: false,
    days: [
      PlanDay(
        dayNumber: 1,
        title: 'Count gifts',
        verseReference: 'Psalm 103:2',
        verseText:
            'Bless the Lord, my soul, and do not forget the goodness he has given.',
        reflection: 'Forgetting is easy; remembering is spiritual discipline.',
        actionStep: 'List seven blessings before bed.',
      ),
      PlanDay(
        dayNumber: 2,
        title: 'Thank someone',
        verseReference: 'Colossians 3:15',
        verseText:
            'Let thankfulness shape who you are.',
        reflection: 'Gratitude grows when it is expressed, not only felt.',
        actionStep: 'Send a thank-you message today.',
      ),
      PlanDay(
        dayNumber: 3,
        title: 'Gratitude in hardship',
        verseReference: 'James 1:2–3',
        verseText:
            'Treat every trial as a chance for joy, knowing it shapes endurance in you.',
        reflection: 'This is not toxic positivity—it is trust that God is at work.',
        actionStep: 'Journal one hard thing and one hidden gift within it.',
      ),
      PlanDay(
        dayNumber: 4,
        title: 'Creation sings',
        verseReference: 'Psalm 19:1',
        verseText:
            'The sky preaches a sermon: God\'s glory written across the heavens.',
        reflection: 'Nature preaches. Receive the sermon on a short walk.',
        actionStep: 'Walk outside without headphones for ten minutes.',
      ),
      PlanDay(
        dayNumber: 5,
        title: 'Table gratitude',
        verseReference: 'Acts 2:46',
        verseText:
            'The early church shared meals in their homes, hearts open in gladness and trust.',
        reflection: 'Shared meals are sacred. Who can you welcome or encourage?',
        actionStep: 'Share a meal or coffee with someone.',
      ),
      PlanDay(
        dayNumber: 6,
        title: 'Generosity',
        verseReference: '2 Corinthians 9:7',
        verseText:
            'God delights in the giver whose heart is glad.',
        reflection: 'Giving is gratitude in motion.',
        actionStep: 'Give time, help, or resources to someone in need.',
      ),
      PlanDay(
        dayNumber: 7,
        title: 'Worship response',
        verseReference: 'Psalm 95:1–2',
        verseText:
            'Come—let us sing with joy to the Lord, the Rock of our salvation.',
        reflection: 'End the week by turning thanks into worship.',
        actionStep: 'Sing or play a worship song that means something to you.',
      ),
    ],
  ),
];
