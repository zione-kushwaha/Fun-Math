import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/domain/model/math_pairs.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/presentation/provider/math_pairs_providers.dart';

class MathPairsCard extends ConsumerWidget {
  final Pair pair;
  final int index;
  final Color primaryColor;
  final Color secondaryColor;

  const MathPairsCard({
    Key? key,
    required this.pair,
    required this.index,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      opacity: pair.isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: pair.isVisible 
              ? () => ref.read(mathPairsControllerProvider.notifier).selectCard(index)
              : null,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: pair.isActive
                  ? null
                  : Border.all(color: primaryColor, width: 2),
              gradient: pair.isActive
                  ? LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                pair.text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                  color: pair.isActive
                      ? Colors.white
                      : primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
