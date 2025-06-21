import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/domain/model/calculator.dart';

class CalculatorState {
  final Calculator currentQuestion;
  final String currentInput;
  final bool isCorrect;
  final bool isWrong;
  final int score;
  final int timeLeft;
  final bool isPaused;

  CalculatorState({
    required this.currentQuestion,
    this.currentInput = '',
    this.isCorrect = false,
    this.isWrong = false,
    this.score = 0,
    this.timeLeft = 30,
    this.isPaused = false,
  });

  CalculatorState copyWith({
    Calculator? currentQuestion,
    String? currentInput,
    bool? isCorrect,
    bool? isWrong,
    int? score,
    int? timeLeft,
    bool? isPaused,
  }) {
    return CalculatorState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      currentInput: currentInput ?? this.currentInput,
      isCorrect: isCorrect ?? this.isCorrect,
      isWrong: isWrong ?? this.isWrong,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}
