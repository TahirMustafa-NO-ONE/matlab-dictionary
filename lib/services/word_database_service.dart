import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/word_model.dart';
import 'csv_loader_service.dart';

class WordDatabaseService {
  WordDatabaseService({required CsvLoaderService csvLoaderService})
    : _csvLoaderService = csvLoaderService;

  static const _databaseName = 'dictionary.db';
  static const _databaseVersion = 1;
  static const _tableName = 'words';
  static const _maxCacheEntries = 10000;

  final CsvLoaderService _csvLoaderService;
  final LinkedHashMap<String, Word> _memoryCache =
      LinkedHashMap<String, Word>();

  Database? _database;
  bool _sqliteAvailable = true;

  Future<List<Word>> loadAll() async {
    final database = await _openDatabaseSafely();

    if (database != null) {
      try {
        final existingCount =
            Sqflite.firstIntValue(
              await database.rawQuery('SELECT COUNT(*) FROM $_tableName'),
            ) ??
            0;

        if (existingCount > 0) {
          final rows = await database.query(
            _tableName,
            orderBy: 'english COLLATE NOCASE ASC',
          );
          final words = rows.map(Word.fromJson).toList(growable: false);
          _primeMemoryCache(words);
          return words;
        }
      } catch (error) {
        debugPrint('SQLite read failed, falling back to CSV load: $error');
        _sqliteAvailable = false;
      }
    }

    final words = await _csvLoaderService.loadWords();
    final sortedWords = [...words]
      ..sort(
        (a, b) => a.english.toLowerCase().compareTo(b.english.toLowerCase()),
      );
    _primeMemoryCache(sortedWords);

    if (database != null && _sqliteAvailable) {
      await _persistWords(database, sortedWords);
    }

    return sortedWords;
  }

  Future<Word?> getWord(String key) async {
    final normalizedKey = key.trim().toLowerCase();
    if (normalizedKey.isEmpty) {
      return null;
    }

    final cached = _memoryCache.remove(normalizedKey);
    if (cached != null) {
      _memoryCache[normalizedKey] = cached;
      return cached;
    }

    final database = await _openDatabaseSafely();
    if (database == null || !_sqliteAvailable) {
      return null;
    }

    try {
      final rows = await database.query(
        _tableName,
        where: 'english_lower = ?',
        whereArgs: [normalizedKey],
        limit: 1,
      );

      if (rows.isEmpty) {
        return null;
      }

      final word = Word.fromJson(rows.first);
      await cacheWord(word);
      return word;
    } catch (error) {
      debugPrint('SQLite lookup failed: $error');
      _sqliteAvailable = false;
      return null;
    }
  }

  Future<void> cacheWord(Word word) async {
    final normalizedKey = word.english.toLowerCase();
    _touchCache(normalizedKey, word);

    final database = await _openDatabaseSafely();
    if (database == null || !_sqliteAvailable) {
      return;
    }

    try {
      await database.insert(
        _tableName,
        _wordToRow(word),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      debugPrint(
        'SQLite write failed, continuing with memory cache only: $error',
      );
      _sqliteAvailable = false;
    }
  }

  Future<Database?> _openDatabaseSafely() async {
    if (!_sqliteAvailable || kIsWeb) {
      return null;
    }

    if (_database != null) {
      return _database;
    }

    try {
      final databasesPath = await getDatabasesPath();
      final databasePath = '$databasesPath/$_databaseName';
      _database = await openDatabase(
        databasePath,
        version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              english TEXT PRIMARY KEY,
              english_lower TEXT NOT NULL,
              meanings TEXT NOT NULL
            )
          ''');
          await db.execute(
            'CREATE INDEX idx_words_english_lower ON $_tableName (english_lower)',
          );
        },
      );
      return _database;
    } catch (error) {
      debugPrint(
        'SQLite initialization failed, using in-memory data only: $error',
      );
      _sqliteAvailable = false;
      return null;
    }
  }

  Future<void> _persistWords(Database database, List<Word> words) async {
    try {
      final batch = database.batch();
      for (final word in words) {
        batch.insert(
          _tableName,
          _wordToRow(word),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (error) {
      debugPrint('Unable to cache parsed words in SQLite: $error');
      _sqliteAvailable = false;
    }
  }

  Map<String, dynamic> _wordToRow(Word word) {
    return <String, dynamic>{
      'english': word.english,
      'english_lower': word.english.toLowerCase(),
      'meanings': jsonEncode(word.meanings),
    };
  }

  void _primeMemoryCache(List<Word> words) {
    final wordsToCache = words.length <= _maxCacheEntries
        ? words
        : words.take(_maxCacheEntries);

    for (final word in wordsToCache) {
      _touchCache(word.english.toLowerCase(), word);
    }
  }

  void _touchCache(String key, Word value) {
    _memoryCache.remove(key);
    _memoryCache[key] = value;

    if (_memoryCache.length > _maxCacheEntries) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
  }
}
