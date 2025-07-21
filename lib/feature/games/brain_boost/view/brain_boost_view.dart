import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fun_math/core/presentation/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/shared/game_option_card.dart';

class BrainBoostView extends ConsumerWidget {
  const BrainBoostView({super.key});

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
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('Brain Boost Games', 
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
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                      ? [
                          Colors.grey[900]!,
                          Colors.grey[800]!,
                        ]
                      : [
                          theme.primaryColor,
                          theme.primaryColor.withValues(alpha:0.7),
                          Colors.deepPurple.shade400,
                        ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
          
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                _AnimatedTitle(text: 'Challenge Your Brain!'),
              
                GridView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    mainAxisExtent: size.height * 0.25,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  children: [
                    GameOptionCard(
                      icon: Icons.change_history,
                      title: 'Magic Triangle',
                      subtitle: 'Number puzzles',
                      color: Colors.purple,
                      delay: 0,
                      onTap: () => context.push('/magic_triangle'),
                    ),
                    GameOptionCard(
                      icon: Icons.format_shapes,
                      title: 'Number Pyramid',
                      subtitle: 'Build pyramids',
                      color: Colors.cyan,
                      delay: 100,
                      onTap: () => context.push('/number_pyramid'),
                    ),
                    GameOptionCard(
                      icon: Icons.image,
                      title: 'Picture Puzzle',
                      subtitle: 'Visual challenges',
                      color: Colors.orange,
                      delay: 200,
                      onTap: () => context.push('/picture_puzzle'),
                    ),
                    GameOptionCard(
                      icon: Icons.flip,
                      title: 'Pattern Master',
                      subtitle: 'Pattern recognition',
                      color: Colors.green,
                      delay: 300,
                      onTap: () => context.push('/pattern_master'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                BouncingButton(
                  onPressed: () {
                    final games = ['/magic_triangle', '/number_pyramid', '/picture_puzzle', '/pattern_master'];
                    final random = games[DateTime.now().millisecond % games.length];
                    context.push(random);
                  },
                  child: const Text(
                    'Random Brain Challenge!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                
                const SizedBox(height: 24),
                _InfoCard(
                  title: 'Train Your Brain!',
                  content: 'These games are specially designed to enhance your logical thinking, pattern recognition, and problem-solving skills.',
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.pink[700],
            shadows: [
              Shadow(
                color: Colors.pink.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(2, 2),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.pink[700],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}