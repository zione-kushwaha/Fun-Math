import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/state/memory_match_state.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';

typedef SpeedMemoryStatus = MemoryMatchStatus;

// Speed Memory displays a sequence of numbers/symbols briefly and players must recall them
class SpeedMemoryCard {
  final int id;
  final String value;
  final bool isCorrect; // Whether player selected correctly
  final bool isSelected; // Whether player has selected this card
  final bool isRevealed; // Whether card is currently revealed in animation

  const SpeedMemoryCard({
    required this.id,
    required this.value,
    this.isCorrect = false,
    this.isSelected = false,
    this.isRevealed = false,
  });

  SpeedMemoryCard copyWith({
    int? id,
    String? value,
    bool? isCorrect,
    bool? isSelected,
    bool? isRevealed,
  }) {
    return SpeedMemoryCard(
      id: id ?? this.id,
      value: value ?? this.value,
      isCorrect: isCorrect ?? this.isCorrect,
      isSelected: isSelected ?? this.isSelected,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }
}

class SpeedMemoryState extends MemoryMatchState<SpeedMemoryCard, MemoryMatchResult> {
  final List<String> sequence; // The current sequence to remember
  final List<String> playerSequence; // The sequence entered by the player
  final int level; // Current level
  final int sequenceLength; // Length of current sequence
  final bool isShowingSequence; // Whether sequence is being displayed
  final int flashDuration; // How long each item is shown (milliseconds)
  final int currentIndexShowing; // Index currently being shown
  final bool isInputPhase; // Whether player can input now

  const SpeedMemoryState({
    super.cards = const [],
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
    this.sequence = const [],
    this.playerSequence = const [],
    this.level = 1,
    this.sequenceLength = 3,
    this.isShowingSequence = false,
    this.flashDuration = 1000,
    this.currentIndexShowing = -1,
    this.isInputPhase = false,
  });

  SpeedMemoryState copyWith({
    List<SpeedMemoryCard>? cards,
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
    List<String>? sequence,
    List<String>? playerSequence,
    int? level,
    int? sequenceLength,
    bool? isShowingSequence,
    int? flashDuration,
    int? currentIndexShowing,
    bool? isInputPhase,
  }) {
    return SpeedMemoryState(
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
      sequence: sequence ?? this.sequence,
      playerSequence: playerSequence ?? this.playerSequence,
      level: level ?? this.level,
      sequenceLength: sequenceLength ?? this.sequenceLength,
      isShowingSequence: isShowingSequence ?? this.isShowingSequence,
      flashDuration: flashDuration ?? this.flashDuration,
      currentIndexShowing: currentIndexShowing ?? this.currentIndexShowing,
      isInputPhase: isInputPhase ?? this.isInputPhase,
    );
  }

  bool get isSequenceComplete => playerSequence.length == sequence.length;
  
  bool get isCorrectSequence {
    if (playerSequence.length != sequence.length) return false;
    
    for (int i = 0; i < sequence.length; i++) {
      if (playerSequence[i] != sequence[i]) {
        return false;
      }
    }
    
    return true;
  }
}
