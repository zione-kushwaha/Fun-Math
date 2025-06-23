import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/state/memory_match_state.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';

typedef SequenceMatchStatus = MemoryMatchStatus;

// Represents a number in a sequence
class SequenceItem {
  final int id;
  final int value;
  final bool isSelected;
  final bool isMatched;
  final bool isHighlighted; // For highlighting pattern next values

  const SequenceItem({
    required this.id,
    required this.value,
    this.isSelected = false,
    this.isMatched = false,
    this.isHighlighted = false,
  });

  SequenceItem copyWith({
    int? id,
    int? value,
    bool? isSelected,
    bool? isMatched,
    bool? isHighlighted,
  }) {
    return SequenceItem(
      id: id ?? this.id,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
      isMatched: isMatched ?? this.isMatched,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}

class SequenceMatchState extends MemoryMatchState<SequenceItem, MemoryMatchResult> {
  final List<List<int>> sequences; // All sequences in the level
  final List<List<int>> answers; // Correct answers for each sequence
  final int currentSequenceIndex; // Current sequence being solved
  final List<int> selectedAnswers; // User selected answers
  final int level; // Current level of the game

  const SequenceMatchState({
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
    this.sequences = const [],
    this.answers = const [],
    this.currentSequenceIndex = 0,
    this.selectedAnswers = const [],
    this.level = 1, // Default to level 1
  });
  SequenceMatchState copyWith({
    List<SequenceItem>? cards,
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
    List<List<int>>? sequences,
    List<List<int>>? answers,
    int? currentSequenceIndex,
    List<int>? selectedAnswers,
    int? level,
  }) {
    return SequenceMatchState(
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
      sequences: sequences ?? this.sequences,
      answers: answers ?? this.answers,
      currentSequenceIndex: currentSequenceIndex ?? this.currentSequenceIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      level: level ?? this.level,
    );
  }

  // Current sequence being solved
  List<int> get currentSequence => 
      currentSequenceIndex < sequences.length ? sequences[currentSequenceIndex] : [];
      
  // Correct answer for current sequence
  List<int> get currentAnswer => 
      currentSequenceIndex < answers.length ? answers[currentSequenceIndex] : [];
      
  // Whether the current sequence is complete
  bool get isCurrentSequenceComplete =>
      selectedAnswers.length >= 2; // Need at least 2 answers to complete a sequence
        // Whether all sequences are complete
  bool get areAllSequencesComplete =>
      currentSequenceIndex >= sequences.length - 1 && isCurrentSequenceComplete;
        // Whether the game is in the input phase where user selects answers
  bool get isInputPhase => status == MemoryMatchStatus.playing && selectedAnswers.length < 2;
    // Alias for currentSequence to match the UI references
  List<int> get sequence => currentSequence;
    // Another alias for isInputPhase used in the UI
  bool get showInputPhase => isInputPhase;
  
  // Alias for cards to match the UI reference
  List<SequenceItem> get optionCards => cards;
}
