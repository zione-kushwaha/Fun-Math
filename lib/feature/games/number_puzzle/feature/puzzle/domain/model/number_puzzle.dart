class NumberPuzzleModel {
  final List<int> numbers;
  final List<int> solution;
  final int gridSize;
  final int emptyIndex;

  NumberPuzzleModel({
    required this.numbers,
    required this.solution,
    required this.gridSize,
    required this.emptyIndex,
  });

  NumberPuzzleModel copyWith({
    List<int>? numbers,
    List<int>? solution,
    int? gridSize,
    int? emptyIndex,
  }) {
    return NumberPuzzleModel(
      numbers: numbers ?? this.numbers,
      solution: solution ?? this.solution,
      gridSize: gridSize ?? this.gridSize,
      emptyIndex: emptyIndex ?? this.emptyIndex,
    );
  }

  bool get isSolved => numbers.toString() == solution.toString();

  bool canMove(int index) {
    // Check if the tile is adjacent to the empty space
    // For a grid, tiles can only move horizontally or vertically
    final row = index ~/ gridSize;
    final col = index % gridSize;
    final emptyRow = emptyIndex ~/ gridSize;
    final emptyCol = emptyIndex % gridSize;

    // The tile can move if it's in the same row or column as the empty space
    // and it's adjacent to it
    return (row == emptyRow && (col == emptyCol - 1 || col == emptyCol + 1)) ||
           (col == emptyCol && (row == emptyRow - 1 || row == emptyRow + 1));
  }
}

class PuzzleResult {
  final int moves;
  final int timeInSeconds;
  final int score;

  PuzzleResult({
    required this.moves,
    required this.timeInSeconds,
    required this.score,
  });
}

enum PuzzleSize {
  threeByThree,
  fourByFour
}
