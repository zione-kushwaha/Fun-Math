import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/data/repository/calculator_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/domain/model/calculator.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/presentation/state/calculator_state.dart';

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  final CalculatorRepository _repository;
  Timer? _timer;
  final DifficultyType difficultyType;

  CalculatorNotifier(this._repository, this.difficultyType)
      : super(CalculatorState(
            currentQuestion: Calculator(question: '0 + 0', answer: 0))) {
    _startGame();
  }

  void _startGame() {
    _generateNewQuestion();
    _startTimer();
  }

  void _generateNewQuestion() {
    final newQuestion = _repository.generateCalculatorQuestion(difficultyType);
    state = state.copyWith(
      currentQuestion: newQuestion,
      currentInput: '',
      isCorrect: false,
      isWrong: false,
    );
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

  void _endGame() {
    _cancelTimer();
    // Handle end game logic here
  }

  void addInput(String digit) {
    if (state.isPaused) return;
    
    final newInput = state.currentInput + digit;
    state = state.copyWith(currentInput: newInput);
    _checkAnswer();
  }

  void clearInput() {
    if (state.isPaused) return;
    
    state = state.copyWith(currentInput: '');
  }

  void backspace() {
    if (state.isPaused || state.currentInput.isEmpty) return;
    
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
      );
      
      // Add a slight delay before generating the next question
      Future.delayed(const Duration(milliseconds: 500), () {
        _generateNewQuestion();
      });
    } else if (state.currentInput.length >= state.currentQuestion.answer.toString().length) {
      state = state.copyWith(
        isWrong: true,
        isCorrect: false,
      );
      
      // Clear wrong answer after a short delay
      Future.delayed(const Duration(seconds: 1), () {
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
    
    // Add bonus for faster answers (more time left)
    int timeBonus = (state.timeLeft / 5).round();
    
    return baseScore + timeBonus;
  }

  void pauseGame() {
    if (_timer == null) return;
    
    state = state.copyWith(isPaused: true);
  }

  void resumeGame() {
    if (_timer == null) {
      _startTimer();
    }
    
    state = state.copyWith(isPaused: false);
  }

  void resetGame() {
    _cancelTimer();
    state = CalculatorState(
      currentQuestion: _repository.generateCalculatorQuestion(difficultyType),
      timeLeft: 30,
      score: 0,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
