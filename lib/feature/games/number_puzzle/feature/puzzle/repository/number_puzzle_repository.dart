import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/domain/model/number_puzzle.dart';

class NumberPuzzleRepository {
  final Random _random = Random();

  /// Create a new puzzle based on the selected difficulty
  NumberPuzzleModel createPuzzle(DifficultyType difficulty, {PuzzleSize? size}) {
    // Determine grid size based on difficulty
    final puzzleSize = size ?? _getPuzzleSizeFromDifficulty(difficulty);
    final gridSize = puzzleSize == PuzzleSize.threeByThree ? 3 : 4;
    
    // Create a solved puzzle
    final solution = List.generate(gridSize * gridSize, (index) => index + 1);
    solution[solution.length - 1] = 0; // The last position is empty (0)
    
    // Create a shuffled puzzle
    final numbers = List<int>.from(solution);
    final shuffleMoves = _getShuffleMovesByDifficulty(difficulty);
    
    // Shuffle the puzzle by making random valid moves
    int emptyIndex = numbers.indexOf(0);
    for (int i = 0; i < shuffleMoves; i++) {
      final validMoves = _getValidMoves(numbers, gridSize, emptyIndex);
      if (validMoves.isNotEmpty) {
        final moveIndex = validMoves[_random.nextInt(validMoves.length)];
        // Swap the empty tile with the selected tile
        numbers[emptyIndex] = numbers[moveIndex];
        numbers[moveIndex] = 0;
        emptyIndex = moveIndex;
      }
    }
    
    return NumberPuzzleModel(
      numbers: numbers,
      solution: solution,
      gridSize: gridSize,
      emptyIndex: emptyIndex,
    );
  }
  
  /// Make a move in the puzzle
  NumberPuzzleModel makeMove(NumberPuzzleModel puzzle, int index) {
    if (!puzzle.canMove(index)) {
      return puzzle;
    }
    
    final numbers = List<int>.from(puzzle.numbers);
    // Swap the selected tile with the empty tile
    numbers[puzzle.emptyIndex] = numbers[index];
    numbers[index] = 0;
    
    return puzzle.copyWith(
      numbers: numbers,
      emptyIndex: index,
    );
  }
  
  /// Calculate the score based on moves and time
  int calculateScore(DifficultyType difficulty, int moves, int timeInSeconds) {
    final baseScore = difficulty == DifficultyType.easy ? 500 :
                     difficulty == DifficultyType.medium ? 1000 : 1500;
    
    // Adjust for number of moves (fewer moves = higher score)
    final difficultyMultiplier = difficulty == DifficultyType.easy ? 1.0 :
                               difficulty == DifficultyType.medium ? 1.5 : 2.0;
    
    // Time penalty (faster completion = higher score)
    final timeFactor = (300 - min(timeInSeconds, 300)) / 300; // Cap at 300 seconds
    
    // Moves penalty
    final movesMax = _getMaxOptimalMoves(difficulty);
    final movesFactor = movesMax / max(moves, 1); // Inverse relationship
    
    return (baseScore * difficultyMultiplier * timeFactor * movesFactor).toInt();
  }
  
  /// Get valid moves for a given puzzle state
  List<int> _getValidMoves(List<int> numbers, int gridSize, int emptyIndex) {
    final validMoves = <int>[];
    final row = emptyIndex ~/ gridSize;
    final col = emptyIndex % gridSize;
    
    // Check up
    if (row > 0) {
      validMoves.add(emptyIndex - gridSize);
    }
    
    // Check down
    if (row < gridSize - 1) {
      validMoves.add(emptyIndex + gridSize);
    }
    
    // Check left
    if (col > 0) {
      validMoves.add(emptyIndex - 1);
    }
    
    // Check right
    if (col < gridSize - 1) {
      validMoves.add(emptyIndex + 1);
    }
    
    return validMoves;
  }
  
  /// Get the puzzle size based on difficulty
  PuzzleSize _getPuzzleSizeFromDifficulty(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return PuzzleSize.threeByThree;
      case DifficultyType.medium:
      case DifficultyType.hard:
        return PuzzleSize.fourByFour;
    }
  }
  
  /// Get the number of shuffle moves based on difficulty
  int _getShuffleMovesByDifficulty(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return 20; // Easier puzzle with fewer shuffles
      case DifficultyType.medium:
        return 40;
      case DifficultyType.hard:
        return 80; // More complex puzzle with more shuffles
    }
  }
  
  /// Get the maximum optimal moves for scoring
  int _getMaxOptimalMoves(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return 30;
      case DifficultyType.medium:
        return 50;
      case DifficultyType.hard:
        return 80;
    }
  }
}
