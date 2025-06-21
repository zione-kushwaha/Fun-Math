import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/domain/model/number_puzzle.dart';

enum PuzzleStatus {
  initial,
  playing,
  paused,
  completed,
}

class NumberPuzzleState {
  final NumberPuzzleModel puzzle;
  final PuzzleStatus status;
  final int moveCount;
  final int timeInSeconds;
  final int? score;
  final bool showHelp;
  final bool soundEnabled;
  final PuzzleResult? result;
  final bool animationEnabled;

  const NumberPuzzleState({
    required this.puzzle,
    this.status = PuzzleStatus.initial,
    this.moveCount = 0,
    this.timeInSeconds = 0,
    this.score,
    this.showHelp = false,
    this.soundEnabled = true,
    this.result,
    this.animationEnabled = true,
  });

  NumberPuzzleState copyWith({
    NumberPuzzleModel? puzzle,
    PuzzleStatus? status,
    int? moveCount,
    int? timeInSeconds,
    int? score,
    bool? showHelp,
    bool? soundEnabled,
    PuzzleResult? result,
    bool? animationEnabled,
  }) {
    return NumberPuzzleState(
      puzzle: puzzle ?? this.puzzle,
      status: status ?? this.status,
      moveCount: moveCount ?? this.moveCount,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      score: score ?? this.score,
      showHelp: showHelp ?? this.showHelp,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      result: result ?? this.result,
      animationEnabled: animationEnabled ?? this.animationEnabled,
    );
  }
}
