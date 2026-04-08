import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../providers/word_provider.dart';
import '../widgets/result_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_history.dart';
import 'saved_words_screen.dart';

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            20 + MediaQuery.viewInsetsOf(context).bottom,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate.fixed([
                              _HeaderBar(
                                titleStyle: theme.textTheme.headlineSmall,
                                bodyStyle: theme.textTheme.bodyMedium,
                                savedWordsCount: searchProvider.savedWordsCount,
                              ),
                              const SizedBox(height: 18),
                              SearchBarWidget(
                                query: searchProvider.query,
                                onChanged: searchProvider.onQueryChanged,
                                onSubmitted: searchProvider.search,
                                onClear: searchProvider.clearQuery,
                              ),
                              if (searchProvider.query.trim().isNotEmpty &&
                                  searchProvider
                                      .autocompleteSuggestions
                                      .isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: _SuggestionDropdown(
                                    suggestions:
                                        searchProvider.autocompleteSuggestions,
                                    onSelected: (value) {
                                      FocusScope.of(context).unfocus();
                                      searchProvider.searchFromHistory(value);
                                    },
                                  ),
                                ),
                              const SizedBox(height: 18),
                            ]),
                          ),
                        ),
                        ..._buildBodySlivers(
                          context,
                          wordProvider: wordProvider,
                          searchProvider: searchProvider,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBodySlivers(
    BuildContext context, {
    required WordProvider wordProvider,
    required SearchProvider searchProvider,
  }) {
    switch (wordProvider.loadingState) {
      case LoadingState.idle:
      case LoadingState.loading:
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: SliverList.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index == 4 ? 0 : 12),
                  child: const _LoadingCard(),
                );
              },
            ),
          ),
        ];
      case LoadingState.error:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: _StatusCard(
                icon: Icons.error_outline_rounded,
                title: 'Dictionary unavailable',
                message:
                    wordProvider.errorMessage ??
                    'Something went wrong while loading the dictionary.',
              ),
            ),
          ),
        ];
      case LoadingState.loaded:
        if (searchProvider.query.trim().isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SearchHistory(
                    history: searchProvider.searchHistory,
                    onTapHistory: searchProvider.searchFromHistory,
                    onClearHistory: searchProvider.clearHistory,
                  ),
                ),
              ),
            ),
          ];
        }

        if (searchProvider.results.isEmpty) {
          return [
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: _StatusCard(
                  icon: Icons.search_off_rounded,
                  title: 'No results found',
                  message:
                      'Try a shorter word, check the spelling, or use the suggestions above.',
                ),
              ),
            ),
          ];
        }

        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverList.builder(
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
                    onFavoriteToggle: () => searchProvider.toggleFavorite(word),
                  ),
                );
              },
            ),
          ),
          if (searchProvider.hasMoreResults)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: FilledButton.tonal(
                  onPressed: searchProvider.loadMoreResults,
                  child: const Text('Load more results'),
                ),
              ),
            )
          else
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ];
    }
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.titleStyle,
    required this.bodyStyle,
    required this.savedWordsCount,
  });

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  final int savedWordsCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Image.asset(
          'assets/logo.png',
          height: 38,
          width: 38,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MATLAB Dictionary',
                style: titleStyle?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              Text(
                'English to Urdu',
                style: bodyStyle?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.72,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Saved words',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SavedWordsScreen()),
            );
          },
          icon: Badge.count(
            count: savedWordsCount,
            isLabelVisible: savedWordsCount > 0,
            child: const Icon(Icons.bookmarks_rounded),
          ),
        ),
      ],
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

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(24),
      ),
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
