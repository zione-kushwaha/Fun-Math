import 'package:fun_math/feature/games/number_puzzle/feature/guess_sign/domain/model/guess_sign.dart';

class GuessSignState {
  final GuessSign currentQuestion;
  final String selectedSign;
  final bool isCorrect;
  final bool isWrong;
  final int score;
  final int timeLeft;
  final bool isPaused;
  final int questionNumber;
  final int totalQuestions;

  GuessSignState({
    required this.currentQuestion,
    this.selectedSign = '',
    this.isCorrect = false,
    this.isWrong = false,
    this.score = 0,
    this.timeLeft = 30,
    this.isPaused = false,
    this.questionNumber = 1,
    this.totalQuestions = 10,
  });

  GuessSignState copyWith({
    GuessSign? currentQuestion,
    String? selectedSign,
    bool? isCorrect,
    bool? isWrong,
    int? score,
    int? timeLeft,
    bool? isPaused,
    int? questionNumber,
    int? totalQuestions,
  }) {
    return GuessSignState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedSign: selectedSign ?? this.selectedSign,
      isCorrect: isCorrect ?? this.isCorrect,
      isWrong: isWrong ?? this.isWrong,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      isPaused: isPaused ?? this.isPaused,
      questionNumber: questionNumber ?? this.questionNumber,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }
}
