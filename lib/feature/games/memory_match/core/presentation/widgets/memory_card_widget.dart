import 'package:flutter/material.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';

class MemoryCardWidget<T> extends StatelessWidget {
  final MemoryCard<T> card;
  final VoidCallback onTap;
  final Color frontColor;
  final Color backColor;
  final Widget Function(BuildContext, T) contentBuilder;
  final bool showHint;

  const MemoryCardWidget({
    Key? key,
    required this.card,
    required this.onTap,
    required this.frontColor,
    required this.backColor,
    required this.contentBuilder,
    this.showHint = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isMatched ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003) // Perspective effect
          ..rotateY(card.isFlipped ? 3.14159 : 0.0), // 180 degrees in radians
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched 
              ? frontColor
              : backColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: card.isMatched 
                ? Colors.greenAccent 
                : Colors.transparent,
            width: card.isMatched ? 2 : 0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: card.isFlipped || card.isMatched 
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(3.14159), // Flip content back so it's not mirrored
                  child: Center(
                    child: contentBuilder(context, card.value),
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.question_mark,
                    size: 36,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
        ),
      ),
    );
  }
}
