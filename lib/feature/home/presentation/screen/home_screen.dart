import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/home/presentation/widgets/difficulty_selector.dart';
import 'package:fun_math/core/theme/provider/theme_provider.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/game_card.dart';
import '../widgets/learning_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final isDarkMode = themeNotifier.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          // Enhanced Normal App Bar (not Sliver)
          _buildAppBar(context, isDarkMode, themeNotifier, colorScheme),
          
          // Main Content with SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section with fun animation
                    _buildWelcomeSection(context, isDarkMode),
                    const SizedBox(height: 30),

                    // Math Character with Speech Bubble
                    _buildMathCharacter(context, isDarkMode),
                    const SizedBox(height: 30),

                    // Game Categories Section
                    _buildSectionHeader(
                      context,
                      title: 'Let\'s Play Math Games!',
                      icon: Icons.games_rounded,
                      iconColor: const Color(0xFFFF8FA2),
                    ),
                    const SizedBox(height: 16),
                    DifficultySelector(),

                    // Game Cards Grid with fun shapes
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.1, // More square for child-friendly look
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        GameCard(
                          title: 'Number Puzzle',
                          description: 'Practice basic math!',
                          icon: Iconsax.calculator,
                          color: const Color(0xFF6A5AE0),
                          route: '/number_puzzle',
                        ),
                        GameCard(
                          title: 'Brain Boost',
                          description: 'Choose the right answer!',
                            icon: Icons.memory_rounded,
                          color: const Color(0xFFFF8FA2),
                          route: '/brain_boost',
                        ),
                        GameCard(
                          title: 'Math Race',
                          description: 'Find the missing symbol!',
                            icon: Iconsax.flag,
                          color: const Color(0xFFFFD56F),
                          route: '/math_race',
                        ),
                        GameCard(
                          title: 'Memory Match',
                          description: 'Solve problems fast!',
                          icon: Icons.timer_rounded,
                          color: const Color(0xFF92E3A9),
                          route: '/memory_match',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Learning Section with fun illustrations
                    const LearningSection(),
                    const SizedBox(height: 40),

                    // Footer with animated math symbols and fun message
                    _buildFooter(context, isDarkMode),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode, ThemeProvider themeNotifier, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [
                  const Color(0xFF282356),
                  const Color(0xFF121212),
                ]
              : [
                  const Color(0xFF6A5AE0),
                  const Color(0xFF8B80FF),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'math-logo',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.onPrimary.withOpacity(0.4),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Iconsax.math,
                            color: colorScheme.onPrimary,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Fun Math',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          shadows: isDarkMode
                              ? [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  )
                                ]
                              : null,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                    
                      isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: colorScheme.onPrimary,
                      size: 28,
                    ),
                    onPressed: () => themeNotifier.toggleTheme(),
                  ),
          //  Icon(Iconsax.lamp, color: colorScheme.onPrimary, size: 28),

                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Learning math is fun!',
                style: TextStyle(
                  color: colorScheme.onPrimary.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, bool isDarkMode) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Math Explorer!',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Ready for some ',
                style: textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              TextSpan(
                text: 'fun math adventures?',
                style: textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.amber : const Color(0xFF6A5AE0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Animated container with confetti effect
        _buildAnimatedWelcomeContainer(context, isDarkMode),
      ],
    );
  }

  Widget _buildAnimatedWelcomeContainer(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  const Color(0xFF6A5AE0).withOpacity(0.3),
                  const Color(0xFFFF8FA2).withOpacity(0.2),
                ]
              : [
                  const Color(0xFF6A5AE0).withOpacity(0.1),
                  const Color(0xFFFF8FA2).withOpacity(0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF6A5AE0).withOpacity(0.5)
              : const Color(0xFF6A5AE0).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Choose a game to start your learning adventure!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          // Small animated math symbols
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: _FloatingMathSymbol(
                    symbol: '+',
                    color: const Color(0xFFFF8FA2),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 0,
                  child: _FloatingMathSymbol(
                    symbol: '×',
                    color: const Color(0xFF6A5AE0),
                    delay: 200,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: _FloatingMathSymbol(
                    symbol: '÷',
                    color: const Color(0xFF92E3A9),
                    delay: 400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMathCharacter(BuildContext context, bool isDarkMode) {
    return Stack(
      children: [
        // Speech bubble
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(left: 80, top: 20),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF282356) : const Color(0xFFE9E6FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '  I love math!\nCan we play a game?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.white : const Color(0xFF6A5AE0),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        // Math character (simple illustration)
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD56F),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFFB347),
              width: 4,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Face
              Positioned(
                top: 25,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Eyes
              Positioned(
                top: 35,
                left: 30,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 35,
                right: 30,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Smile
              Positioned(
                top: 50,
                child: Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Math symbol on body
              const Positioned(
                bottom: 20,
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    IconData? icon,
    Color? iconColor,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        if (icon != null)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor?.withValues(alpha: .2) ?? Theme.of(context).colorScheme.primary.withValues(alpha: .2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
        const SizedBox(width: 12),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Divider(
          color: isDarkMode ? Colors.white24 : Colors.black12,
          thickness: 1,
        ),
        const SizedBox(height: 16),
        Text(
          'Math is everywhere! Keep exploring!',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
        ),
        const SizedBox(height: 16),
        // Animated math symbols with more fun
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: const [
              _BouncingMathSymbol(symbol: '+', color: Color(0xFFFF8FA2)),
              _BouncingMathSymbol(symbol: '-', color: Color(0xFF6A5AE0), delay: 100),
              _BouncingMathSymbol(symbol: '×', color: Color(0xFFFFD56F), delay: 200),
              _BouncingMathSymbol(symbol: '÷', color: Color(0xFF92E3A9), delay: 300),
              _BouncingMathSymbol(symbol: '=', color: Color(0xFF8B80FF), delay: 400),
              _BouncingMathSymbol(symbol: 'π', color: Color(0xFFFFB347), delay: 500),
              _BouncingMathSymbol(symbol: '√', color: Color(0xFF6A5AE0), delay: 600),
              _BouncingMathSymbol(symbol: '∞', color: Color(0xFFFF8FA2), delay: 700),
              _BouncingMathSymbol(symbol: 'θ', color: Color(0xFF92E3A9), delay: 800),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Fun encouragement message
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF6A5AE0).withOpacity(0.2) : const Color(0xFF6A5AE0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'You\'re doing great! 👍',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.amber : const Color(0xFF6A5AE0),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}

class _FloatingMathSymbol extends StatefulWidget {
  final String symbol;
  final Color color;
  final int delay;

  const _FloatingMathSymbol({
    required this.symbol,
    required this.color,
    this.delay = 0,
  });

  @override
  State<_FloatingMathSymbol> createState() => _FloatingMathSymbolState();
}

class _FloatingMathSymbolState extends State<_FloatingMathSymbol>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, sin(_animation.value) * 5),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              widget.symbol,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BouncingMathSymbol extends StatefulWidget {
  final String symbol;
  final Color color;
  final int delay;

  const _BouncingMathSymbol({
    required this.symbol,
    required this.color,
    this.delay = 0,
  });

  @override
  State<_BouncingMathSymbol> createState() => _BouncingMathSymbolState();
}

class _BouncingMathSymbolState extends State<_BouncingMathSymbol>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -15), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: -15, end: 0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.symbol,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.color,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}