import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/domain/model/number_pyramid.dart';

class NumberPyramidRepository {
  
  // Generate a new number pyramid puzzle based on difficulty
  NumberPyramid generatePyramid(DifficultyType difficulty) {
    // Determine the height of the pyramid based on difficulty
    final height = _getHeightForDifficulty(difficulty);
    
    // Generate a completed pyramid solution first
    final solution = _generateSolution(height);
    
    // Create a puzzle by removing some numbers from the solution
    final puzzle = _createPuzzleFromSolution(solution, difficulty);
    
    return NumberPyramid(
      rows: puzzle,
      difficulty: difficulty,
      height: height,
    );
  }
  
  // Get a hint for the puzzle (reveals one correct cell)
  NumberPyramid getHint(NumberPyramid pyramid, List<List<int>> solution) {
    // Find a cell that is not filled in yet
    for (int i = 0; i < pyramid.rows.length; i++) {
      for (int j = 0; j < pyramid.rows[i].length; j++) {
        if (pyramid.rows[i][j] == null) {
          // Provide this cell as a hint
          return pyramid.copyWithValueAt(i, j, solution[i][j]);
        }
      }
    }
    
    // If we get here, all cells are filled
    return pyramid;
  }
  
  // Validate if a value at a specific position is correct according to the solution
  bool validateCell(NumberPyramid pyramid, int row, int col, int value, List<List<int>> solution) {
    if (row < 0 || row >= pyramid.rows.length || col < 0 || col >= pyramid.rows[row].length) {
      return false;
    }
    
    return solution[row][col] == value;
  }
  
  // Show the complete solution
  NumberPyramid showSolution(NumberPyramid pyramid, List<List<int>> solution) {
    final solutionRows = solution.map((row) => row.cast<int?>().toList()).toList();
    
    return pyramid.copyWith(
      rows: solutionRows,
      showingSolution: true,
    );
  }
  
  // Private helper methods
  
  int _getHeightForDifficulty(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return 4; // 4 rows
      case DifficultyType.medium:
        return 5; // 5 rows
      case DifficultyType.hard:
        return 6; // 6 rows
    }
  }
  
  // Generate a valid solution pyramid
  List<List<int>> _generateSolution(int height) {
    final random = Random();
    final solution = <List<int>>[];
    
    // Start by generating the bottom row with random small positive integers
    final bottomRow = <int>[];
    for (int i = 0; i < height; i++) {
      // Use small numbers to keep the upper rows manageable
      bottomRow.add(random.nextInt(9) + 1); // 1 to 9
    }
    solution.add(bottomRow);
    
    // Build up the pyramid by summing pairs of numbers
    for (int i = 1; i < height; i++) {
      final currentRow = <int>[];
      final previousRow = solution[i - 1];
      
      for (int j = 0; j < previousRow.length - 1; j++) {
        currentRow.add(previousRow[j] + previousRow[j + 1]);
      }
      
      solution.add(currentRow);
    }
    
    // The solution is built from bottom to top, so reverse it
    return solution.reversed.toList();
  }
  
  // Create a puzzle by removing some numbers from the solution
  List<List<int?>> _createPuzzleFromSolution(List<List<int>> solution, DifficultyType difficulty) {
    final random = Random();
    final puzzle = solution.map((row) => row.cast<int?>().toList()).toList();
    
    // Calculate total cells and how many to reveal based on difficulty
    int totalCells = 0;
    for (final row in solution) {
      totalCells += row.length;
    }
    
    // Determine reveal percentage based on difficulty
    double revealPercentage;
    switch (difficulty) {
      case DifficultyType.easy:
        revealPercentage = 0.5; // Reveal 50% of cells
        break;
      case DifficultyType.medium:
        revealPercentage = 0.35; // Reveal 35% of cells
        break;
      case DifficultyType.hard:
        revealPercentage = 0.25; // Reveal 25% of cells
        break;
    }
    
    int cellsToReveal = (totalCells * revealPercentage).round();
    
    // Always reveal the top cell to make the puzzle more solvable
    puzzle[0][0] = solution[0][0];
    cellsToReveal--;
    
    // Create a list of all positions (excluding the top cell)
    final positions = <List<int>>[];
    for (int i = 0; i < solution.length; i++) {
      for (int j = 0; j < solution[i].length; j++) {
        if (i != 0 || j != 0) { // Skip the top cell
          positions.add([i, j]);
        }
      }
    }
    
    // Randomly select positions to reveal
    positions.shuffle(random);
    for (int i = 0; i < cellsToReveal && i < positions.length; i++) {
      final pos = positions[i];
      puzzle[pos[0]][pos[1]] = solution[pos[0]][pos[1]];
    }
    
    return puzzle;
  }
}
