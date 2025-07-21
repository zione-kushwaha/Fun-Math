import 'package:flutter/material.dart';
import 'package:fun_math/core/shared/surprise_me.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/theme/provider/theme_provider.dart'
    as theme_provider;

import '../../../../core/shared/game_option_card.dart';

class MemoryMatchView extends ConsumerWidget {
  const MemoryMatchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'Memory Match Games',
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
                _AnimatedTitle(text: 'Train Your Memory!'),

                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: size.height * 0.25,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  children: [
                    GameOptionCard(
                      icon: Icons.grid_on,
                      title: 'Number Match',
                      subtitle: 'Match numbers correctly',
                      color: Colors.purple,
                      delay: 0,
                      onTap: () => _showDifficultyDialog(
                        context,
                        '/memory/number_match',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.calculate,
                      title: 'Equation Match',
                      subtitle: 'Match equations with answers',
                      color: Colors.indigo,
                      delay: 100,
                      onTap: () => _showDifficultyDialog(
                        context,
                        '/memory/equation_match',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.emoji_objects,
                      title: 'Visual Memory',
                      subtitle: 'Remember visual patterns',
                      color: Colors.teal,
                      delay: 200,
                      onTap: () => _showDifficultyDialog(
                        context,
                        '/memory/visual_memory',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.timer,
                      title: 'Speed Memory',
                      subtitle: 'Test your memory speed',
                      color: Colors.amber,
                      delay: 300,
                      onTap: () => _showDifficultyDialog(
                        context,
                        '/memory/speed_memory',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.swap_calls,
                      title: 'Sequence Match',
                      subtitle: 'Remember sequences',
                      color: Colors.pink,
                      delay: 400,
                      onTap: () => _showDifficultyDialog(
                        context,
                        '/memory/sequence_match',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.pattern_rounded,
                      title: 'Pattern Memory',
                      subtitle: 'Memory pattern challenge',
                      color: Colors.green,
                      delay: 500,
                      onTap: () => _showDifficultyDialog(
                        context,
                        '/memory/pattern_memory',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SurpriseMeButton(
                  onPressed: () {
                    final games = [
                      '/memory/number_match',
                      '/memory/equation_match',
                      '/memory/visual_memory',
                      '/memory/speed_memory',
                      '/memory/sequence_match',
                      '/memory/pattern_memory',
                    ];
                    final random =
                        games[DateTime.now().millisecond % games.length];
                    _showDifficultyDialog(context, random);
                  },
                ),

                const SizedBox(height: 24),
                _InfoCard(
                  title: 'Enhance Your Memory Skills!',
                  content:
                      'These games are designed to improve your memory, pattern recognition, and concentration while making math fun.',
                  icon: Icons.psychology,
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Show difficulty selection dialog
  void _showDifficultyDialog(BuildContext context, String routePath) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Difficulty'),
          backgroundColor: isDark ? Colors.grey[850] : Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DifficultyButton(
                text: 'Easy',
                color: Colors.green,
                onPressed: () {
                  Navigator.pop(context);
                  context.push('$routePath?difficulty=easy');
                },
              ),
              const SizedBox(height: 12),
              _DifficultyButton(
                text: 'Medium',
                color: Colors.orange,
                onPressed: () {
                  Navigator.pop(context);
                  context.push('$routePath?difficulty=medium');
                },
              ),
              const SizedBox(height: 12),
              _DifficultyButton(
                text: 'Hard',
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                  context.push('$routePath?difficulty=hard');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  final String text;

  const _AnimatedTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _GameOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final int delay;
  final VoidCallback onTap;

  const _GameOptionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_GameOptionCard> createState() => _GameOptionCardState();
}

class _GameOptionCardState extends State<_GameOptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[800] : Colors.white;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, size: 40, color: widget.color),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget.color.withOpacity(0.1),
                ),
                child: Text(
                  'Play Now',
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.secondary),
              const SizedBox(width: 2),
              FittedBox(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _DifficultyButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          shadowColor: color.withOpacity(0.6),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
