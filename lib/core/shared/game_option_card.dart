
import 'package:flutter/material.dart';


class GameOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final int delay;
  final VoidCallback onTap;

  const GameOptionCard({
    super.key, 
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  State<GameOptionCard> createState() => _GameOptionCardState();
}


class _GameOptionCardState extends State<GameOptionCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovering = false;
  
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
    
    return ScaleTransition(
      scale: _scaleAnimation,
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
                  color: widget.color.withValues(alpha:_isHovering ? 0.4 : 0.2),
                  blurRadius: _isHovering ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: widget.color.withValues(alpha: .3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha:_isHovering ? 0.3 : 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha:_isHovering ? 0.3 : 0.2),
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
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    FittedBox(
                      child: Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // AnimatedOpacity(
                  //   opacity: _isHovering ? 1.0 : 0.0,
                  //   duration: const Duration(milliseconds: 200),
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 8, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color: widget.color.withOpacity(0.2),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Text(
                  //       'Tap to play!',
                  //       style: TextStyle(
                  //         color: widget.color,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BouncingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  
  const BouncingButton({super.key, required this.onPressed, required this.child});
  
  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
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
