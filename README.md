# MATLAB Dictionary

A Flutter-based offline English-to-Urdu dictionary application. The app loads a bundled CSV dataset, builds local search indexes, and provides fast on-device lookup with recent-search history and saved words.

## Overview

This project is a cross-platform Flutter app targeting Android, iOS, web, Windows, macOS, and Linux from a single codebase.

Core capabilities:

- Offline English-to-Urdu dictionary lookup
- Prefix-based autocomplete suggestions
- Fuzzy search fallback for misspelled queries
- Persistent recent-search history
- Persistent saved/favorite words
- Local asset-backed dataset with optional SQLite caching on supported platforms

The current dictionary source is [`assets/eng_to_urdu.csv`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/assets/eng_to_urdu.csv), which contains roughly 100k lines of source data.

## Tech Stack

- Flutter
- Dart `^3.11.1`
- `provider` for dependency injection and state management
- `shared_preferences` for user persistence
- `sqflite` for local database caching on non-web supported platforms
- `csv` for dataset parsing

## Project Structure

```text
lib/
  main.dart                       App entrypoint and dependency wiring
  models/
    word_model.dart               Dictionary domain model
  providers/
    word_provider.dart            Dictionary loading state
    search_provider.dart          Search state, history, favorites, pagination
  screens/
    search_screen.dart            Main search experience
    saved_words_screen.dart       Favorite/saved words view
  services/
    csv_loader_service.dart       CSV asset loading and parsing
    word_database_service.dart    SQLite + memory caching for dictionary data
    search_service.dart           Binary search, trie autocomplete, fuzzy search
  widgets/
    search_bar_widget.dart        Search input widget
    search_history.dart           Recent searches UI
    result_card.dart              Dictionary result UI

assets/
  eng_to_urdu.csv                 Bundled dictionary source
  logo.png                        App icon / splash asset
```

## Architecture

The app follows a lightweight layered structure:

1. Presentation layer
   Implemented with Flutter screens and widgets.
2. State layer
   Managed with `ChangeNotifier` providers.
3. Service layer
   Handles CSV parsing, search indexing, and local persistence.
4. Data model layer
   Encapsulates dictionary entries with the `Word` model.

### Dependency Graph

[`lib/main.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/lib/main.dart) registers dependencies using `MultiProvider`:

- `CsvLoaderService`
- `WordDatabaseService`
- `SearchService`
- `WordProvider`
- `SearchProvider`

`SearchScreen` initializes the app in two stages:

1. Load dictionary words through `WordProvider`
2. Initialize search indexes and persisted user state through `SearchProvider`

## Data Model

[`lib/models/word_model.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/lib/models/word_model.dart)

Each dictionary entry is represented as:

- `english`: source word
- `meanings`: one or more Urdu meanings

Parsing behavior:

- The first CSV column is treated as the English word
- Remaining non-empty columns are treated as meanings
- Malformed rows are skipped during parsing
- A meaning prefixed with `Pronunciation:` is surfaced separately in the UI

## Search Implementation

[`lib/services/search_service.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/lib/services/search_service.dart)

Search uses a hybrid strategy:

- Exact lookup via binary search on a sorted word list
- Prefix autocomplete via an in-memory trie
- Fuzzy matching fallback using Levenshtein-distance similarity scoring
- LRU-style in-memory result caching for repeated searches

Search behavior details:

- Empty input clears search state
- Typing updates suggestions immediately
- Live search is debounced by 300 ms in `SearchProvider`
- Submitted searches are persisted to recent history
- Fuzzy results are limited to the top 20 matches
- Visible results are paginated in batches of 50

## Persistence Strategy

### 1. Dictionary Data

[`lib/services/word_database_service.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/lib/services/word_database_service.dart)

Dictionary loading flow:

1. Try opening local SQLite storage
2. If cached rows already exist, read from SQLite
3. Otherwise load and parse the CSV asset
4. Sort entries alphabetically
5. Prime an in-memory LRU-style cache
6. Persist the parsed words into SQLite when available

Important behavior:

- SQLite is disabled automatically on web
- If SQLite initialization fails, the app falls back to in-memory operation
- Meanings are stored in SQLite as JSON-encoded arrays
- The in-memory cache keeps up to 10,000 entries

### 2. User State

[`lib/providers/search_provider.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/lib/providers/search_provider.dart)

Persisted with `SharedPreferences`:

- Search history under `search_history`
- Favorites under `favorite_words`

Retention rules:

- Search history is capped at 20 items
- Favorites are stored as lowercased English-word keys

## User Experience

### Main Search Screen

[`lib/screens/search_screen.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/lib/screens/search_screen.dart)

Features:

- App-branded header
- Search field with clear action
- Suggestion dropdown while typing
- Loading placeholders
- Empty-state and error-state messaging
- Result list with favorite toggling
- "Load more results" pagination

### Saved Words Screen

[`lib/screens/saved_words_screen.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/lib/screens/saved_words_screen.dart)

Features:

- Displays favorited dictionary entries
- Supports removing saved words from the same view
- Shows an empty state when no favorites exist

## Assets and Configuration

Defined in [`pubspec.yaml`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/pubspec.yaml):

- `assets/logo.png`
- `assets/eng_to_urdu.csv`

Also configured:

- `flutter_launcher_icons` for app icons
- `flutter_native_splash` for native/web splash screens

Current app metadata:

- App name: `MATLAB Dictionary`
- Package name on Android: `com.example.matlab`
- Version: `1.0.0+1`

## Local Development

### Prerequisites

- Flutter SDK installed and on `PATH`
- Dart SDK matching the Flutter toolchain
- Platform toolchains as needed:
  - Android Studio / Android SDK
  - Xcode for iOS/macOS
  - Visual Studio Build Tools for Windows

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

Examples:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
```

### Build Artifacts

```bash
flutter build apk
flutter build appbundle
flutter build web
flutter build windows
flutter build macos
flutter build linux
flutter build ios
```

## Development Notes

### Initialization Sequence

At startup:

1. Flutter binding is initialized
2. Providers are created
3. `SearchScreen` triggers dictionary initialization
4. Dictionary words are loaded from SQLite or CSV
5. Search indexes and local preferences are initialized
6. The UI becomes interactive

### Performance Considerations

- CSV parsing is offloaded using `compute(...)`
- Search uses sorted lookup plus trie traversal to reduce repeated full scans
- Search results are cached
- Dictionary data can be reused from SQLite on supported platforms
- Large result sets are paginated in the UI instead of rendered all at once

### Web Behavior

On web, SQLite is intentionally unavailable because `sqflite` is not used there. The app still works by loading the CSV into memory and using in-memory indexes plus `SharedPreferences`-backed user state where supported by the platform abstraction.

## Testing

Current automated test coverage is minimal.

Existing test file:

- [`test/widget_test.dart`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/test/widget_test.dart)

Current status:

- The existing widget test is still the default Flutter counter smoke test
- It does not match this application
- Running `flutter test` currently fails for that reason

Recommended next tests:

- `Word.fromCsv` parsing and malformed-row handling
- `SearchService.binarySearch`
- Trie autocomplete behavior
- Fuzzy search threshold behavior
- `SearchProvider` history and favorites persistence
- Widget tests for search, results, and saved words

## Known Issues and Maintenance Notes

- The bundled CSV includes malformed rows; these are skipped during parsing by design
- The Android application ID is still the default example namespace: `com.example.matlab`
- The release Android build is currently configured to sign with the debug signing config
- The project description in [`pubspec.yaml`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/pubspec.yaml) is still generic and can be updated
- The dependency `fuzzywuzzy` is declared but the current implementation uses an in-house Levenshtein-based similarity function instead

## Troubleshooting

### App shows "Dictionary unavailable"

Possible causes:

- Missing or misnamed CSV asset
- Asset not included correctly in `pubspec.yaml`
- CSV parsing failure due to severe file corruption

Check:

- [`assets/eng_to_urdu.csv`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/assets/eng_to_urdu.csv)
- [`pubspec.yaml`](/c:/idgaf/flutteprojects/matlab dictionary app/matlab/pubspec.yaml)

### Tests fail on desktop/CI with SQLite errors

During tests, `sqflite` may not initialize in a desktop/unit-test environment. The app already falls back to in-memory mode, but tests should be updated to use mocks/fakes or a proper database factory when SQLite behavior is under test.

### Search feels slow on first launch

The first launch may take longer because the app needs to:

- Load the full CSV asset
- Parse entries in the background
- Build search indexes
- Optionally populate SQLite cache

Subsequent launches on supported platforms can be faster when SQLite cache is available.

## Suggested Improvements

- Replace the placeholder widget test suite
- Change Android/iOS bundle identifiers to production values
- Add repository screenshots or demo GIFs
- Add CI for formatting, analysis, and tests
- Remove unused dependencies
- Add import-time validation or CSV pre-processing
- Consider stronger search ranking logic for fuzzy matches

## Useful Commands

```bash
flutter analyze
flutter test
flutter pub get
flutter pub outdated
dart format lib test
```

## License

No license file is currently included in this repository. Add one if the project is intended for public distribution or collaboration.
