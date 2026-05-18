import '../models/reading_plan.dart';

const List<ReadingPlan> samplePlans = [
  ReadingPlan(
    id: 'plan-nt-30',
    title: '30-Day New Testament',
    emoji: '📖',
    durationDays: 30,
    description: 'Read through key passages of the New Testament in one month.',
    isPremium: false,
  ),
  ReadingPlan(
    id: 'plan-prayer-21',
    title: '21-Day Prayer Challenge',
    emoji: '🙏',
    durationDays: 21,
    description: 'Daily prompts to deepen your prayer rhythm.',
    isPremium: true,
  ),
  ReadingPlan(
    id: 'plan-jesus-14',
    title: 'Life of Jesus',
    emoji: '✝️',
    durationDays: 14,
    description: 'Follow Christ from Bethlehem to the empty tomb.',
    isPremium: true,
  ),
  ReadingPlan(
    id: 'plan-psalms-30',
    title: 'Psalms & Praise',
    emoji: '🌿',
    durationDays: 30,
    description: 'A month of worship, lament, and thanksgiving in the Psalms.',
    isPremium: false,
  ),
];
