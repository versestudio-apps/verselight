import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/theme.dart';

class VerseCard extends StatelessWidget {
  const VerseCard({
    super.key,
    required this.verseText,
    required this.verseRef,
    this.title,
    this.bodyPreview,
    this.isPremium = false,
    this.onTap,
  });

  final String? title;
  final String verseText;
  final String verseRef;
  final String? bodyPreview;
  final bool isPremium;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (isPremium)
                      const Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: AppColors.premium,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  verseRef,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.gold,
                        fontSize: 12,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                verseText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
              ),
              if (bodyPreview != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Text(
                  bodyPreview!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: '$verseText — $verseRef'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verse copied')),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy verse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
