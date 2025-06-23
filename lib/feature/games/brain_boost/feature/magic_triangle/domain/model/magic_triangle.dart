import 'package:fun_math/core/data/difficulty_type.dart';

class MagicTriangle {
  final List<int?> numbers;
  final int targetSum;
  final int size;
  final DifficultyType difficulty;
  final bool isSolved;
  
  const MagicTriangle({
    required this.numbers,
    required this.targetSum,
    required this.size,
    required this.difficulty,
    this.isSolved = false,
  });
  
  MagicTriangle copyWith({
    List<int?>? numbers,
    int? targetSum,
    int? size,
    DifficultyType? difficulty,
    bool? isSolved,
  }) {
    return MagicTriangle(
      numbers: numbers ?? this.numbers,
      targetSum: targetSum ?? this.targetSum,
      size: size ?? this.size,
      difficulty: difficulty ?? this.difficulty,
      isSolved: isSolved ?? this.isSolved,
    );
  }
  
  // Get the index positions for each side of the triangle
  List<List<int>> get sides {
    if (size == 3) {
      return [
        [0, 1, 2], // Side 1
        [2, 3, 4], // Side 2
        [4, 5, 0], // Side 3
      ];
    } else if (size == 4) {
      return [
        [0, 1, 2, 3], // Side 1
        [3, 4, 5, 6], // Side 2
        [6, 7, 8, 0], // Side 3
      ];
    } else {
      return [
        [0, 1, 2, 3, 4], // Side 1
        [4, 5, 6, 7, 8], // Side 2
        [8, 9, 10, 11, 0], // Side 3
      ];
    }
  }
  
  // Check if all sides have the same sum
  bool get checkSolution {
    if (numbers.contains(null)) return false;
    
    final sums = <int>[];
    for (final side in sides) {
      int sum = 0;
      for (final index in side) {
        sum += numbers[index] ?? 0;
      }
      sums.add(sum);
    }
    
    return sums.every((sum) => sum == sums[0]) && sums[0] == targetSum;
  }
}

class MagicTriangleStats {
  final int timeInSeconds;
  final int moves;
  final bool isCompleted;
  final int score;
  final DifficultyType difficulty;
  
  const MagicTriangleStats({
    this.timeInSeconds = 0,
    this.moves = 0,
    this.isCompleted = false,
    this.score = 0,
    required this.difficulty,
  });
  
  MagicTriangleStats copyWith({
    int? timeInSeconds,
    int? moves,
    bool? isCompleted,
    int? score,
    DifficultyType? difficulty,
  }) {
    return MagicTriangleStats(
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      moves: moves ?? this.moves,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      difficulty: difficulty ?? this.difficulty,
    );
  }
  
  // Calculate score based on time, moves and difficulty
  int calculateScore() {
    if (!isCompleted) return 0;
    
    // Base score depends on difficulty
    final baseScore = difficulty == DifficultyType.easy ? 500 : 
                      difficulty == DifficultyType.medium ? 1000 : 1500;
    
    // Time factor (faster is better)
    final maxTime = difficulty == DifficultyType.easy ? 180 : 
                    difficulty == DifficultyType.medium ? 300 : 500;
    final timeFactor = timeInSeconds < maxTime 
        ? 1.0 
        : 0.5; // Half score if taking too long
    
    // Moves factor (fewer moves is better)
    final minMoves = difficulty == DifficultyType.easy ? 15 : 
                     difficulty == DifficultyType.medium ? 30 : 60;
    final movesFactor = moves < minMoves 
        ? 1.0 
        : moves < minMoves * 2 
            ? 0.7 
            : 0.5;
    
    return (baseScore * timeFactor * movesFactor).round();
  }
}
