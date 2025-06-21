import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/domain/model/correct_answer.dart';

class CorrectAnswerState {
  final CorrectAnswer currentQuestion;
  final int selectedOption;
  final bool isCorrect;
  final bool isWrong;
  final int score;
  final int timeLeft;
  final bool isPaused;
  final int questionNumber;
  final int totalQuestions;

  CorrectAnswerState({
    required this.currentQuestion,
    this.selectedOption = -1,
    this.isCorrect = false,
    this.isWrong = false,
    this.score = 0,
    this.timeLeft = 30,
    this.isPaused = false,
    this.questionNumber = 1,
    this.totalQuestions = 10,
  });

  CorrectAnswerState copyWith({
    CorrectAnswer? currentQuestion,
    int? selectedOption,
    bool? isCorrect,
    bool? isWrong,
    int? score,
    int? timeLeft,
    bool? isPaused,
    int? questionNumber,
    int? totalQuestions,
  }) {
    return CorrectAnswerState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedOption: selectedOption ?? this.selectedOption,
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
