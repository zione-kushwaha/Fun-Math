import 'package:flutter/material.dart';

Widget buildFooter(BuildContext context, bool isDarkMode) {
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