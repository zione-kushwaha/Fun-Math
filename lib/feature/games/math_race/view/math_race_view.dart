import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/theme/provider/theme_provider.dart' as theme_provider;

class MathRaceView extends ConsumerWidget {
  const MathRaceView({super.key});

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
              title: const Text('Math Race Games', 
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
                          Colors.blue[900]!,
                          Colors.blue[800]!,
                        ]
                      : [
                          Color(0xFF90CAF9),
                          Color(0xFF42A5F5),
                          Colors.blue.shade500,
                        ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),                onPressed: () {
                  ref.read(theme_provider.themeProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
          
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
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
                  children: [                    _GameOptionCard(
                      icon: Icons.directions_run,
                      title: 'Math Race',
                      color: Colors.blue,
                      delay: 0,
                      onTap: () {
                        // Show difficulty selection dialog
                        _showDifficultyDialog(context, '/math/race');
                      },
                    ),
                    _GameOptionCard(
                      icon: Icons.calculate,
                      title: 'Mental Arithmetic',
                      color: Colors.green,
                      delay: 100,
                      onTap: () => context.push('/math/mental_arithmetic'),
                    ),
                    _GameOptionCard(
                      icon: Icons.square_foot,
                      title: 'Square Roots',
                      color: Colors.purple,
                      delay: 200,
                      onTap: () => context.push('/math/square_root'),
                    ),
                    _GameOptionCard(
                      icon: Icons.grid_on,
                      title: 'Math Grid',
                      color: Colors.orange,
                      delay: 300,
                      onTap: () => context.push('/math/math_grid'),
                    ),
                    _GameOptionCard(
                      icon: Icons.join_inner,
                      title: 'Math Pairs',
                      color: Colors.red,
                      delay: 400,
                      onTap: () => context.push('/math/math_pairs'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),                _BouncingButton(
                  onPressed: () {
                    final games = ['/math/race', '/math/mental_arithmetic', '/math/square_root', '/math/math_grid', '/math/math_pairs'];
                    final random = games[DateTime.now().millisecond % games.length];
                    
                    // For race game, show difficulty dialog
                    if (random == '/math/race') {
                      _showDifficultyDialog(context, random);
                    } else {
                      context.push(random);
                    }
                  },
                  child: const Text(
                    'Random Math Challenge!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                
                const SizedBox(height: 24),
                _InfoCard(
                  title: 'Test Your Math Skills!',
                  content: 'These games are designed to improve your mental calculation speed, arithmetic skills, and logical thinking abilities.',
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
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

class _GameOptionCardState extends State<_GameOptionCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
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
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: widget.color,
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

class _BouncingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  
  const _BouncingButton({required this.onPressed, required this.child});
  
  @override
  State<_BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<_BouncingButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    _controller.repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: widget.child,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  
  const _InfoCard({required this.title, required this.content, required this.icon});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
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
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
