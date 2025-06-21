import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/domain/model/math_memory.dart';

enum MathMemoryStatus {
  initial,
  playing,
  paused,
  completed,
}

class MathMemoryState {
  final List<MathMemoryCard> cards;
  final List<MathPair> pairs;
  final MathMemoryStatus status;
  final int timeInSeconds;
  final int moveCount;
  final int matchesFound;
  final MathMemoryResult? result;
  final bool showHelp;
  final bool soundEnabled;
  final MathMemoryCard? firstSelectedCard;
  final MathMemoryCard? secondSelectedCard;
  final bool isChecking;
  final bool animationEnabled;

  const MathMemoryState({
    required this.cards,
    required this.pairs,
    this.status = MathMemoryStatus.initial,
    this.timeInSeconds = 0,
    this.moveCount = 0,
    this.matchesFound = 0,
    this.result,
    this.showHelp = false,
    this.soundEnabled = true,
    this.firstSelectedCard,
    this.secondSelectedCard,
    this.isChecking = false,
    this.animationEnabled = true,
  });

  MathMemoryState copyWith({
    List<MathMemoryCard>? cards,
    List<MathPair>? pairs,
    MathMemoryStatus? status,
    int? timeInSeconds,
    int? moveCount,
    int? matchesFound,
    MathMemoryResult? result,
    bool? showHelp,
    bool? soundEnabled,
    MathMemoryCard? firstSelectedCard,
    MathMemoryCard? secondSelectedCard,
    bool? isChecking,
    bool? animationEnabled,
  }) {
    return MathMemoryState(
      cards: cards ?? this.cards,
      pairs: pairs ?? this.pairs,
      status: status ?? this.status,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      moveCount: moveCount ?? this.moveCount,
      matchesFound: matchesFound ?? this.matchesFound,
      result: result ?? this.result,
      showHelp: showHelp ?? this.showHelp,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      firstSelectedCard: firstSelectedCard,
      secondSelectedCard: secondSelectedCard,
      isChecking: isChecking ?? this.isChecking,
      animationEnabled: animationEnabled ?? this.animationEnabled,
    );
  }

  bool get isPaused => status == MathMemoryStatus.paused;
  bool get isPlaying => status == MathMemoryStatus.playing;
  bool get isCompleted => status == MathMemoryStatus.completed;
  
  // Get total number of pairs to find
  int get totalPairs => pairs.length;
  
  // Check if the game is over
  bool get isGameOver => matchesFound == totalPairs;

  @override
  String toString() {
    return 'MathMemoryState{cards: ${cards.length}, status: $status, timeInSeconds: $timeInSeconds, '
        'moveCount: $moveCount, matchesFound: $matchesFound}';
  }
}
