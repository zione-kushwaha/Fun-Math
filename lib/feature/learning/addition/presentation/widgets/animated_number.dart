import 'package:flutter/material.dart';

class AnimatedNumber extends StatelessWidget {
  final int value;
  final TextStyle? style;
  
  const AnimatedNumber({
    Key? key,
    required this.value,
    this.style,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: style ?? textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.amber : Colors.orange,
          ),
        );
      },
    );
  }
}
