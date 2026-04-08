import 'dart:collection';
import 'dart:math';

import '../models/word_model.dart';

class SearchService {
  SearchService();

  static const _maxSearchCacheEntries = 200;

  final LinkedHashMap<String, List<Word>> _searchCache =
      LinkedHashMap<String, List<Word>>();

  final _TrieNode _root = _TrieNode();
  List<Word> _sortedWords = const [];
  bool _isTrieReady = false;

  void initialize(List<Word> words) {
    _sortedWords = [...words]
      ..sort(
        (a, b) => a.english.toLowerCase().compareTo(b.english.toLowerCase()),
      );

    _buildTrie(_sortedWords);
    _searchCache.clear();
  }

  Word? binarySearch(List<Word> words, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return null;
    }

    var left = 0;
    var right = words.length - 1;

    while (left <= right) {
      final middle = left + ((right - left) >> 1);
      final comparison = words[middle].english.toLowerCase().compareTo(
        normalizedQuery,
      );

      if (comparison == 0) {
        return words[middle];
      }

      if (comparison < 0) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }

    return null;
  }

  List<String> getAutocompleteSuggestions(String prefix, {int limit = 10}) {
    final normalizedPrefix = prefix.trim().toLowerCase();
    if (!_isTrieReady || normalizedPrefix.isEmpty) {
      return const [];
    }

    var node = _root;
    for (final codeUnit in normalizedPrefix.codeUnits) {
      final character = String.fromCharCode(codeUnit);
      final next = node.children[character];
      if (next == null) {
        return const [];
      }
      node = next;
    }

    final suggestions = <String>[];
    _collectSuggestions(node, suggestions, limit);
    return suggestions;
  }

  List<Word> fuzzySearch(String query, {int threshold = 70}) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final scoredWords = <_ScoredWord>[];
    for (final word in _sortedWords) {
      final score = _similarityScore(
        normalizedQuery,
        word.english.toLowerCase(),
      );
      if (score >= threshold) {
        scoredWords.add(_ScoredWord(word: word, score: score));
      }
    }

    scoredWords.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) {
        return scoreComparison;
      }
      return a.word.english.toLowerCase().compareTo(
        b.word.english.toLowerCase(),
      );
    });

    return scoredWords
        .take(20)
        .map((entry) => entry.word)
        .toList(growable: false);
  }

  List<Word> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final cached = _searchCache.remove(normalizedQuery);
    if (cached != null) {
      _searchCache[normalizedQuery] = cached;
      return cached;
    }

    final results = <Word>[];
    final exactMatch = binarySearch(_sortedWords, normalizedQuery);
    if (exactMatch != null) {
      results.add(exactMatch);
    } else {
      final prefixSuggestions = getAutocompleteSuggestions(
        normalizedQuery,
        limit: 50,
      );
      if (prefixSuggestions.isNotEmpty) {
        for (final suggestion in prefixSuggestions) {
          final matchedWord = binarySearch(_sortedWords, suggestion);
          if (matchedWord != null) {
            results.add(matchedWord);
          }
        }
      } else {
        results.addAll(fuzzySearch(normalizedQuery));
      }
    }

    _searchCache[normalizedQuery] = results;
    if (_searchCache.length > _maxSearchCacheEntries) {
      _searchCache.remove(_searchCache.keys.first);
    }

    return results;
  }

  void _buildTrie(List<Word> words) {
    _root.children.clear();
    for (final word in words) {
      var node = _root;
      for (final codeUnit in word.english.toLowerCase().codeUnits) {
        final character = String.fromCharCode(codeUnit);
        node = node.children.putIfAbsent(character, _TrieNode.new);
      }
      node.isWord = true;
      node.word = word.english;
    }
    _isTrieReady = true;
  }

  void _collectSuggestions(
    _TrieNode node,
    List<String> suggestions,
    int limit,
  ) {
    if (suggestions.length >= limit) {
      return;
    }

    if (node.isWord && node.word != null) {
      suggestions.add(node.word!);
    }

    final sortedKeys = node.children.keys.toList()..sort();
    for (final key in sortedKeys) {
      _collectSuggestions(node.children[key]!, suggestions, limit);
      if (suggestions.length >= limit) {
        return;
      }
    }
  }

  int _similarityScore(String a, String b) {
    if (a == b) {
      return 100;
    }

    final distance = _levenshteinDistance(a, b);
    final maxLength = max(a.length, b.length);
    if (maxLength == 0) {
      return 100;
    }

    return ((1 - (distance / maxLength)) * 100).round();
  }

  int _levenshteinDistance(String source, String target) {
    if (source.isEmpty) {
      return target.length;
    }
    if (target.isEmpty) {
      return source.length;
    }

    final previousRow = List<int>.generate(target.length + 1, (index) => index);
    final currentRow = List<int>.filled(target.length + 1, 0);

    for (var i = 0; i < source.length; i++) {
      currentRow[0] = i + 1;
      for (var j = 0; j < target.length; j++) {
        final insertionCost = currentRow[j] + 1;
        final deletionCost = previousRow[j + 1] + 1;
        final substitutionCost =
            previousRow[j] + (source[i] == target[j] ? 0 : 1);
        currentRow[j + 1] = min(
          insertionCost,
          min(deletionCost, substitutionCost),
        );
      }

      for (var j = 0; j < previousRow.length; j++) {
        previousRow[j] = currentRow[j];
      }
    }

    return previousRow[target.length];
  }
}

class _TrieNode {
  final Map<String, _TrieNode> children = <String, _TrieNode>{};
  bool isWord = false;
  String? word;
}

class _ScoredWord {
  const _ScoredWord({required this.word, required this.score});

  final Word word;
  final int score;
}
