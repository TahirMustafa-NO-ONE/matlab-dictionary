import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/word_model.dart';

class CsvLoaderService {
  const CsvLoaderService({this.assetPath = 'assets/eng_to_urdu.csv'});

  final String assetPath;

  Future<List<Word>> loadWords() async {
    final csvString = await _loadCsvString();
    return compute(_parseWordsInBackground, csvString);
  }

  Future<String> _loadCsvString() async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      return utf8.decode(bytes, allowMalformed: true);
    } on FlutterError catch (_) {
      throw Exception('Dictionary data file was not found at $assetPath.');
    } catch (error) {
      throw Exception('Unable to read dictionary data: $error');
    }
  }
}

List<Word> _parseWordsInBackground(String csvString) {
  final converter = const CsvToListConverter(
    shouldParseNumbers: false,
    eol: '\n',
  );

  final rows = converter.convert(csvString);
  final words = <Word>[];

  for (final row in rows) {
    try {
      words.add(Word.fromCsv(row));
    } catch (error) {
      debugPrint('Skipping malformed CSV row: $error');
    }
  }

  return words;
}
