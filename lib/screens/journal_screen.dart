import 'package:flutter/material.dart';

import '../models/prayer_entry.dart';
import '../utils/theme.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  final List<PrayerEntry> _entries = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addEntry() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _entries.insert(
        0,
        PrayerEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          createdAt: DateTime.now(),
        ),
      );
      _controller.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Journal')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Write a prayer or reflection',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Dear Lord, thank You for...',
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _addEntry,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Save note'),
                ),
                const SizedBox(height: 4),
                Text(
                  'Notes stay on this device for now (in-memory MVP).',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          size: 56,
                          color: AppColors.warmBrownMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your journal is empty',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add your first prayer note above',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatTime(entry.createdAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.gold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.text,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
