import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/word_model.dart';
import '../services/search_service.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider({required SearchService searchService})
    : _searchService = searchService;

  static const _historyKey = 'search_history';
  static const _favoritesKey = 'favorite_words';
  static const _historyLimit = 20;
  static const _pageSize = 50;

  final SearchService _searchService;

  Timer? _debounce;
  SharedPreferences? _preferences;

  String _query = '';
  List<Word> _results = const [];
  List<String> _autocompleteSuggestions = const [];
  List<String> _searchHistory = const [];
  Set<String> _favoriteWords = <String>{};
  int _visibleCount = _pageSize;

  String get query => _query;
  List<Word> get results => _results;
  List<String> get autocompleteSuggestions => _autocompleteSuggestions;
  List<String> get searchHistory => _searchHistory;
  bool get hasMoreResults => _results.length > _visibleCount;

  List<Word> get visibleResults =>
      _results.take(_visibleCount).toList(growable: false);

  Future<void> initialize(List<Word> words) async {
    _searchService.initialize(words);
    _preferences ??= await SharedPreferences.getInstance();
    _searchHistory = _preferences?.getStringList(_historyKey) ?? const [];
    final favorites = _preferences?.getStringList(_favoritesKey) ?? const [];
    _favoriteWords = favorites.map((entry) => entry.toLowerCase()).toSet();
    notifyListeners();
  }

  void onQueryChanged(String value) {
    _query = value;
    _debounce?.cancel();

    if (value.trim().isEmpty) {
      _clearSearchState();
      notifyListeners();
      return;
    }

    _autocompleteSuggestions = _searchService.getAutocompleteSuggestions(value);
    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(value, clearSuggestions: false);
    });
  }

  Future<void> search(String value) async {
    await _performSearch(value, clearSuggestions: true);
  }

  Future<void> searchFromHistory(String value) async {
    _query = value;
    await search(value);
  }

  void clearQuery() {
    _debounce?.cancel();
    _query = '';
    _clearSearchState();
    notifyListeners();
  }

  void loadMoreResults() {
    if (!hasMoreResults) {
      return;
    }

    _visibleCount = (_visibleCount + _pageSize).clamp(0, _results.length);
    notifyListeners();
  }

  bool isFavorite(String word) {
    return _favoriteWords.contains(word.toLowerCase());
  }

  Future<void> toggleFavorite(Word word) async {
    final normalized = word.english.toLowerCase();
    if (_favoriteWords.contains(normalized)) {
      _favoriteWords.remove(normalized);
    } else {
      _favoriteWords.add(normalized);
    }

    await _preferences?.setStringList(
      _favoritesKey,
      _favoriteWords.toList()..sort(),
    );
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _searchHistory = const [];
    await _preferences?.remove(_historyKey);
    notifyListeners();
  }

  Future<void> _saveSearchHistory(String value) async {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      return;
    }

    final updatedHistory = [
      normalizedValue,
      ..._searchHistory.where(
        (entry) => entry.toLowerCase() != normalizedValue.toLowerCase(),
      ),
    ].take(_historyLimit).toList(growable: false);

    _searchHistory = updatedHistory;
    await _preferences?.setStringList(_historyKey, updatedHistory);
  }

  Future<void> _performSearch(
    String value, {
    required bool clearSuggestions,
  }) async {
    final trimmedValue = value.trim();
    _debounce?.cancel();
    _query = value;

    if (trimmedValue.isEmpty) {
      _clearSearchState();
      notifyListeners();
      return;
    }

    _autocompleteSuggestions = clearSuggestions
        ? const []
        : _searchService.getAutocompleteSuggestions(trimmedValue);
    _results = _searchService.search(trimmedValue);
    _visibleCount = _pageSize;
    await _saveSearchHistory(trimmedValue);
    notifyListeners();
  }

  void _clearSearchState() {
    _results = const [];
    _autocompleteSuggestions = const [];
    _visibleCount = _pageSize;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
