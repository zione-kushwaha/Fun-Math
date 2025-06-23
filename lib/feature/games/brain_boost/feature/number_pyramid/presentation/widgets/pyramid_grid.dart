import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/provider/number_pyramid_providers.dart';

class PyramidGrid extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const PyramidGrid({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(numberPyramidControllerProvider(difficulty));
    final controller = ref.read(numberPyramidControllerProvider(difficulty).notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (state.pyramid.rows.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate cell size based on available width
          final maxWidth = constraints.maxWidth;
          // Calculate the width of the bottom row (widest row)
          final bottomRowWidth = state.pyramid.rows.last.length * 70.0; // Assume each cell is about 70 wide with spacing
          
          // Scale down if needed
          final scale = bottomRowWidth > maxWidth ? maxWidth / bottomRowWidth : 1.0;
          
          return Transform.scale(
            scale: scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                state.pyramid.rows.length,
                (rowIndex) {
                  final row = state.pyramid.rows[rowIndex];
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        row.length,
                        (colIndex) {
                          final value = row[colIndex];
                          final isEditable = state.isCellEditable(rowIndex, colIndex);
                          final isSelected = state.isCellSelected(rowIndex, colIndex);
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: PyramidCell(
                              value: value,
                              isEditable: isEditable,
                              isSelected: isSelected,
                              isDark: isDark,
                              onTap: () => controller.selectCell(rowIndex, colIndex),
                              onLongPress: isEditable && value != null
                                  ? () => controller.clearCell(rowIndex, colIndex)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class PyramidCell extends StatelessWidget {
  final int? value;
  final bool isEditable;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  
  const PyramidCell({
    Key? key,
    required this.value,
    required this.isEditable,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: _getCellColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.purpleAccent : Colors.purple)
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? Colors.purpleAccent : Colors.purple.shade300).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: value != null
              ? Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(),
                  ),
                )
              : null,
        ),
      ),
    );
  }
  
  Color _getCellColor() {
    if (!isEditable) {
      // Initial (given) cells have a different background
      return isDark ? Colors.purple.withOpacity(0.3) : Colors.purple.withOpacity(0.1);
    } else if (isSelected) {
      return isDark ? Colors.purple[800]! : Colors.purple[50]!;
    } else {
      return isDark ? Colors.grey[800]! : Colors.white;
    }
  }
  
  Color _getTextColor() {
    if (!isEditable) {
      // Initial values
      return isDark ? Colors.purple[100]! : Colors.purple[800]!;
    } else {
      // User entered values
      return isDark ? Colors.white : Colors.black;
    }
  }
}
