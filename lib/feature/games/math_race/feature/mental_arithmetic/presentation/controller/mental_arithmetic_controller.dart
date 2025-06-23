import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/data/repository/mental_arithmetic_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/domain/model/mental_arithmetic.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/presentation/state/mental_arithmetic_state.dart';

class MentalArithmeticController extends StateNotifier<MentalArithmeticState> {
  final MentalArithmeticRepository _repository;
  Timer? _gameTimer;
  
  MentalArithmeticController(this._repository, {required DifficultyType difficulty})
      : super(MentalArithmeticState(difficulty: difficulty)) {
    // Initialize the game when the controller is created
    _init();
  }
  void _init() {
    // Load a new problem
    _loadNewProblem();
    
    // Initialize with playing state
    state = state.copyWith(
      status: MentalArithmeticStatus.playing,
      timeInSeconds: 0,
      score: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      questionResults: [],
      result: "",
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
      result: "",
    );
  }

  // Handle user input (number or minus sign)
  void onInputNumber(String input) {
    if (!state.isPlaying) return;
    
    if (state.currentProblem == null) return;
    
    // Handle minus sign
    if (input == "-") {
      if (state.result.isEmpty) {
        state = state.copyWith(result: "-");
      }
      return;
    }
    
    // Don't allow input that would make the result longer than the answer's length
    if (state.result.length < state.currentProblem!.answer.toString().length) {
      final updatedResult = state.result + input;
      state = state.copyWith(result: updatedResult);
      
      // Check if the answer is correct
      _checkAnswer();
    }
  }

  // Check if the current input matches the answer
  void _checkAnswer() {
    if (state.result.isNotEmpty && state.currentProblem != null) {
      try {
        final userAnswer = int.parse(state.result);
        final correctAnswer = state.currentProblem!.answer;
        
        // Check if the input is complete and correct
        if (state.result.length == correctAnswer.toString().length) {
          if (userAnswer == correctAnswer) {
            _onCorrectAnswer();
          } else {
            _onWrongAnswer();
          }
        }
      } catch (e) {
        // Handle parsing error if result is just "-" or other invalid number
      }
    }
  }

  // Handle correct answer
  void _onCorrectAnswer() async {
    // Update state with correct answer
    final updatedResults = List<bool>.from(state.questionResults)..add(true);
    state = state.copyWith(
      questionResults: updatedResults,
      correctAnswers: state.correctAnswers + 1,
      score: state.score + _calculatePoints(),
    );
    
    // Small delay before loading a new problem
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Load new problem
    _loadNewProblem();
  }

  // Handle wrong answer
  void _onWrongAnswer() async {
    // Update state with wrong answer
    final updatedResults = List<bool>.from(state.questionResults)..add(false);
    state = state.copyWith(
      questionResults: updatedResults,
      incorrectAnswers: state.incorrectAnswers + 1,
      showWrongAnswerAnimation: true,
    );
    
    // Show wrong animation briefly
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Hide animation and clear result
    state = state.copyWith(
      showWrongAnswerAnimation: false,
      result: "",
    );
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
  
  // Backspace button
  void onBackspace() {
    if (!state.isPlaying || state.result.isEmpty) return;
    
    state = state.copyWith(
      result: state.result.substring(0, state.result.length - 1)
    );
  }
  
  // Clear button
  void onClear() {
    if (!state.isPlaying) return;
    
    state = state.copyWith(result: "");
  }
  
  // Pause game
  void pauseGame() {
    if (!state.isPlaying) return;
    
    state = state.copyWith(status: MentalArithmeticStatus.paused);
  }
  
  // Resume game
  void resumeGame() {
    if (!state.isPaused) return;
    
    state = state.copyWith(status: MentalArithmeticStatus.playing);
  }
  
  // End game
  void endGame() {
    _gameTimer?.cancel();
    state = state.copyWith(
      status: MentalArithmeticStatus.completed,
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
