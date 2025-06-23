import 'package:fun_math/core/data/difficulty_type.dart';

enum MemoryMatchStatus {
  initial,
  ready,
  playing,
  paused,
  completed,
}

/// Base state class that can be extended by specific memory match games
class MemoryMatchState<T, U> {
  final List<T> cards;
  final int moveCount;
  final int matchesFound;
  final int totalPairs;
  final int timeInSeconds;
  final MemoryMatchStatus status;
  final DifficultyType difficulty;
  final bool soundEnabled;
  final U? result;
  final String? errorMessage;
  final bool showHelp;
  final int? selectedCardIndex;
  final int countdown;
  
  const MemoryMatchState({
    this.cards = const [],
    this.moveCount = 0,
    this.matchesFound = 0,
    this.totalPairs = 0,
    this.timeInSeconds = 0,
    this.status = MemoryMatchStatus.initial,
    this.difficulty = DifficultyType.easy,
    this.soundEnabled = true,
    this.result,
    this.errorMessage,
    this.showHelp = false,
    this.selectedCardIndex,
    this.countdown = 3,
  });
  
  bool get isInitial => status == MemoryMatchStatus.initial;
  bool get isReady => status == MemoryMatchStatus.ready;
  bool get isPlaying => status == MemoryMatchStatus.playing;
  bool get isPaused => status == MemoryMatchStatus.paused;
  bool get isCompleted => status == MemoryMatchStatus.completed;
  bool get allMatched => matchesFound == totalPairs;
}
