import '../models/reading_plan.dart';

const List<ReadingPlan> samplePlans = [
  ReadingPlan(
    id: 'plan-nt-30',
    title: '30-Day New Testament',
    emoji: '📖',
    durationDays: 30,
    description: 'Read through key passages of the New Testament in one month.',
    dayReadings: [
      'Day 1 — Matthew 1–2: The birth of Jesus',
      'Day 2 — Matthew 3–4: Baptism and temptation',
      'Day 3 — Matthew 5–7: Sermon on the Mount',
      'Day 4 — Matthew 8–9: Miracles of compassion',
      'Day 5 — Matthew 10: Sending the disciples',
    ],
    isPremium: false,
  ),
  ReadingPlan(
    id: 'plan-prayer-21',
    title: '21-Day Prayer Challenge',
    emoji: '🙏',
    durationDays: 21,
    description: 'Daily prompts to deepen your prayer rhythm.',
    dayReadings: [
      'Day 1 — Gratitude: Count your blessings',
      'Day 2 — Confession: Honest heart before God',
      'Day 3 — Intercession: Pray for one person by name',
      'Day 4 — Listening: Sit in silence for 5 minutes',
      'Day 5 — Scripture: Pray through Psalm 23',
    ],
    isPremium: true,
  ),
  ReadingPlan(
    id: 'plan-jesus-14',
    title: 'Life of Jesus',
    emoji: '✝️',
    durationDays: 14,
    description: 'Follow Christ from Bethlehem to the empty tomb.',
    dayReadings: [
      'Day 1 — Luke 2: Birth and childhood',
      'Day 2 — Luke 3–4: Ministry begins',
      'Day 3 — John 3: Nicodemus',
      'Day 4 — Matthew 14: Walking on water',
      'Day 5 — John 11: Lazarus raised',
    ],
    isPremium: true,
  ),
  ReadingPlan(
    id: 'plan-psalms-30',
    title: 'Psalms & Praise',
    emoji: '🌿',
    durationDays: 30,
    description: 'A month of worship, lament, and thanksgiving in the Psalms.',
    dayReadings: [
      'Day 1 — Psalm 1: Two ways to live',
      'Day 2 — Psalm 8: The majesty of God',
      'Day 3 — Psalm 23: The Good Shepherd',
      'Day 4 — Psalm 46: God is our refuge',
      'Day 5 — Psalm 100: Enter with thanksgiving',
    ],
    isPremium: false,
  ),
];

ReadingPlan? planById(String id) {
  for (final p in samplePlans) {
    if (p.id == id) return p;
  }
  return null;
}
