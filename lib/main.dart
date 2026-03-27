import 'package:flutter/material.dart';

void main() {
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

    return MaterialApp(
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0D2D52);
    const royalBlue = Color(0xFF1C5792);
    const skyBlue = Color(0xFF5C9DE0);
    const gold = Color(0xFFFFC928);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9FBFF), Color(0xFFF1F6FF), Color(0xFFFFF8E9)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 82,
                      width: 82,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [gold, const Color(0xFFFFAF1E)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gold.withValues(alpha: 0.35),
                            blurRadius: 22,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: navy,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'MATLAB Dictionary',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Search any MATLAB term',
                      style: TextStyle(
                        color: navy.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withValues(alpha: 0.08),
                            blurRadius: 28,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter word',
                              hintStyle: TextStyle(
                                color: navy.withValues(alpha: 0.45),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: royalBlue,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F8FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: royalBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Search',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: skyBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Result will appear here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: navy.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
