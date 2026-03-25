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
    const cream = Color(0xFFF8F3E8);

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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: navy,
          centerTitle: false,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _floatingController;
  late final AnimationController _introController;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<Offset> _heroSlideAnimation;
  late final Animation<double> _heroFadeAnimation;
  late final Animation<double> _chipFadeAnimation;
  late final Animation<Offset> _cardsSlideAnimation;
  late final Animation<double> _cardsFadeAnimation;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _floatAnimation = Tween<double>(begin: -10, end: 12).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _heroSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.1, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _heroFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );

    _chipFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );

    _cardsSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _cardsFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0D2D52);
    const royalBlue = Color(0xFF1C5792);
    const deepBlue = Color(0xFF123E6D);
    const skyBlue = Color(0xFF5C9DE0);
    const gold = Color(0xFFFFC928);
    const amber = Color(0xFFFFA91A);
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      body: Stack(
        children: [
          const _GradientBackdrop(),
          Positioned(
            top: -80,
            right: -50,
            child: _GlowOrb(
              size: 220,
              colors: [
                gold.withValues(alpha: 0.32),
                amber.withValues(alpha: 0),
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: -90,
            child: _GlowOrb(
              size: 260,
              colors: [
                skyBlue.withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0),
              ],
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                    child: Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withValues(alpha: 0.82),
                            boxShadow: [
                              BoxShadow(
                                color: navy.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset('assets/logo.png'),
                        ),
                        const SizedBox(width: 12),
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
                              SizedBox(height: 2),
                              Text(
                                'A brighter way to learn technical terms',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF4E6B8A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.auto_awesome_rounded),
                            color: royalBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 11,
                                child: _buildHeroSection(
                                  context,
                                  navy: navy,
                                  deepBlue: deepBlue,
                                  royalBlue: royalBlue,
                                  gold: gold,
                                  amber: amber,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                flex: 9,
                                child: _buildPreviewPanel(
                                  navy: navy,
                                  deepBlue: deepBlue,
                                  royalBlue: royalBlue,
                                  skyBlue: skyBlue,
                                  gold: gold,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildHeroSection(
                                context,
                                navy: navy,
                                deepBlue: deepBlue,
                                royalBlue: royalBlue,
                                gold: gold,
                                amber: amber,
                              ),
                              const SizedBox(height: 18),
                              _buildPreviewPanel(
                                navy: navy,
                                deepBlue: deepBlue,
                                royalBlue: royalBlue,
                                skyBlue: skyBlue,
                                gold: gold,
                              ),
                            ],
                          ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    child: SlideTransition(
                      position: _cardsSlideAnimation,
                      child: FadeTransition(
                        opacity: _cardsFadeAnimation,
                        child: Column(
                          children: [
                            _FeatureCard(
                              title: 'Smarter Discovery',
                              subtitle:
                                  'Scan terms, symbols, and concepts in a colorful layout designed to keep technical reading approachable.',
                              icon: Icons.menu_book_rounded,
                              accentColor: royalBlue,
                              secondaryColor: skyBlue,
                            ),
                            const SizedBox(height: 14),
                            _FeatureCard(
                              title: 'Quick Revision',
                              subtitle:
                                  'Important ideas stand out with warm highlights and soft contrast so the content feels easier to revisit.',
                              icon: Icons.bolt_rounded,
                              accentColor: amber,
                              secondaryColor: gold,
                            ),
                            const SizedBox(height: 14),
                            _FeatureCard(
                              title: 'Clean Focus',
                              subtitle:
                                  'Layered cards, rounded surfaces, and subtle motion give the app a modern identity without overwhelming the dictionary itself.',
                              icon: Icons.stars_rounded,
                              accentColor: deepBlue,
                              secondaryColor: royalBlue,
                            ),
                            const SizedBox(height: 22),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.74),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 46,
                                    width: 46,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [gold, amber],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.palette_rounded,
                                      color: navy,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      'The screen now follows your logo palette: deep MATLAB blue, bright gold, soft sky highlights, and smooth entrance motion.',
                                      style: TextStyle(
                                        color: navy.withValues(alpha: 0.88),
                                        height: 1.45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context, {
    required Color navy,
    required Color deepBlue,
    required Color royalBlue,
    required Color gold,
    required Color amber,
  }) {
    return FadeTransition(
      opacity: _heroFadeAnimation,
      child: SlideTransition(
        position: _heroSlideAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.96),
                const Color(0xFFF4F8FF),
                const Color(0xFFFFF7E5),
              ],
            ),
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
              FadeTransition(
                opacity: _chipFadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
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
                    'Colorful. Focused. Modern.',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8D5C00),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learn MATLAB terms in a way that feels polished and alive.',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                                letterSpacing: -0.9,
                              ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'The new design takes its energy from your logo with deep ocean blues, bright golden highlights, soft glassy surfaces, and gentle animations.',
                          style: TextStyle(
                            color: navy.withValues(alpha: 0.78),
                            fontSize: 15.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _InfoPill(
                              icon: Icons.auto_stories_rounded,
                              label: 'Dictionary-first UI',
                              color: royalBlue,
                            ),
                            _InfoPill(
                              icon: Icons.animation_rounded,
                              label: 'Animated hero',
                              color: gold,
                            ),
                            _InfoPill(
                              icon: Icons.gradient_rounded,
                              label: 'Logo palette',
                              color: deepBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _floatingController,
                      _introController,
                    ]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            gold.withValues(alpha: 0.98),
                            amber.withValues(alpha: 0.98),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gold.withValues(alpha: 0.36),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [deepBlue, navy],
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewPanel({
    required Color navy,
    required Color deepBlue,
    required Color royalBlue,
    required Color skyBlue,
    required Color gold,
  }) {
    return FadeTransition(
      opacity: _cardsFadeAnimation,
      child: SlideTransition(
        position: _cardsSlideAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [deepBlue, royalBlue, skyBlue],
            ),
            boxShadow: [
              BoxShadow(
                color: royalBlue.withValues(alpha: 0.26),
                blurRadius: 30,
                offset: const Offset(0, 14),
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
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Preview',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.menu_book_rounded,
                    color: gold.withValues(alpha: 0.98),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Algorithm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A finite sequence of precise steps used to solve a problem or compute a result.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  height: 1.5,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFD95B), gold],
                        ),
                      ),
                      child: Icon(Icons.psychology_alt_rounded, color: navy),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Examples, meanings, and concepts can sit inside elevated cards like this for a more premium look.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
          colors: [Color(0xFFF7F9FF), Color(0xFFEAF2FF), Color(0xFFFFF4DC)],
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
      ..color = const Color(0x331C5792)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var i = 0; i < 5; i++) {
      final y = size.height * (0.16 + i * 0.16);
      final path = Path();
      path.moveTo(-40, y);
      for (double x = -40; x <= size.width + 40; x += 24) {
        path.lineTo(x, y + math.sin((x / size.width) * math.pi * 2 + i) * 8);
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.secondaryColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [accentColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.circle, color: Colors.transparent),
          ),
          Transform.translate(
            offset: const Offset(-54, 0),
            child: SizedBox(
              height: 54,
              width: 54,
              child: Icon(icon, color: Colors.white),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(-42, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      height: 1.5,
                      color: const Color(0xFF0D2D52).withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
