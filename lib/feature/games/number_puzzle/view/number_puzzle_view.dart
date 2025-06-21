import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class NumberPuzzleViewScreen extends StatelessWidget {
  const NumberPuzzleViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Number Puzzle Fun!', 
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
                          theme.primaryColor.withOpacity(0.7),
                          Colors.deepPurple.shade400,
                        ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Iconsax.game,
                    size: 60,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.color_lens),
                tooltip: 'Change theme',
                onPressed: () {
                  // TODO: Implement theme changer
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _AnimatedTitle(text: 'Let\'s Play With Numbers!'),
                const SizedBox(height: 24),
                Text(
                  'Choose a math game to play:',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Game grid with staggered animations
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: size.width > 600 ? 3 : 2, 
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _GameOptionCard(
                      icon: Iconsax.calculator,
                      title: 'Calculator',
                      subtitle: 'Solve math problems',
                      color: Colors.blue,
                      delay: 0,
                      onTap: () => context.push('/calculator'),
                    ),
                    _GameOptionCard(
                      icon: Icons.check_circle,
                      title: 'Correct Answer',
                      subtitle: 'Find the right solution',
                      color: Colors.green,
                      delay: 100,
                      onTap: () => context.push('/correct_answer'),
                    ),
                    _GameOptionCard(
                      icon: Icons.question_mark,
                      title: 'Guess Sign',
                      subtitle: 'What\'s the operator?',
                      color: Colors.orange,
                      delay: 200,
                      onTap: () => context.push('/guess_sign'),
                    ),
                    _GameOptionCard(
                      icon: Icons.timer,
                      title: 'Quick Calculation',
                      subtitle: 'Beat the clock!',
                      color: Colors.purple,
                      delay: 300,
                      onTap: () => context.push('/quick_calculation'),
                    ),
                    _GameOptionCard(
                      icon: Icons.extension,
                      title: 'Puzzle Game',
                      subtitle: 'Solve the number puzzle',
                      color: Colors.teal,
                      delay: 400,
                      onTap: () => context.push('/puzzle_game'),
                    ),
                    _GameOptionCard(
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
                _SurpriseMeButton(
                  onPressed: () {
                    _showRandomGameDialog(context);
                  },
                ),
                
                // Fun math facts footer
                const SizedBox(height: 32),
                _MathFunFact(
                  fact: "Did you know? The number 9 is magic! "
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
      {'name': 'Correct Answer', 'route': '/correct_answer', 'color': Colors.green},
      {'name': 'Guess Sign', 'route': '/guess_sign', 'color': Colors.orange},
      {'name': 'Quick Calculation', 'route': '/quick_calculation', 'color': Colors.purple},
      {'name': 'Puzzle Game', 'route': '/puzzle_game', 'color': Colors.teal},
      {'name': 'Math Memory', 'route': '/math_memory', 'color': Colors.pink},
    ];
    
    final randomGame = games[(DateTime.now().millisecondsSinceEpoch % games.length).toInt()];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
        title: Text("Let's play...", 
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.game,
              size: 60,
              color: randomGame['color'] as Color,
            ),
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
    
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    
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
                    offset: const Offset(2, 2),)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GameOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final int delay;

  const _GameOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  __GameOptionCardState createState() => __GameOptionCardState();
}

class __GameOptionCardState extends State<_GameOptionCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;
  
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
    
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
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
    
    return SlideTransition(
      position: _offset,
      child: ScaleTransition(
        scale: _scale,
        child: FadeTransition(
          opacity: _opacity,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark 
                    ? theme.colorScheme.surface 
                    : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(_isHovering ? 0.4 : 0.2),
                      blurRadius: _isHovering ? 16 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: widget.color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
               
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(_isHovering ? 0.3 : 0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(_isHovering ? 0.3 : 0.2),
                              blurRadius: 8,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 32,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedOpacity(
                        opacity: _isHovering ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Tap to play!',
                            style: TextStyle(
                              color: widget.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurpriseMeButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _SurpriseMeButton({required this.onPressed});

  @override
  __SurpriseMeButtonState createState() => __SurpriseMeButtonState();
}

class __SurpriseMeButtonState extends State<_SurpriseMeButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _scale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: theme.primaryColor.withOpacity(0.5),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 24),
              SizedBox(width: 8),
              Text(
                'Surprise Me!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ),
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