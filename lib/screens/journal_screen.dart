import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/app_state_scope.dart';
import '../widgets/journal_note_card.dart';
import '../widgets/screen_app_bar.dart';
import '../widgets/soft_icon_badge.dart';

const _prayerPrompts = [
  'Thank You for today\'s blessings…',
  'Lord, give me peace about…',
  'Help me trust You with…',
  'I pray for strength to…',
];

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyPrompt(String prompt) {
    _controller.text = prompt;
    _controller.selection = TextSelection.collapsed(offset: prompt.length);
  }

  Future<void> _addEntry() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await AppStateScope.of(context).addJournalEntry(text);
    _controller.clear();
    if (mounted) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'Prayer Journal', showSettings: false),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppShadows.hairline,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const SoftIconBadge(
                          icon: Icons.edit_note_rounded,
                          color: AppColors.sageGreen,
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'A quiet space for prayer',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Saved privately on this device.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _prayerPrompts.map((p) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              label: Text(p),
                              onPressed: () => _applyPrompt(p),
                              backgroundColor: AppColors.softCream,
                              labelStyle: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                color: AppColors.deepNavy,
                                fontWeight: FontWeight.w500,
                              ),
                              side: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Write your prayer or reflection…',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: _addEntry,
                        icon: const Icon(
                          Icons.bookmark_add_rounded,
                          size: 18,
                        ),
                        label: const Text('Save to journal'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: appState.journalEntries.isEmpty
                    ? const _EmptyJournal()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: appState.journalEntries.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final entry = appState.journalEntries[index];
                          return JournalNoteCard(
                            entry: entry,
                            timeLabel: _formatTime(entry.createdAt),
                            onDelete: () =>
                                appState.removeJournalEntry(entry.id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.month}/${dt.day}/${dt.year} · $h:$m $ampm';
  }
}

class _EmptyJournal extends StatelessWidget {
  const _EmptyJournal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SoftIconBadge(
              icon: Icons.favorite_rounded,
              color: AppColors.sageGreen,
              size: 72,
              iconSize: 32,
            ),
            const SizedBox(height: 20),
            Text(
              'Start your journal',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap a prompt above or write freely. '
              'Your prayers stay here until you choose to delete them.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
