import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../providers/word_provider.dart';
import '../widgets/result_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_history.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final wordProvider = context.read<WordProvider>();
      await wordProvider.initialize();

      if (!mounted || !wordProvider.isLoaded) {
        return;
      }

      await context.read<SearchProvider>().initialize(wordProvider.words);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final wordProvider = context.watch<WordProvider>();
    final searchProvider = context.watch<SearchProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          Positioned(
            top: -60,
            right: -20,
            child: _GlowOrb(
              size: 220,
              colors: [
                colorScheme.secondary.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: -80,
            child: _GlowOrb(
              size: 220,
              colors: [
                colorScheme.tertiary.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    children: [
                      _HeaderCard(
                        titleStyle: theme.textTheme.headlineSmall,
                        bodyStyle: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      SearchBarWidget(
                        query: searchProvider.query,
                        onChanged: searchProvider.onQueryChanged,
                        onSubmitted: searchProvider.search,
                        onClear: searchProvider.clearQuery,
                      ),
                      if (searchProvider.query.trim().isNotEmpty &&
                          searchProvider.autocompleteSuggestions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _SuggestionDropdown(
                            suggestions: searchProvider.autocompleteSuggestions,
                            onSelected: searchProvider.searchFromHistory,
                          ),
                        ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: _buildBody(
                          context,
                          wordProvider: wordProvider,
                          searchProvider: searchProvider,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required WordProvider wordProvider,
    required SearchProvider searchProvider,
  }) {
    switch (wordProvider.loadingState) {
      case LoadingState.idle:
      case LoadingState.loading:
        return const _LoadingSkeleton();
      case LoadingState.error:
        return _StatusCard(
          icon: Icons.error_outline_rounded,
          title: 'Dictionary unavailable',
          message:
              wordProvider.errorMessage ??
              'Something went wrong while loading the dictionary.',
        );
      case LoadingState.loaded:
        if (searchProvider.query.trim().isEmpty) {
          return SearchHistory(
            history: searchProvider.searchHistory,
            onTapHistory: searchProvider.searchFromHistory,
            onClearHistory: searchProvider.clearHistory,
          );
        }

        if (searchProvider.results.isEmpty) {
          return const _StatusCard(
            icon: Icons.search_off_rounded,
            title: 'No results found',
            message:
                'Try a shorter word, check the spelling, or use the suggestions above.',
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: searchProvider.visibleResults.length,
                itemBuilder: (context, index) {
                  final word = searchProvider.visibleResults[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == searchProvider.visibleResults.length - 1
                          ? 0
                          : 12,
                    ),
                    child: ResultCard(
                      word: word,
                      isFavorite: searchProvider.isFavorite(word.english),
                      onFavoriteToggle: () =>
                          searchProvider.toggleFavorite(word),
                    ),
                  );
                },
              ),
            ),
            if (searchProvider.hasMoreResults)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: FilledButton.tonal(
                  onPressed: searchProvider.loadMoreResults,
                  child: const Text('Load more results'),
                ),
              ),
          ],
        );
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.titleStyle, required this.bodyStyle});

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.76),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.62)),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.10),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 74,
                width: 74,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorScheme.primary, colorScheme.tertiary],
                  ),
                ),
                child: Image.asset('assets/logo.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'English to Urdu Dictionary',
                      style: titleStyle?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Fast search, smart suggestions, and persistent history for 100,000 words.',
                      style: bodyStyle?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.75,
                        ),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionDropdown extends StatelessWidget {
  const _SuggestionDropdown({
    required this.suggestions,
    required this.onSelected,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 2,
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              dense: true,
              leading: Icon(
                Icons.north_west_rounded,
                color: colorScheme.primary,
              ),
              title: Text(suggestion),
              onTap: () => onSelected(suggestion),
            );
          },
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == 4 ? 0 : 12),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.74),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}
