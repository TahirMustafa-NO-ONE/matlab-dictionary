import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../widgets/result_card.dart';

class SavedWordsScreen extends StatelessWidget {
  const SavedWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Words'), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              colorScheme.primary.withValues(alpha: 0.08),
              colorScheme.tertiary.withValues(alpha: 0.14),
            ],
          ),
        ),
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            final savedWords = searchProvider.savedWords;

            if (savedWords.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.84),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_outline_rounded,
                          size: 42,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No saved words yet',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the bookmark icon on any result to keep it here for later.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              itemCount: savedWords.length,
              itemBuilder: (context, index) {
                final word = savedWords[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == savedWords.length - 1 ? 0 : 12,
                  ),
                  child: ResultCard(
                    word: word,
                    isFavorite: true,
                    onFavoriteToggle: () => searchProvider.toggleFavorite(word),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
