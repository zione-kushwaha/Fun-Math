import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/provider/magic_triangle_providers.dart';

class AvailableNumbersPanel extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const AvailableNumbersPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(magicTriangleControllerProvider(difficulty));
    final controller = ref.read(magicTriangleControllerProvider(difficulty).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
            'Available Numbers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.availableNumbers.asMap().entries.map((entry) {
              final index = entry.key;
              final number = entry.value;
              final isSelected = state.selectedNumberIndex == index;
              
              return GestureDetector(
                onTap: () => controller.selectNumber(index),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? (isDark ? Colors.purpleAccent[700] : Colors.purpleAccent)
                        : (isDark ? Colors.purple[800] : Colors.purple[100]),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (isDark ? Colors.purpleAccent : Colors.purple).withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      number.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.purple[800]),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
