import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/repository/number_puzzle_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/data/service/score_storage_service.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/domain/model/number_puzzle.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/state/number_puzzle_state.dart';

class NumberPuzzleNotifier extends StateNotifier<NumberPuzzleState> {
  final NumberPuzzleRepository _repository;
  final ScoreStorageService _scoreService;
  final DifficultyType difficulty;
  Timer? _timer;
  
  NumberPuzzleNotifier(
    this._repository, 
    this._scoreService, 
    {required this.difficulty}
  ) : super(
        NumberPuzzleState(
          puzzle: _repository.createPuzzle(difficulty),
        )
      );

  /// Start the game
  void startGame() {
    _startTimer();
    state = state.copyWith(status: PuzzleStatus.playing);
  }

  /// Pause the game
  void pauseGame() {
    _cancelTimer();
    state = state.copyWith(status: PuzzleStatus.paused);
  }

  /// Resume the game
  void resumeGame() {
    _startTimer();
    state = state.copyWith(status: PuzzleStatus.playing);
  }

  /// Reset the game with a new puzzle
  void resetGame() {
    _cancelTimer();
    state = NumberPuzzleState(
      puzzle: _repository.createPuzzle(difficulty),
    );
  }

  /// Make a move in the puzzle
  void makeMove(int index) {
    if (state.status != PuzzleStatus.playing) {
      return;
    }
    
    if (!state.puzzle.canMove(index)) {
      return;
    }
    
    // Make the move
    final newPuzzle = _repository.makeMove(state.puzzle, index);
    final newMoveCount = state.moveCount + 1;
    
    // Check if the puzzle is solved
    if (newPuzzle.isSolved) {
      _handlePuzzleCompleted(newMoveCount);
    } else {
      state = state.copyWith(
        puzzle: newPuzzle,
        moveCount: newMoveCount,
      );
    }
  }

  /// Toggle the help display
  void toggleHelp() {
    state = state.copyWith(showHelp: !state.showHelp);
  }

  /// Toggle sound effects
  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  /// Toggle animations
  void toggleAnimations() {
    state = state.copyWith(animationEnabled: !state.animationEnabled);
  }
  /// Handle puzzle completion
  void _handlePuzzleCompleted(int moves) {
    _cancelTimer();
    
    // Calculate score
    final score = _repository.calculateScore(
      difficulty,
      moves,
      state.timeInSeconds,
    );
    
    // Create result
    final result = PuzzleResult(
      moves: moves,
      timeInSeconds: state.timeInSeconds,
      score: score,
    );
    
    // Save score to persistent storage
    _scoreService.saveBestScore(difficulty, score);
    
    // Update state
    state = state.copyWith(
      puzzle: state.puzzle,
      status: PuzzleStatus.completed,
      moveCount: moves,
      score: score,
      result: result,
    );
  }

  /// Start the timer
  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(timeInSeconds: state.timeInSeconds + 1);
    });
  }

  /// Cancel the timer
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
