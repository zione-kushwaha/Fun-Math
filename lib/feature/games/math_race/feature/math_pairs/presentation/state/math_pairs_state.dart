import 'package:fun_math/feature/games/math_race/feature/math_pairs/domain/model/math_pairs.dart';

enum MathPairsStatus {
  initial,
  loading,
  playing,
  paused,
  gameOver,
}

class MathPairsState {
  final MathPairs? mathPairs;
  final MathPairsStatus status;
  final int score;
  final int highScore;
  final int timeLeft;
  final int firstSelectedIndex;
  final bool isFirstAttempt;

  const MathPairsState({
    this.mathPairs,
    this.status = MathPairsStatus.initial,
    this.score = 0,
    this.highScore = 0,
    this.timeLeft = 60,
    this.firstSelectedIndex = -1,
    this.isFirstAttempt = true,
  });
  MathPairsState copyWith({
    MathPairs? mathPairs,
    MathPairsStatus? status,
    int? score,
    int? highScore,
    int? timeLeft,
    int? firstSelectedIndex,
    bool? isFirstAttempt,
  }) {
    return MathPairsState(
      mathPairs: mathPairs ?? this.mathPairs,
      status: status ?? this.status,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      timeLeft: timeLeft ?? this.timeLeft,
      firstSelectedIndex: firstSelectedIndex ?? this.firstSelectedIndex,
      isFirstAttempt: isFirstAttempt ?? this.isFirstAttempt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MathPairsState &&
      other.mathPairs == mathPairs &&
      other.status == status &&
      other.score == score &&
      other.highScore == highScore &&
      other.timeLeft == timeLeft &&
      other.firstSelectedIndex == firstSelectedIndex &&
      other.isFirstAttempt == isFirstAttempt;
  }

  @override
  int get hashCode {
    return mathPairs.hashCode ^
      status.hashCode ^
      score.hashCode ^
      highScore.hashCode ^
      timeLeft.hashCode ^
      firstSelectedIndex.hashCode ^
      isFirstAttempt.hashCode;
  }
}
