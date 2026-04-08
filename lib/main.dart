import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/search_provider.dart';
import 'providers/word_provider.dart';
import 'screens/search_screen.dart';
import 'services/csv_loader_service.dart';
import 'services/search_service.dart';
import 'services/word_database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0D2D52);
    const royalBlue = Color(0xFF1C5792);
    const skyBlue = Color(0xFF5C9DE0);
    const gold = Color(0xFFFFC928);
    const cream = Color(0xFFF8F4E8);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: royalBlue,
          brightness: Brightness.light,
        ).copyWith(
          primary: royalBlue,
          secondary: gold,
          tertiary: skyBlue,
          surface: Colors.white,
        );

    return MultiProvider(
      providers: [
        Provider(create: (_) => const CsvLoaderService()),
        ProxyProvider<CsvLoaderService, WordDatabaseService>(
          update: (context, csvLoaderService, previousDatabaseService) =>
              WordDatabaseService(csvLoaderService: csvLoaderService),
        ),
        Provider(create: (_) => SearchService()),
        ChangeNotifierProxyProvider<WordDatabaseService, WordProvider>(
          create: (context) => WordProvider(
            wordDatabaseService: context.read<WordDatabaseService>(),
          ),
          update: (_, wordDatabaseService, previous) =>
              previous ??
              WordProvider(wordDatabaseService: wordDatabaseService),
        ),
        ChangeNotifierProxyProvider<SearchService, SearchProvider>(
          create: (context) =>
              SearchProvider(searchService: context.read<SearchService>()),
          update: (_, searchService, previous) =>
              previous ?? SearchProvider(searchService: searchService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MATLAB Dictionary',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: cream,
          textTheme: ThemeData.light().textTheme.apply(
            bodyColor: navy,
            displayColor: navy,
          ),
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
