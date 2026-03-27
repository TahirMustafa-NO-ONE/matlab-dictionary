import 'dart:math' as math;

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
    const deepBlue = Color(0xFF123E6D);
    const royalBlue = Color(0xFF1C5792);
    const skyBlue = Color(0xFF5C9DE0);
    const gold = Color(0xFFFFC928);
    const amber = Color(0xFFFFA91A);
    final isWide = MediaQuery.of(context).size.width >= 860;

    return Scaffold(
      body: Stack(
        children: [
          const _GradientBackdrop(),
          Positioned(
            top: -70,
            right: -40,
            child: _GlowOrb(
              size: 220,
              colors: [
                gold.withValues(alpha: 0.32),
                amber.withValues(alpha: 0.0),
              ],
            ),
          ),
          Positioned(
            bottom: -90,
            left: -70,
            child: _GlowOrb(
              size: 250,
              colors: [
                skyBlue.withValues(alpha: 0.22),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                  child: Column(
                    children: [
                      _TopBar(navy: navy, royalBlue: royalBlue, gold: gold),
                      const SizedBox(height: 24),
                      isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 11,
                                  child: _SearchPanel(
                                    navy: navy,
                                    deepBlue: deepBlue,
                                    royalBlue: royalBlue,
                                    skyBlue: skyBlue,
                                    gold: gold,
                                    amber: amber,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 8,
                                  child: _PreviewPanel(
                                    navy: navy,
                                    deepBlue: deepBlue,
                                    skyBlue: skyBlue,
                                    gold: gold,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _SearchPanel(
                                  navy: navy,
                                  deepBlue: deepBlue,
                                  royalBlue: royalBlue,
                                  skyBlue: skyBlue,
                                  gold: gold,
                                  amber: amber,
                                ),
                                const SizedBox(height: 18),
                                _PreviewPanel(
                                  navy: navy,
                                  deepBlue: deepBlue,
                                  skyBlue: skyBlue,
                                  gold: gold,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.navy,
    required this.royalBlue,
    required this.gold,
  });

  final Color navy;
  final Color royalBlue;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [gold.withValues(alpha: 0.95), const Color(0xFFFFAF1E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(9),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: navy,
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset('assets/logo.png'),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MATLAB Dictionary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Search terms, symbols, and concepts with a cleaner input-first layout',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF58708E),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: royalBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune_rounded, size: 18, color: royalBlue),
                const SizedBox(width: 8),
                Text(
                  'UI Draft',
                  style: TextStyle(
                    color: royalBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({
    required this.navy,
    required this.deepBlue,
    required this.royalBlue,
    required this.skyBlue,
    required this.gold,
    required this.amber,
  });

  final Color navy;
  final Color deepBlue;
  final Color royalBlue;
  final Color skyBlue;
  final Color gold;
  final Color amber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.96),
            const Color(0xFFF6F9FF),
            const Color(0xFFFFF7E8),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.1),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                colors: [
                  gold.withValues(alpha: 0.18),
                  amber.withValues(alpha: 0.12),
                ],
              ),
            ),
            child: const Text(
              'Search Input Design',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF8A5E00),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Find a MATLAB word fast with a screen built around the input field.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'This version focuses on the look and spacing only, with a bold search card, suggestion chips, and a calm preview area for the result state.',
            style: TextStyle(
              color: navy.withValues(alpha: 0.76),
              fontSize: 15,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 28),
          _SearchInputCard(
            navy: navy,
            deepBlue: deepBlue,
            royalBlue: royalBlue,
            skyBlue: skyBlue,
            gold: gold,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _QuickChip(label: 'matrix'),
              _QuickChip(label: 'eigenvalue'),
              _QuickChip(label: 'plot'),
              _QuickChip(label: 'function handle'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _MiniInfoCard(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Clean first impression',
                  subtitle: 'The input area is now the clear visual anchor.',
                  accent: royalBlue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _MiniInfoCard(
                  icon: Icons.layers_rounded,
                  title: 'Room for results',
                  subtitle:
                      'Plenty of space stays available below for definitions.',
                  accent: gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchInputCard extends StatelessWidget {
  const _SearchInputCard({
    required this.navy,
    required this.deepBlue,
    required this.royalBlue,
    required this.skyBlue,
    required this.gold,
  });

  final Color navy;
  final Color deepBlue;
  final Color royalBlue;
  final Color skyBlue;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [deepBlue, royalBlue, skyBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: royalBlue.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Dictionary Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.search_rounded, color: gold),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: navy.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a MATLAB term like "workspace" or "subplot"',
                hintStyle: TextStyle(
                  color: navy.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.menu_book_rounded, color: deepBlue),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    widthFactor: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [gold, const Color(0xFFFFB019)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          color: Color(0xFF0D2D52),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 22,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Recent ideas',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.84),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _RecentSearchPill(label: 'matrix multiplication'),
              _RecentSearchPill(label: 'cell array'),
              _RecentSearchPill(label: 'anonymous function'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.navy,
    required this.deepBlue,
    required this.skyBlue,
    required this.gold,
  });

  final Color navy;
  final Color deepBlue;
  final Color skyBlue;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [deepBlue, skyBlue],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: _GlowOrb(
                    size: 120,
                    colors: [gold.withValues(alpha: 0.3), Colors.transparent],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Result Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Workspace',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The placeholder result card gives the screen a finished feel even before search logic is connected.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _PreviewRow(
            icon: Icons.lightbulb_rounded,
            title: 'Input emphasis',
            subtitle: 'Large rounded field with a built-in action button.',
            accent: gold,
            navy: navy,
          ),
          const SizedBox(height: 14),
          _PreviewRow(
            icon: Icons.view_compact_rounded,
            title: 'Balanced composition',
            subtitle:
                'The right panel can later hold meaning, examples, or Urdu translation.',
            accent: deepBlue,
            navy: navy,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gold.withValues(alpha: 0.16), const Color(0xFFFFF7E8)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              'This is intentionally UI-only: the search field is present, the button is styled, and the result area is visual placeholder content for now.',
              style: TextStyle(
                color: navy.withValues(alpha: 0.82),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF23496E),
        ),
      ),
    );
  }
}

class _RecentSearchPill extends StatelessWidget {
  const _RecentSearchPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.95),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  const _MiniInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: const Color(0xFF0D2D52).withValues(alpha: 0.72),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.navy,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Color navy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: accent.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: navy.withValues(alpha: 0.72),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBackdrop extends StatelessWidget {
  const _GradientBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF9FBFF), Color(0xFFEDF4FF), Color(0xFFFFF6E1)],
        ),
      ),
      child: CustomPaint(painter: _BackdropPainter(), size: Size.infinite),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x261C5792)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.12 + i * 0.15);
      final path = Path()..moveTo(-40, y);

      for (double x = -40; x <= size.width + 40; x += 20) {
        path.lineTo(
          x,
          y + math.sin((x / size.width) * math.pi * 2 + i * 0.75) * 7,
        );
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
