import 'package:flutter/material.dart';
import 'package:fun_math/core/shared/surprise_me.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shared/game_option_card.dart';

class MemoryMatchView extends ConsumerWidget {
  const MemoryMatchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

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
                      onTap: () => context.push(
                        '/memory/number_match?difficulty=medium',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.calculate,
                      title: 'Equation Match',
                      subtitle: 'Match equations with answers',
                      color: Colors.indigo,
                      delay: 100,
                      onTap: () => context.push(
                        '/memory/equation_match?difficulty=medium',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.emoji_objects,
                      title: 'Visual Memory',
                      subtitle: 'Remember visual patterns',
                      color: Colors.teal,
                      delay: 200,
                      onTap: () => context.push(
                        '/memory/visual_memory?difficulty=medium',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.timer,
                      title: 'Speed Memory',
                      subtitle: 'Test your memory speed',
                      color: Colors.amber,
                      delay: 300,
                      onTap: () => context.push(
                        '/memory/speed_memory?difficulty=medium',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.swap_calls,
                      title: 'Sequence Match',
                      subtitle: 'Remember sequences',
                      color: Colors.pink,
                      delay: 400,
                      onTap: () => context.push(
                        '/memory/sequence_match?difficulty=medium',
                      ),
                    ),
                    GameOptionCard(
                      icon: Icons.pattern_rounded,
                      title: 'Pattern Memory',
                      subtitle: 'Memory pattern challenge',
                      color: Colors.green,
                      delay: 500,
                      onTap: () => context.push(
                        '/memory/pattern_memory?difficulty=medium',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SurpriseMeButton(
                  onPressed: () {
                    final games = [
                      '/memory/number_match?difficulty=medium',
                      '/memory/equation_match?difficulty=medium',
                      '/memory/visual_memory?difficulty=medium',
                      '/memory/speed_memory?difficulty=medium',
                      '/memory/sequence_match?difficulty=medium',
                      '/memory/pattern_memory?difficulty=medium',
                    ];
                    final random =
                        games[DateTime.now().millisecond % games.length];
                    context.push(random);
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
