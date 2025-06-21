import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/data/repository/correct_answer_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/domain/model/correct_answer.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/presentation/state/correct_answer_state.dart';

class CorrectAnswerNotifier extends StateNotifier<CorrectAnswerState> {
  final CorrectAnswerRepository _repository;
  Timer? _timer;
  final DifficultyType difficultyType;
  final int totalQuestions;

  CorrectAnswerNotifier(
    this._repository, {
    required this.difficultyType,
    this.totalQuestions = 10,
  }) : super(CorrectAnswerState(
          currentQuestion: CorrectAnswer(
            question: 'Loading...',
            options: [0, 0, 0, 0],
            correctAnswer: 0,
          ),
          totalQuestions: totalQuestions,
        )) {
    _startGame();
  }

  void _startGame() {
    _generateNewQuestion();
    _startTimer();
  }

  void _generateNewQuestion() {
    final newQuestion = _repository.generateQuestion(difficultyType);
    state = state.copyWith(
      currentQuestion: newQuestion,
      selectedOption: -1,
      isCorrect: false,
      isWrong: false,
    );
  }

  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft <= 0) {
        _handleTimeUp();
      } else if (!state.isPaused) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleTimeUp() {
    // If time runs out, treat as wrong answer
    state = state.copyWith(isWrong: true);
    
    // Move to next question after delay
    Future.delayed(const Duration(seconds: 1), () {
      _moveToNextQuestion();
    });
  }

  void selectOption(int optionIndex) {
    if (state.isPaused || state.selectedOption != -1) {
      return;
    }
    
    final isCorrect = state.currentQuestion.options[optionIndex] == state.currentQuestion.correctAnswer;
    
    state = state.copyWith(
      selectedOption: optionIndex,
      isCorrect: isCorrect,
      isWrong: !isCorrect,
    );
    
    if (isCorrect) {
      state = state.copyWith(score: state.score + _calculateScore());
    }
    
    // Move to next question after a delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _moveToNextQuestion();
    });
  }

  void _moveToNextQuestion() {
    if (state.questionNumber >= state.totalQuestions) {
      // Game is finished
      _endGame();
      return;
    }
    
    // Reset timer for next question
    state = state.copyWith(
      questionNumber: state.questionNumber + 1,
      timeLeft: _getTimePerQuestion(),
    );
    
    _generateNewQuestion();
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
    int timeBonus = (state.timeLeft / 2).round();
    
    return baseScore + timeBonus;
  }

  int _getTimePerQuestion() {
    switch (difficultyType) {
      case DifficultyType.easy:
        return 30;
      case DifficultyType.medium:
        return 25;
      case DifficultyType.hard:
        return 20;
    }
  }

  void _endGame() {
    _cancelTimer();
    // Game is complete, you can add further logic here
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
    state = CorrectAnswerState(
      currentQuestion: _repository.generateQuestion(difficultyType),
      timeLeft: _getTimePerQuestion(),
      totalQuestions: totalQuestions,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
