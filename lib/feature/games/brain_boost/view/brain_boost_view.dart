import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fun_math/core/presentation/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                          Color(0xFFFF8FA2),
                          Color(0xFFFF758F),
                          Colors.pink.shade400,
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
                    _GameOptionCard(
                      icon: Icons.change_history,
                      title: 'Magic Triangle',
                      color: Colors.purple,
                      delay: 0,
                      onTap: () => context.push('/magic_triangle'),
                    ),
                    _GameOptionCard(
                      icon: Icons.format_shapes,
                      title: 'Number Pyramid',
                      color: Colors.cyan,
                      delay: 100,
                      onTap: () => context.push('/number_pyramid'),
                    ),
                    _GameOptionCard(
                      icon: Icons.image,
                      title: 'Picture Puzzle',
                      color: Colors.orange,
                      delay: 200,
                      onTap: () => context.push('/picture_puzzle'),
                    ),
                    _GameOptionCard(
                      icon: Icons.flip,
                      title: 'Pattern Master',
                      color: Colors.green,
                      delay: 300,
                      onTap: () => context.push('/pattern_master'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _BouncingButton(
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
          opacity: value,          child: Transform.translate(
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

class _GameOptionCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.2,
                    child: Icon(
                      icon,
                      size: 130,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        size: 48,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Play Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
    );
  }
}

class _BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _BouncingButton({
    required this.child,
    required this.onPressed,
  });

  @override
  State<_BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<_BouncingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Add a repeating animation to draw attention
    Future.delayed(Duration(seconds: 1), () {
      _controller.repeat(reverse: true);
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
    
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (_, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.pink[700]!, Colors.pink[900]!]
                  : [Colors.pink[400]!, Colors.pink[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.pink[700]!.withOpacity(0.3)
                    : Colors.pink[400]!.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: widget.child,
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