import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/data/repository/quick_calculation_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/domain/model/quick_calculation.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/presentation/state/quick_calculation_state.dart';

class QuickCalculationNotifier extends StateNotifier<QuickCalculationState> {
  final QuickCalculationRepository _repository;
  Timer? _timer;
  final DifficultyType difficultyType;
  final int gameTimeInSeconds;

  QuickCalculationNotifier(
    this._repository, {
    required this.difficultyType,
    this.gameTimeInSeconds = 60, // 1 minute game by default
  }) : super(QuickCalculationState(
          currentQuestion: QuickCalculation(
            question: 'Loading...',
            answer: 0,
            timeInSeconds: 0,
          ),
        )) {
    _startGame();
  }

  void _startGame() {
    final firstQuestion = _repository.generateCalculation(difficultyType);
    state = state.copyWith(
      currentQuestion: firstQuestion,
      timeLeft: gameTimeInSeconds,
      isGameOver: false,
      score: 0,
      totalQuestionsAnswered: 0,
    );
    _startTimer();
  }

  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft <= 0) {
        _endGame();
      } else if (!state.isPaused) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _generateNewQuestion() {
    final newQuestion = _repository.generateCalculation(difficultyType);
    state = state.copyWith(
      currentQuestion: newQuestion,
      currentInput: '',
      isCorrect: false,
      isWrong: false,
    );
  }

  void addInput(String digit) {
    if (state.isPaused || state.isGameOver) return;
    
    final newInput = state.currentInput + digit;
    state = state.copyWith(currentInput: newInput);
    _checkAnswer();
  }

  void clearInput() {
    if (state.isPaused || state.isGameOver) return;
    
    state = state.copyWith(currentInput: '');
  }

  void backspace() {
    if (state.isPaused || state.isGameOver || state.currentInput.isEmpty) return;
    
    final newInput = state.currentInput.substring(0, state.currentInput.length - 1);
    state = state.copyWith(currentInput: newInput);
  }

  void _checkAnswer() {
    if (state.currentInput.isEmpty) return;
    
    final userAnswer = int.tryParse(state.currentInput) ?? 0;
    if (userAnswer == state.currentQuestion.answer) {
      state = state.copyWith(
        isCorrect: true,
        isWrong: false,
        score: state.score + _calculateScore(),
        totalQuestionsAnswered: state.totalQuestionsAnswered + 1,
      );
      
      // Add a slight delay before generating the next question
      Future.delayed(const Duration(milliseconds: 300), () {
        _generateNewQuestion();
      });
    } else if (state.currentInput.length >= state.currentQuestion.answer.toString().length) {
      state = state.copyWith(
        isWrong: true,
        isCorrect: false,
      );
      
      // Clear wrong answer after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        state = state.copyWith(isWrong: false, currentInput: '');
      });
    }
  }

  int _calculateScore() {
    // Base score dependent on difficulty
    int baseScore;
    switch (difficultyType) {
      case DifficultyType.easy:
        baseScore = 5;
        break;
      case DifficultyType.medium:
        baseScore = 10;
        break;
      case DifficultyType.hard:
        baseScore = 15;
        break;
    }
    
    // Add bonus based on the question's time constraint
    // The harder the question (less time to solve), the more points
    int timeBonus = (10 / state.currentQuestion.timeInSeconds).round();
    
    return baseScore + timeBonus;
  }

  void _endGame() {
    _cancelTimer();
    state = state.copyWith(isGameOver: true);
  }

  void pauseGame() {
    if (_timer == null || state.isGameOver) return;
    state = state.copyWith(isPaused: true);
  }

  void resumeGame() {
    if (state.isGameOver) return;
    
    if (_timer == null) {
      _startTimer();
    }
    
    state = state.copyWith(isPaused: false);
  }

  void resetGame() {
    _cancelTimer();
    _startGame();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
