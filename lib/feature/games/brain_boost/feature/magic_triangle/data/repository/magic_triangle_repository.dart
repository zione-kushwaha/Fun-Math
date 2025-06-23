import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/domain/model/magic_triangle.dart';

class MagicTriangleRepository {
  // Generate a magic triangle puzzle
  MagicTriangle generateTriangle(DifficultyType difficulty) {
    final random = Random();
    int size;
    int maxNumber;
    
    // Set size and max number based on difficulty
    switch (difficulty) {
      case DifficultyType.easy:
        size = 3; // 3 numbers per side
        maxNumber = 6;
        break;
      case DifficultyType.medium:
        size = 4; // 4 numbers per side
        maxNumber = 9;
        break;
      case DifficultyType.hard:
        size = 5; // 5 numbers per side
        maxNumber = 12;
        break;
    }
    
    // Total vertices in the triangle
    final totalVertices = size == 3 ? 6 : size == 4 ? 9 : 12;
    
    // Generate a valid magic triangle
    List<int> solution = _generateValidSolution(size, maxNumber);
    
    // Create the initial state with empty positions
    List<int?> initialState = List.filled(totalVertices, null);
    
    // For a fair start, provide some initial numbers
    int hintsCount = size == 3 ? 2 : size == 4 ? 3 : 4;
    
    for (int i = 0; i < hintsCount; i++) {
      int pos = random.nextInt(totalVertices);
      while (initialState[pos] != null) {
        pos = random.nextInt(totalVertices);
      }
      initialState[pos] = solution[pos];
    }
    
    // Calculate target sum from the solution
    final magicTriangle = MagicTriangle(
      numbers: initialState,
      targetSum: _calculateTargetSum(solution, size),
      size: size,
      difficulty: difficulty,
    );
    
    return magicTriangle;
  }
  
  // Generate a valid solution for the magic triangle
  List<int> _generateValidSolution(int size, int maxNumber) {
    final random = Random();
    final totalVertices = size == 3 ? 6 : size == 4 ? 9 : 12;
    List<int> solution = [];
    bool isValid = false;
    
    // Try generating until we get a valid solution
    int attempts = 0;
    const maxAttempts = 100;
    
    while (!isValid && attempts < maxAttempts) {
      attempts++;
      solution = [];
      // Generate unique numbers
      List<int> numbers = List.generate(maxNumber, (i) => i + 1);
      numbers.shuffle(random);
      solution = numbers.sublist(0, totalVertices);
      
      // Check if the solution is valid
      final magicTriangle = MagicTriangle(
        numbers: solution.cast<int?>(),
        targetSum: 0, // Will be calculated
        size: size,
        difficulty: DifficultyType.easy, // Doesn't matter for this check
      );
      
      final sides = magicTriangle.sides;
      final sums = sides.map((side) {
        return side.fold(0, (sum, index) => sum + solution[index]);
      }).toList();
      
      isValid = sums.every((sum) => sum == sums[0]);
      
      if (isValid) {
        return solution;
      }
    }
    
  // If we can't generate a valid solution, use a predefined one
    if (size == 3) {
      return [1, 5, 6, 2, 4, 3]; // Sum = 12
    } else if (size == 4) {
      return [6, 1, 2, 9, 8, 7, 3, 4, 5]; // Sum = 18
    } else {
      return [8, 1, 3, 6, 12, 11, 2, 4, 9, 7, 5, 10]; // Sum = 30
    }
  }
  
  // Calculate the target sum for the magic triangle
  int _calculateTargetSum(List<int> solution, int size) {
    final magicTriangle = MagicTriangle(
      numbers: solution.cast<int?>(),
      targetSum: 0, // Will be calculated
      size: size,
      difficulty: DifficultyType.easy, // Doesn't matter for this check
    );
    
    final sides = magicTriangle.sides;
    return sides[0].fold(0, (sum, index) => sum + solution[index]);
  }
  
  // Get available numbers for the puzzle
  List<int> getAvailableNumbers(MagicTriangle triangle) {
    // Find which numbers are already placed in the triangle
    final placedNumbers = triangle.numbers.where((n) => n != null).cast<int>().toList();
    
    // Determine the maximum number based on difficulty/size
    int maxNumber;
    switch (triangle.difficulty) {
      case DifficultyType.easy:
        maxNumber = 6;
        break;
      case DifficultyType.medium:
        maxNumber = 9;
        break;
      case DifficultyType.hard:
        maxNumber = 12;
        break;
    }
    
    // Create a list of available numbers (numbers not placed yet)
    final availableNumbers = List.generate(maxNumber, (i) => i + 1)
      .where((n) => !placedNumbers.contains(n))
      .toList();
    
    return availableNumbers;
  }
  
  // Get all possible numbers for a difficulty level
  List<int> getAllNumbersForDifficulty(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return List.generate(6, (i) => i + 1); // 1 to 6
      case DifficultyType.medium:
        return List.generate(9, (i) => i + 1); // 1 to 9
      case DifficultyType.hard:
        return List.generate(12, (i) => i + 1); // 1 to 12
    }
  }
}
