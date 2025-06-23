import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/data/repository/magic_triangle_repository.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/domain/model/magic_triangle.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/state/magic_triangle_state.dart';

class MagicTriangleController extends StateNotifier<MagicTriangleState> {
  final MagicTriangleRepository _repository;
  final DifficultyType difficulty;
  Timer? _gameTimer;

  MagicTriangleController(this._repository, {required this.difficulty})
      : super(_initialState(_repository, difficulty));

  static MagicTriangleState _initialState(MagicTriangleRepository repository, DifficultyType difficulty) {
    // Return initial state with difficulty level set
    return MagicTriangleState(
      difficulty: difficulty,
    );
  }

  /// Initialize the puzzle
  void initializeTriangle() {
    state = state.copyWith(status: MagicTriangleStatus.loading);

    try {
      // Generate a triangle puzzle based on difficulty
      final triangle = _repository.generateTriangle(state.difficulty);
      
      // Get available numbers for the puzzle
      final availableNumbers = _repository.getAvailableNumbers(triangle);
      
      state = state.copyWith(
        triangle: triangle,
        status: MagicTriangleStatus.initial,
        stats: MagicTriangleStats(
          difficulty: state.difficulty,
          moves: 0,
          timeInSeconds: 0,
          isCompleted: false,
          score: 0,
        ),
        availableNumbers: availableNumbers,
      );
    } catch (e) {
      state = state.copyWith(
        status: MagicTriangleStatus.initial,
        errorMessage: 'Failed to initialize puzzle: ${e.toString()}',
      );
    }
  }

  /// Start the game
  void startGame() {
    if (state.isPlaying) return;
    
    _startTimer();
    
    state = state.copyWith(
      status: MagicTriangleStatus.playing,
    );
  }
  
  /// Pause the game
  void pauseGame() {
    if (!state.isPlaying) return;
    
    _stopTimer();
    
    state = state.copyWith(
      status: MagicTriangleStatus.paused,
    );
  }
  
  /// Resume the game
  void resumeGame() {
    if (!state.isPaused) return;
    
    _startTimer();
    
    state = state.copyWith(
      status: MagicTriangleStatus.playing,
    );
  }
  
  /// Reset the game
  void resetGame() {
    _stopTimer();
    initializeTriangle();
  }
  
  /// Select a number from available numbers
  void selectNumber(int index) {
    if (!state.isPlaying) return;
    
    state = state.copyWith(
      selectedNumberIndex: index,
    );
  }
  
  /// Select a position in the triangle
  void selectPosition(int index) {
    if (!state.isPlaying) return;
    
    // If a position is already selected, just update it
    if (state.selectedPositionIndex != null) {
      state = state.copyWith(
        selectedPositionIndex: index,
      );
      return;
    }
    
    // If a number is selected, place that number at this position
    if (state.selectedNumberIndex != null) {
      placeNumber(index);
    } else {
      // Otherwise, just select this position
      state = state.copyWith(
        selectedPositionIndex: index,
      );
    }
  }
  
  /// Place a number at a position
  void placeNumber(int positionIndex) {
    if (!state.isPlaying || 
        state.selectedNumberIndex == null || 
        positionIndex < 0 || 
        positionIndex >= state.triangle.numbers.length) {
      return;
    }
    
    // Check if the position already has a number and is not a hint
    if (state.triangle.numbers[positionIndex] != null) {
      // You can't replace an existing number
      state = state.copyWith(
        errorMessage: "Can't replace existing number",
      );
      return;
    }
    
    // Get the selected number
    final selectedNumber = state.availableNumbers[state.selectedNumberIndex!];
    
    // Create a new triangle with the number placed
    final List<int?> newNumbers = List.from(state.triangle.numbers);
    newNumbers[positionIndex] = selectedNumber;
    
    final updatedTriangle = state.triangle.copyWith(
      numbers: newNumbers,
    );
    
    // Create updated available numbers
    final List<int> newAvailableNumbers = List.from(state.availableNumbers);
    newAvailableNumbers.removeAt(state.selectedNumberIndex!);
    
    // Update the stats
    final updatedStats = state.stats.copyWith(
      moves: state.stats.moves + 1,
    );
    
    state = state.copyWith(
      triangle: updatedTriangle,
      stats: updatedStats,
      availableNumbers: newAvailableNumbers,
      selectedNumberIndex: null,
      selectedPositionIndex: null,
    );
    
    // Check if the puzzle is solved
    if (updatedTriangle.checkSolution) {
      _completeGame();
    }
  }
  
  /// Remove a number from the triangle if it's not a hint
  void removeNumber(int positionIndex) {
    if (!state.isPlaying || 
        positionIndex < 0 || 
        positionIndex >= state.triangle.numbers.length) {
      return;
    }
    
    // Check if there is a number at this position
    if (state.triangle.numbers[positionIndex] == null) {
      return;
    }
    
    // Get the number at this position
    final numberAtPosition = state.triangle.numbers[positionIndex];
    
    // Create a new triangle with the number removed
    final List<int?> newNumbers = List.from(state.triangle.numbers);
    newNumbers[positionIndex] = null;
    
    final updatedTriangle = state.triangle.copyWith(
      numbers: newNumbers,
    );
    
    // Add the number back to available numbers
    final List<int> newAvailableNumbers = List.from(state.availableNumbers);
    newAvailableNumbers.add(numberAtPosition!);
    newAvailableNumbers.sort(); // Keep the list sorted
    
    // Update the stats
    final updatedStats = state.stats.copyWith(
      moves: state.stats.moves + 1,
    );
    
    state = state.copyWith(
      triangle: updatedTriangle,
      stats: updatedStats,
      availableNumbers: newAvailableNumbers,
      selectedNumberIndex: null,
      selectedPositionIndex: null,
    );
  }
  
  /// Show help dialog
  void toggleHelp() {
    state = state.copyWith(
      showHelp: !state.showHelp,
    );
  }
  
  /// Toggle sound
  void toggleSound() {
    state = state.copyWith(
      soundEnabled: !state.soundEnabled,
    );
  }
  
  /// Clear error message
  void clearError() {
    if (state.errorMessage == null) return;
    state = state.clearError();
  }

  // Private methods
  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!state.isPlaying) return;
        
        state = state.copyWith(
          stats: state.stats.copyWith(
            timeInSeconds: state.stats.timeInSeconds + 1,
          ),
        );
      },
    );
  }
  
  void _stopTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }
  
  void _completeGame() {
    _stopTimer();
    
    // Calculate score based on difficulty, time, and moves
    int baseScore;
    switch (state.difficulty) {
      case DifficultyType.easy:
        baseScore = 500;
        break;
      case DifficultyType.medium:
        baseScore = 1000;
        break;
      case DifficultyType.hard:
        baseScore = 1500;
        break;
    }
    
    // Penalty for time and moves
    final timeMultiplier = state.stats.timeInSeconds > 0 
      ? 1.0 - (state.stats.timeInSeconds / 300).clamp(0.0, 0.5) 
      : 1.0;
    final movesMultiplier = state.stats.moves > 0 
      ? 1.0 - (state.stats.moves / 50).clamp(0.0, 0.5) 
      : 1.0;
    
    final score = (baseScore * timeMultiplier * movesMultiplier).round();
    
    state = state.copyWith(
      status: MagicTriangleStatus.completed,
      stats: state.stats.copyWith(
        isCompleted: true,
        score: score,
      ),
      triangle: state.triangle.copyWith(
        isSolved: true,
      ),
    );
  }
  
  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
