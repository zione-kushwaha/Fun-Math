import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/domain/model/square_root.dart';

enum SquareRootStatus {
  initial,
  playing,
  paused,
  completed,
}

class SquareRootState {
  final SquareRoot? currentProblem;
  final List<bool> questionResults; // True if answered correctly
  final int correctAnswers;
  final int incorrectAnswers;
  final int score;
  final int timeInSeconds;
  final SquareRootStatus status;
  final DifficultyType difficulty;
  final bool soundEnabled;
  final int? selectedAnswerIndex;
  final String? errorMessage;
  final bool showHelp;
  final bool showWrongAnswerAnimation;
  
  const SquareRootState({
    this.currentProblem,
    this.questionResults = const [],
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.score = 0,
    this.timeInSeconds = 0,
    this.status = SquareRootStatus.initial,
    this.difficulty = DifficultyType.easy,
    this.soundEnabled = true,
    this.selectedAnswerIndex,
    this.errorMessage,
    this.showHelp = false,
    this.showWrongAnswerAnimation = false,
  });
  
  bool get isInitial => status == SquareRootStatus.initial;
  bool get isPlaying => status == SquareRootStatus.playing;
  bool get isPaused => status == SquareRootStatus.paused;
  bool get isCompleted => status == SquareRootStatus.completed;
  
  SquareRootState copyWith({
    SquareRoot? currentProblem,
    List<bool>? questionResults,
    int? correctAnswers,
    int? incorrectAnswers,
    int? score,
    int? timeInSeconds,
    SquareRootStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    int? selectedAnswerIndex,
    String? errorMessage,
    bool? showHelp,
    bool? showWrongAnswerAnimation,
  }) {
    return SquareRootState(
      currentProblem: currentProblem ?? this.currentProblem,
      questionResults: questionResults ?? this.questionResults,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      score: score ?? this.score,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      selectedAnswerIndex: selectedAnswerIndex,
      errorMessage: errorMessage,
      showHelp: showHelp ?? this.showHelp,
      showWrongAnswerAnimation: showWrongAnswerAnimation ?? this.showWrongAnswerAnimation,
    );
  }
}
