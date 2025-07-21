import 'package:flutter/material.dart';
import 'package:fun_math/core/shared/surprise_me.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/shared/game_option_card.dart';

class MathRaceView extends ConsumerWidget {
  const MathRaceView({super.key});

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
                'Math Race Games',
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
                _AnimatedTitle(text: 'Race Against Time!'),

                GridView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: size.height * 0.25,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  children: [
                    GameOptionCard(
                      icon: Icons.directions_run,
                      title: 'Math Race',
                      subtitle: 'Speed challenge',
                      color: Colors.blue,
                      delay: 0,
                      onTap: () => context.push('/math/race?difficulty=medium'),
                    ),
                    GameOptionCard(
                      icon: Icons.calculate,
                      title: 'Mental Arithmetic',
                      subtitle: 'Quick calculations',
                      color: Colors.green,
                      delay: 100,
                      onTap: () => context.push('/mental_arithmetic'),
                    ),
                    GameOptionCard(
                      icon: Icons.square_foot,
                      title: 'Square Roots',
                      subtitle: 'Root calculations',
                      color: Colors.purple,
                      delay: 200,
                      onTap: () => context.push('/square_root'),
                    ),
                    GameOptionCard(
                      icon: Icons.grid_on,
                      title: 'Math Grid',
                      subtitle: 'Grid puzzles',
                      color: Colors.orange,
                      delay: 300,
                      onTap: () => context.push('/math_grid'),
                    ),
                    GameOptionCard(
                      icon: Icons.join_inner,
                      title: 'Math Pairs',
                      subtitle: 'Matching pairs',
                      color: Colors.red,
                      delay: 400,
                      onTap: () => context.push('/math_pairs'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SurpriseMeButton(
                  onPressed: () {
                    final games = [
                      '/math/race?difficulty=medium',
                      '/mental_arithmetic',
                      '/square_root',
                      '/math_grid',
                      '/math_pairs',
                    ];
                    final random =
                        games[DateTime.now().millisecond % games.length];
                    context.push(random);
                  },
                ),

                const SizedBox(height: 24),
                _InfoCard(
                  title: 'Test Your Math Skills!',
                  content:
                      'These games are designed to improve your mental calculation speed, arithmetic skills, and logical thinking abilities.',
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: .7),
            Theme.of(context).colorScheme.primary.withValues(alpha: .3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: .9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
