import 'package:fun_math/feature/games/math_race/feature/math_grid/domain/model/math_grid.dart';

enum MathGridStatus {
  initial,
  loading,
  playing,
  paused,
  gameOver,
}

class MathGridState {
  final MathGrid? mathGrid;
  final MathGridStatus status;
  final int score;
  final int highScore;
  final int timeLeft;

  const MathGridState({
    this.mathGrid,
    this.status = MathGridStatus.initial,
    this.score = 0,
    this.highScore = 0,
    this.timeLeft = 60,
  });

  MathGridState copyWith({
    MathGrid? mathGrid,
    MathGridStatus? status,
    int? score,
    int? highScore,
    int? timeLeft,
  }) {
    return MathGridState(
      mathGrid: mathGrid ?? this.mathGrid,
      status: status ?? this.status,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      timeLeft: timeLeft ?? this.timeLeft,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MathGridState &&
      other.mathGrid == mathGrid &&
      other.status == status &&
      other.score == score &&
      other.highScore == highScore &&
      other.timeLeft == timeLeft;
  }

  @override
  int get hashCode {
    return mathGrid.hashCode ^
      status.hashCode ^
      score.hashCode ^
      highScore.hashCode ^
      timeLeft.hashCode;
  }
}
