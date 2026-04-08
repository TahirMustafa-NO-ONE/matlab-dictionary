import 'package:flutter/material.dart';

import '../models/word_model.dart';
import '../services/word_database_service.dart';

enum LoadingState { idle, loading, loaded, error }

class WordProvider extends ChangeNotifier {
  WordProvider({required WordDatabaseService wordDatabaseService})
    : _wordDatabaseService = wordDatabaseService;

  final WordDatabaseService _wordDatabaseService;

  LoadingState _loadingState = LoadingState.idle;
  List<Word> _words = const [];
  String? _errorMessage;

  LoadingState get loadingState => _loadingState;
  List<Word> get words => _words;
  String? get errorMessage => _errorMessage;
  bool get isLoaded => _loadingState == LoadingState.loaded;

  Future<void> initialize() async {
    if (_loadingState == LoadingState.loading || isLoaded) {
      return;
    }

    _loadingState = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _words = await _wordDatabaseService.loadAll();
      _loadingState = LoadingState.loaded;
    } catch (error) {
      _loadingState = LoadingState.error;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }
}
