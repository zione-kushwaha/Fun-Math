import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/domain/model/quick_calculation.dart';

class QuickCalculationState {
  final QuickCalculation currentQuestion;
  final String currentInput;
  final bool isCorrect;
  final bool isWrong;
  final int score;
  final int timeLeft;
  final bool isPaused;
  final bool isGameOver;
  final int totalQuestionsAnswered;

  QuickCalculationState({
    required this.currentQuestion,
    this.currentInput = '',
    this.isCorrect = false,
    this.isWrong = false,
    this.score = 0,
    this.timeLeft = 0,
    this.isPaused = false,
    this.isGameOver = false,
    this.totalQuestionsAnswered = 0,
  });

  QuickCalculationState copyWith({
    QuickCalculation? currentQuestion,
    String? currentInput,
    bool? isCorrect,
    bool? isWrong,
    int? score,
    int? timeLeft,
    bool? isPaused,
    bool? isGameOver,
    int? totalQuestionsAnswered,
  }) {
    return QuickCalculationState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      currentInput: currentInput ?? this.currentInput,
      isCorrect: isCorrect ?? this.isCorrect,
      isWrong: isWrong ?? this.isWrong,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      totalQuestionsAnswered: totalQuestionsAnswered ?? this.totalQuestionsAnswered,
    );
  }
}
