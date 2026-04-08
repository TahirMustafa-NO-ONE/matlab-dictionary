import 'dart:convert';

class Word {
  const Word({required this.english, required this.meanings});

  final String english;
  final List<String> meanings;

  factory Word.fromCsv(List<dynamic> row) {
    if (row.isEmpty) {
      throw const FormatException('CSV row is empty.');
    }

    final english = row.first.toString().trim();
    if (english.isEmpty) {
      throw const FormatException('CSV row does not contain a valid word.');
    }

    final meanings = row
        .skip(1)
        .map((value) => value.toString().trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);

    if (meanings.isEmpty) {
      throw FormatException('Word "$english" does not contain any meanings.');
    }

    return Word(english: english, meanings: meanings);
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    final rawMeanings = json['meanings'];

    List<String> meanings;
    if (rawMeanings is String) {
      final decoded = jsonDecode(rawMeanings);
      meanings = List<String>.from(decoded as List);
    } else {
      meanings = List<String>.from(rawMeanings as List<dynamic>);
    }

    return Word(
      english: (json['english'] as String? ?? '').trim(),
      meanings: meanings
          .map((meaning) => meaning.trim())
          .where((meaning) => meaning.isNotEmpty)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'english': english, 'meanings': meanings};
  }
}
