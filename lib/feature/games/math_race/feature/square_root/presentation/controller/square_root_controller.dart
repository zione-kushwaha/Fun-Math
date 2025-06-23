import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/data/repository/square_root_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/presentation/state/square_root_state.dart';

class SquareRootController extends StateNotifier<SquareRootState> {
  final SquareRootRepository _repository;
  Timer? _gameTimer;
  
  SquareRootController(this._repository, {required DifficultyType difficulty})
      : super(SquareRootState(difficulty: difficulty)) {
    // Initialize the game when the controller is created
    _init();
  }

  void _init() {
    // Load a new problem
    _loadNewProblem();
    
    // Initialize with playing state
    state = state.copyWith(
      status: SquareRootStatus.playing,
      timeInSeconds: 0,
      score: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      questionResults: [],
      selectedAnswerIndex: null,
    );
    
    // Start the game timer
    _startTimer();
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isPlaying) {
        state = state.copyWith(
          timeInSeconds: state.timeInSeconds + 1,
        );
      }
    });
  }

  void _loadNewProblem() {
    final newProblem = _repository.generateProblem(state.difficulty);
    state = state.copyWith(
      currentProblem: newProblem,
      selectedAnswerIndex: null,
    );
  }

  // Select an answer option
  void selectAnswer(int answerIndex) async {
    if (!state.isPlaying || state.currentProblem == null) return;
    
    // Update state with selected answer
    state = state.copyWith(selectedAnswerIndex: answerIndex);
    
    // Check if the answer is correct (1-based index)
    final isCorrect = answerIndex == state.currentProblem!.answer;
    
    if (isCorrect) {
      await _onCorrectAnswer();
    } else {
      await _onWrongAnswer();
    }
  }

  // Handle correct answer
  Future<void> _onCorrectAnswer() async {
    // Update state with correct answer
    final updatedResults = List<bool>.from(state.questionResults)..add(true);
    state = state.copyWith(
      questionResults: updatedResults,
      correctAnswers: state.correctAnswers + 1,
      score: state.score + _calculatePoints(),
    );
    
    // Small delay before loading a new problem
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Load new problem
    _loadNewProblem();
  }

  // Handle wrong answer
  Future<void> _onWrongAnswer() async {
    // Update state with wrong answer
    final updatedResults = List<bool>.from(state.questionResults)..add(false);
    state = state.copyWith(
      questionResults: updatedResults,
      incorrectAnswers: state.incorrectAnswers + 1,
      showWrongAnswerAnimation: true,
    );
    
    // Show wrong animation briefly
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Hide animation
    state = state.copyWith(
      showWrongAnswerAnimation: false,
    );
    
    // Load a new problem
    _loadNewProblem();
  }
  
  // Calculate points based on difficulty and answer speed
  int _calculatePoints() {
    int basePoints;
    switch (state.difficulty) {
      case DifficultyType.easy:
        basePoints = 5;
        break;
      case DifficultyType.medium:
        basePoints = 10;
        break;
      case DifficultyType.hard:
        basePoints = 15;
        break;
    }
    
    return basePoints;
  }
  
  // Pause game
  void pauseGame() {
    if (!state.isPlaying) return;
    
    state = state.copyWith(status: SquareRootStatus.paused);
  }
  
  // Resume game
  void resumeGame() {
    if (!state.isPaused) return;
    
    state = state.copyWith(status: SquareRootStatus.playing);
  }
  
  // End game
  void endGame() {
    _gameTimer?.cancel();
    state = state.copyWith(
      status: SquareRootStatus.completed,
    );
    
    // Save high score in a real app
    _repository.saveHighScore(state.difficulty, state.score);
  }
  
  // Restart game
  void restartGame() {
    _gameTimer?.cancel();
    _init();
  }
  
  // Toggle help
  void toggleHelp() {
    state = state.copyWith(showHelp: !state.showHelp);
  }
  
  // Toggle sound
  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
