import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/state/memory_match_state.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';

typedef PatternMemoryStatus = MemoryMatchStatus;

class PatternMemoryState extends MemoryMatchState<MemoryCard<bool>, MemoryMatchResult> {
  final int level;
  final List<bool> originalPattern;
  final List<List<bool>> patternOptions;
  final int selectedOptionIndex;
  final bool showOriginalPattern;
  final bool showOptions;
  final int flashTime; // Time in milliseconds to show pattern
  final int correctOptionIndex;

  const PatternMemoryState({
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
    this.level = 1,
    this.originalPattern = const [],
    this.patternOptions = const [],
    this.selectedOptionIndex = -1,
    this.showOriginalPattern = false,
    this.showOptions = false,
    this.flashTime = 3000,
    this.correctOptionIndex = -1,
  });

  PatternMemoryState copyWith({
    List<MemoryCard<bool>>? cards,
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
    int? level,
    List<bool>? originalPattern,
    List<List<bool>>? patternOptions,
    int? selectedOptionIndex,
    bool? showOriginalPattern,
    bool? showOptions,
    int? flashTime,
    int? correctOptionIndex,
  }) {
    return PatternMemoryState(
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
      level: level ?? this.level,
      originalPattern: originalPattern ?? this.originalPattern,
      patternOptions: patternOptions ?? this.patternOptions,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      showOriginalPattern: showOriginalPattern ?? this.showOriginalPattern,
      showOptions: showOptions ?? this.showOptions,
      flashTime: flashTime ?? this.flashTime,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
    );
  }
}
