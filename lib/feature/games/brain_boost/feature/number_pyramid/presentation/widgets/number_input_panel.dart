import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/controller/number_pyramid_controller.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/provider/number_pyramid_providers.dart';

class NumberInputPanel extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const NumberInputPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(numberPyramidControllerProvider(difficulty).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Determine max number based on difficulty
    int maxNumber;
    switch (difficulty) {
      case DifficultyType.easy:
        maxNumber = 20;
        break;
      case DifficultyType.medium:
        maxNumber = 30;
        break;
      case DifficultyType.hard:
        maxNumber = 50;
        break;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a Number',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 1; i <= 9; i++)
                _buildNumberButton(context, i, controller, isDark),
              
              // Add more numbers based on difficulty
              if (maxNumber > 9)
                for (int i = 10; i <= Math.min(maxNumber, 20); i++)
                  _buildNumberButton(context, i, controller, isDark),
                  
              // Clear button
              _buildActionButton(
                context, 
                Icon(
                  Icons.backspace_outlined,
                  color: isDark ? Colors.red[300] : Colors.red,
                  size: 20,
                ), 
                () {
                  // Clear the selected number
                  controller.selectNumber(-1);
                },
                isDark,
                color: isDark ? Colors.red[900]! : Colors.red[100]!,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberButton(BuildContext context, int number, NumberPyramidController controller, bool isDark) {
    return InkWell(
      onTap: () => controller.selectNumber(number),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.purple[800] : Colors.purple[100],
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withOpacity(0.3) 
                  : Colors.purple.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.purple[800],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, 
    Widget icon, 
    VoidCallback onTap, 
    bool isDark, 
    {Color? color}
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? (isDark ? Colors.grey[700] : Colors.grey[300]),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withOpacity(0.3) 
                  : Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}

class Math {
  static int min(int a, int b) {
    return a < b ? a : b;
  }
}
