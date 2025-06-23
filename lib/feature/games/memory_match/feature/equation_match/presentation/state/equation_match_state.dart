import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/state/memory_match_state.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';

typedef EquationMatchStatus = MemoryMatchStatus;

class EquationMatchState extends MemoryMatchState<MemoryCard<dynamic>, MemoryMatchResult> {
  final List<MemoryPair<String, int>> pairs;
  final int? firstSelectedIndex;
  final int? secondSelectedIndex;

  const EquationMatchState({
    required super.cards,
    super.moveCount = 0,
    super.matchesFound = 0,
    super.totalPairs = 0,
    super.timeInSeconds = 0,
    super.status = MemoryMatchStatus.initial,
    super.difficulty = DifficultyType.easy,
    super.soundEnabled = true,
    super.result,
    super.errorMessage,
    super.showHelp = false,
    super.selectedCardIndex,
    super.countdown = 3,
    this.pairs = const [],
    this.firstSelectedIndex,
    this.secondSelectedIndex,
  });

  EquationMatchState copyWith({
    List<MemoryCard<dynamic>>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    MemoryMatchStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    MemoryMatchResult? result,
    String? errorMessage,
    bool? showHelp,
    int? selectedCardIndex,
    int? countdown,
    List<MemoryPair<String, int>>? pairs,
    int? firstSelectedIndex,
    int? secondSelectedIndex,
    bool clearFirstSelected = false,
    bool clearSecondSelected = false,
  }) {
    return EquationMatchState(
      cards: cards ?? this.cards,
      moveCount: moveCount ?? this.moveCount,
      matchesFound: matchesFound ?? this.matchesFound,
      totalPairs: totalPairs ?? this.totalPairs,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      showHelp: showHelp ?? this.showHelp,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      countdown: countdown ?? this.countdown,
      pairs: pairs ?? this.pairs,
      firstSelectedIndex: clearFirstSelected ? null : (firstSelectedIndex ?? this.firstSelectedIndex),
      secondSelectedIndex: clearSecondSelected ? null : (secondSelectedIndex ?? this.secondSelectedIndex),
    );
  }
}
