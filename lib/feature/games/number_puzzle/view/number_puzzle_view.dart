import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/shared/game_option_card.dart';
import '../../../../core/shared/surprise_me.dart';

class NumberPuzzleViewScreen extends StatelessWidget {
  const NumberPuzzleViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,

            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'Number Puzzle Fun!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      blurRadius: 6.0,
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _AnimatedTitle(text: 'Let\'s Play With Numbers!'),
                const SizedBox(height: 14),
                Text(
                  'Choose a math game to play:',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),

                // Game grid with staggered animations
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: size.width > 600 ? 3 : 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    GameOptionCard(
                      icon: Iconsax.calculator,
                      title: 'Calculator',
                      subtitle: 'Solve math problems',
                      color: Colors.blue,
                      delay: 0,
                      onTap: () => context.push('/calculator'),
                    ),
                    GameOptionCard(
                      icon: Icons.check_circle,
                      title: 'Correct Answer',
                      subtitle: 'Find the right solution',
                      color: Colors.green,
                      delay: 100,
                      onTap: () => context.push('/correct_answer'),
                    ),
                    GameOptionCard(
                      icon: Icons.question_mark,
                      title: 'Guess Sign',
                      subtitle: 'What\'s the operator?',
                      color: Colors.orange,
                      delay: 200,
                      onTap: () => context.push('/guess_sign'),
                    ),
                    GameOptionCard(
                      icon: Icons.timer,
                      title: 'Quick Calculation',
                      subtitle: 'Beat the clock!',
                      color: Colors.purple,
                      delay: 300,
                      onTap: () => context.push('/quick_calculation'),
                    ),
                    GameOptionCard(
                      icon: Icons.extension,
                      title: 'Puzzle Game',
                      subtitle: 'Solve the number puzzle',
                      color: Colors.teal,
                      delay: 400,
                      onTap: () => context.push('/puzzles'),
                    ),
                    GameOptionCard(
                      icon: Icons.grid_view_rounded,
                      title: 'Math Memory',
                      subtitle: 'Match the pairs',
                      color: Colors.pink,
                      delay: 500,
                      onTap: () => context.push('/math_memory'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Fun animated button
                SurpriseMeButton(
                  onPressed: () {
                    _showRandomGameDialog(context);
                  },
                ),

                // Fun math facts footer
                const SizedBox(height: 32),
                _MathFunFact(
                  fact:
                      "Did you know? The number 9 is magic! "
                      "Multiply any number by 9, then add the digits of the result "
                      "until you get a single digit - it will always be 9!",
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showRandomGameDialog(BuildContext context) {
    final games = [
      {'name': 'Calculator', 'route': '/calculator', 'color': Colors.blue},
      {
        'name': 'Correct Answer',
        'route': '/correct_answer',
        'color': Colors.green,
      },
      {'name': 'Guess Sign', 'route': '/guess_sign', 'color': Colors.orange},
      {
        'name': 'Quick Calculation',
        'route': '/quick_calculation',
        'color': Colors.purple,
      },
      {'name': 'Puzzle Game', 'route': '/puzzle_game', 'color': Colors.teal},
      {'name': 'Math Memory', 'route': '/math_memory', 'color': Colors.pink},
    ];

    final randomGame =
        games[(DateTime.now().millisecondsSinceEpoch % games.length).toInt()];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Let's play...",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.game, size: 60, color: randomGame['color'] as Color),
            const SizedBox(height: 16),
            Text(
              randomGame['name'] as String,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: randomGame['color'] as Color,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Maybe later'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: randomGame['color'] as Color,
            ),
            child: const Text('Play Now!'),
            onPressed: () {
              Navigator.pop(context);
              context.push(randomGame['route'] as String);
            },
          ),
        ],
      ),
    );
  }
}

class _AnimatedTitle extends StatefulWidget {
  final String text;

  const _AnimatedTitle({required this.text});

  @override
  __AnimatedTitleState createState() => __AnimatedTitleState();
}

class __AnimatedTitleState extends State<_AnimatedTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
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

class _MathFunFact extends StatelessWidget {
  final String fact;

  const _MathFunFact({required this.fact});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              fact,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
