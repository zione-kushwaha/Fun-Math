import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/race/presentation/provider/math_race_providers.dart';

class MathProblemPanel extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const MathProblemPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mathRaceControllerProvider(difficulty));
    final controller = ref.read(mathRaceControllerProvider(difficulty).notifier);
    final problem = state.currentProblem;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (problem == null) {
      return const SizedBox.shrink();
    }
    
    return Column(
      children: [
        // Problem display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberBox(problem.firstNumber.toString(), context),
              const SizedBox(width: 12),
              Text(
                problem.operator,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              _buildNumberBox(problem.secondNumber.toString(), context),
              const SizedBox(width: 12),
              Text(
                '=',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              _buildNumberBox('?', context, highlight: true),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Answer options
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: List.generate(
            problem.options.length,
            (index) => _buildOptionButton(
              index,
              problem.options[index].toString(),
              context,
              onTap: () => controller.selectAnswer(index),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNumberBox(String text, BuildContext context, {bool highlight = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlight 
            ? (isDark ? Colors.indigo[700] : Colors.indigo[100]) 
            : (isDark ? Colors.grey[700] : Colors.grey[100]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight 
              ? (isDark ? Colors.indigo[400]! : Colors.indigo[300]!) 
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: highlight 
            ? [
                BoxShadow(
                  color: (isDark ? Colors.indigo[800]! : Colors.indigo[300]!).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: highlight
              ? (isDark ? Colors.white : Colors.indigo[800])
              : (isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }
  
  Widget _buildOptionButton(int index, String text, BuildContext context, {required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[700] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.indigo[800],
            ),
          ),
        ),
      ),
    );
  }
}
