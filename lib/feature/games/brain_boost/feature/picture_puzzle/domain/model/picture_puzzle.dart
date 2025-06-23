class PicturePuzzleTile {
  final int id;
  final int correctPosition;
  final int currentPosition;
  
  const PicturePuzzleTile({
    required this.id,
    required this.correctPosition,
    required this.currentPosition,
  });
  
  bool get isInCorrectPosition => correctPosition == currentPosition;
  
  PicturePuzzleTile copyWith({
    int? id,
    int? correctPosition,
    int? currentPosition,
  }) {
    return PicturePuzzleTile(
      id: id ?? this.id,
      correctPosition: correctPosition ?? this.correctPosition,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }
}

enum PuzzleLevel {
  easy, // 3x3 grid
  medium, // 4x4 grid
  hard, // 5x5 grid
}

class PuzzleStats {
  final int moves;
  final int timeInSeconds;
  final bool isCompleted;
  final PuzzleLevel level;
  
  const PuzzleStats({
    required this.moves,
    required this.timeInSeconds,
    required this.isCompleted,
    required this.level,
  });
  
  int get score {
    if (!isCompleted) return 0;
    
    // Base score depends on difficulty
    final baseScore = level == PuzzleLevel.easy ? 500 : 
                      level == PuzzleLevel.medium ? 1000 : 1500;
    
    // Time factor (faster is better)
    final maxTime = level == PuzzleLevel.easy ? 180 : 
                    level == PuzzleLevel.medium ? 300 : 500;
    final timeFactor = timeInSeconds < maxTime 
        ? 1.0 
        : 0.5; // Half score if taking too long
    
    // Moves factor (fewer moves is better)
    final minMoves = level == PuzzleLevel.easy ? 15 : 
                     level == PuzzleLevel.medium ? 30 : 60;
    final movesFactor = moves < minMoves * 2 
        ? 1.0 
        : moves < minMoves * 4 
            ? 0.8 
            : 0.6; // Reduce score for excessive moves
    
    return (baseScore * timeFactor * movesFactor).toInt();
  }
  
  PuzzleStats copyWith({
    int? moves,
    int? timeInSeconds,
    bool? isCompleted,
    PuzzleLevel? level,
  }) {
    return PuzzleStats(
      moves: moves ?? this.moves,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      level: level ?? this.level,
    );
  }
}
