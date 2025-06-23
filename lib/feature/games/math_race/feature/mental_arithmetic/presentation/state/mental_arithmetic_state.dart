import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/domain/model/mental_arithmetic.dart';

enum MentalArithmeticStatus {
  initial,
  playing,
  paused,
  completed,
}

class MentalArithmeticState {
  final MentalArithmetic? currentProblem;
  final String result; // User's current input
  final List<bool> questionResults; // True if answered correctly
  final int correctAnswers;
  final int incorrectAnswers;
  final int score;
  final int timeInSeconds;
  final MentalArithmeticStatus status;
  final DifficultyType difficulty;
  final bool soundEnabled;
  final String? errorMessage;
  final bool showHelp;
  final bool showWrongAnswerAnimation;
  
  const MentalArithmeticState({
    this.currentProblem,
    this.result = "",
    this.questionResults = const [],
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.score = 0,
    this.timeInSeconds = 0,
    this.status = MentalArithmeticStatus.initial,
    this.difficulty = DifficultyType.easy,
    this.soundEnabled = true,
    this.errorMessage,
    this.showHelp = false,
    this.showWrongAnswerAnimation = false,
  });
  
  bool get isInitial => status == MentalArithmeticStatus.initial;
  bool get isPlaying => status == MentalArithmeticStatus.playing;
  bool get isPaused => status == MentalArithmeticStatus.paused;
  bool get isCompleted => status == MentalArithmeticStatus.completed;
  
  MentalArithmeticState copyWith({
    MentalArithmetic? currentProblem,
    String? result,
    List<bool>? questionResults,
    int? correctAnswers,
    int? incorrectAnswers,
    int? score,
    int? timeInSeconds,
    MentalArithmeticStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    String? errorMessage,
    bool? showHelp,
    bool? showWrongAnswerAnimation,
  }) {
    return MentalArithmeticState(
      currentProblem: currentProblem ?? this.currentProblem,
      result: result ?? this.result,
      questionResults: questionResults ?? this.questionResults,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      score: score ?? this.score,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      errorMessage: errorMessage,
      showHelp: showHelp ?? this.showHelp,
      showWrongAnswerAnimation: showWrongAnswerAnimation ?? this.showWrongAnswerAnimation,
    );
  }
}
