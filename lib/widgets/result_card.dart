import 'package:flutter/material.dart';

import '../models/word_model.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.word,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final Word word;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pronunciation = _extractPronunciation(word.meanings);
    final displayMeanings = word.meanings
        .where((meaning) => !meaning.toLowerCase().startsWith('pronunciation:'))
        .toList(growable: false);

    return Card(
      elevation: 1.5,
      color: Colors.white.withValues(alpha: 0.92),
      shadowColor: colorScheme.primary.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.english,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (pronunciation != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          pronunciation,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary.withValues(alpha: 0.78),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              itemCount: displayMeanings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final meaning = displayMeanings[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == displayMeanings.length - 1 ? 0 : 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          meaning,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.45,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String? _extractPronunciation(List<String> meanings) {
    for (final meaning in meanings) {
      if (meaning.toLowerCase().startsWith('pronunciation:')) {
        return meaning.split(':').skip(1).join(':').trim();
      }
    }
    return null;
  }
}
