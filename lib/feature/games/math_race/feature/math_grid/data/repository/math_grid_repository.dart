import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/domain/model/math_grid.dart';

class MathGridRepository {
  final Random _random = Random();
  
  MathGrid generateMathGrid(DifficultyType difficultyType) {
    const gridSize = 9; // 9x9 grid
    List<MathGridCellModel> gridCells = [];
    
    for (int i = 0; i < gridSize * gridSize; i++) {
      int value;
      
      switch (difficultyType) {
        case DifficultyType.easy:
          value = _random.nextInt(9) + 1; // 1-9
          break;
        case DifficultyType.medium:
          value = _random.nextInt(19) + 1; // 1-19
          break;
        case DifficultyType.hard:
          value = _random.nextInt(49) + 1; // 1-49
          break;
      }
      
      gridCells.add(MathGridCellModel(i, value, false, false));
    }
    
    return MathGrid(listForSquare: gridCells);
  }
}
