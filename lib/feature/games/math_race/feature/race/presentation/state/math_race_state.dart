import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/race/domain/model/math_race.dart';

enum MathRaceStatus {
  initial,
  ready,
  playing,
  paused,
  completed,
}

class MathRaceState {
  final MathProblem? currentProblem;
  final List<bool> questionResults; // True if answered correctly
  final int correctAnswers;
  final int incorrectAnswers;
  final int score;
  final int timeInSeconds;
  final MathRaceStatus status;
  final DifficultyType difficulty;
  final bool soundEnabled;
  final int? selectedOptionIndex;
  final String? errorMessage;
  final bool showHelp;
  final RaceProgress raceProgress;
  final MathRaceResult? result;
  final int countdown; // For ready-set-go countdown
  
  const MathRaceState({
    this.currentProblem,
    this.questionResults = const [],
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.score = 0,
    this.timeInSeconds = 0,
    this.status = MathRaceStatus.initial,
    this.difficulty = DifficultyType.easy,
    this.soundEnabled = true,
    this.selectedOptionIndex,
    this.errorMessage,
    this.showHelp = false,
    this.raceProgress = const RaceProgress(),
    this.result,
    this.countdown = 3,
  });
  
  bool get isInitial => status == MathRaceStatus.initial;
  bool get isReady => status == MathRaceStatus.ready;
  bool get isPlaying => status == MathRaceStatus.playing;
  bool get isPaused => status == MathRaceStatus.paused;
  bool get isCompleted => status == MathRaceStatus.completed;
  int get totalQuestions => correctAnswers + incorrectAnswers;
  bool get isRaceFinished => raceProgress.isRaceFinished;
  bool get isPlayerWinner => raceProgress.isPlayerWinner;
  
  MathRaceState copyWith({
    MathProblem? currentProblem,
    List<bool>? questionResults,
    int? correctAnswers,
    int? incorrectAnswers,
    int? score,
    int? timeInSeconds,
    MathRaceStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    int? selectedOptionIndex,
    String? errorMessage,
    bool? showHelp,
    RaceProgress? raceProgress,
    MathRaceResult? result,
    int? countdown,
  }) {
    return MathRaceState(
      currentProblem: currentProblem ?? this.currentProblem,
      questionResults: questionResults ?? this.questionResults,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      score: score ?? this.score,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      showHelp: showHelp ?? this.showHelp,
      raceProgress: raceProgress ?? this.raceProgress,
      result: result ?? this.result,
      countdown: countdown ?? this.countdown,
    );
  }
}
