import 'package:fun_math/core/data/difficulty_type.dart';

class NumberPyramid {
  final List<List<int?>> rows;
  final DifficultyType difficulty;
  final int height;
  final bool isSolved;
  final bool showingSolution;
  
  const NumberPyramid({
    required this.rows,
    required this.difficulty,
    required this.height,
    this.isSolved = false,
    this.showingSolution = false,
  });
  
  // Get all values as a flattened list
  List<int?> get allValues {
    final result = <int?>[];
    for (final row in rows) {
      result.addAll(row);
    }
    return result;
  }
  
  // Get total number of cells
  int get totalCells {
    return rows.fold(0, (sum, row) => sum + row.length);
  }
  
  // Check if every position has a number
  bool get isComplete {
    for (final row in rows) {
      for (final value in row) {
        if (value == null) {
          return false;
        }
      }
    }
    return true;
  }
  
  // Check if the pyramid solution is valid
  bool get isValid {
    if (!isComplete) return false;
    
    // Check that each cell is the sum of the two cells below it
    for (int i = 0; i < rows.length - 1; i++) {
      for (int j = 0; j < rows[i].length; j++) {
        final currentValue = rows[i][j]!;
        final leftBelow = rows[i + 1][j]!;
        final rightBelow = rows[i + 1][j + 1]!;
        
        if (currentValue != leftBelow + rightBelow) {
          return false;
        }
      }
    }
    
    return true;
  }
  
  // Create a copy of this pyramid with a new value at a specific position
  NumberPyramid copyWithValueAt(int rowIndex, int colIndex, int? value) {
    final newRows = List<List<int?>>.from(
      rows.map((row) => List<int?>.from(row)),
    );
    
    newRows[rowIndex][colIndex] = value;
    
    return NumberPyramid(
      rows: newRows,
      difficulty: difficulty,
      height: height,
      isSolved: isSolved,
      showingSolution: showingSolution,
    );
  }
  
  // Create a copy of this pyramid with modified properties
  NumberPyramid copyWith({
    List<List<int?>>? rows,
    DifficultyType? difficulty,
    int? height,
    bool? isSolved,
    bool? showingSolution,
  }) {
    return NumberPyramid(
      rows: rows ?? this.rows,
      difficulty: difficulty ?? this.difficulty,
      height: height ?? this.height,
      isSolved: isSolved ?? this.isSolved,
      showingSolution: showingSolution ?? this.showingSolution,
    );
  }
}

class NumberPyramidStats {
  final int timeInSeconds;
  final int moves;
  final int hintsUsed;
  final bool isCompleted;
  final int score;
  final DifficultyType difficulty;
  
  const NumberPyramidStats({
    this.timeInSeconds = 0,
    this.moves = 0,
    this.hintsUsed = 0,
    this.isCompleted = false,
    this.score = 0,
    required this.difficulty,
  });
  
  NumberPyramidStats copyWith({
    int? timeInSeconds,
    int? moves,
    int? hintsUsed,
    bool? isCompleted,
    int? score,
    DifficultyType? difficulty,
  }) {
    return NumberPyramidStats(
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      moves: moves ?? this.moves,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
