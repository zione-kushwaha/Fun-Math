import 'dart:async';
import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/controller/memory_match_controller.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import '../state/sequence_match_state.dart';

class SequenceMatchController extends MemoryMatchController<SequenceItem, MemoryMatchResult, SequenceMatchState> {
  final DifficultyType difficulty;
  final Random _random = Random();
  Timer? _gameTimer;
  Timer? _countdownTimer;
  
  SequenceMatchController(this.difficulty) 
    : super(SequenceMatchState(
        cards: const [],
        status: SequenceMatchStatus.initial,
        difficulty: difficulty,
        totalPairs: difficulty == DifficultyType.easy ? 3 : (difficulty == DifficultyType.medium ? 5 : 7),
      ));
  
  @override
  void initializeGame() {
    // Generate sequences and answers
    final sequencePairs = _generateSequencePairs();
    final sequences = sequencePairs.map((pair) => pair.question).toList();
    final answers = sequencePairs.map((pair) => pair.answer).toList();
    
    // Generate answer options (including correct ones)
    final List<SequenceItem> answerCards = _generateAnswerOptions(sequences, answers);
      state = state.copyWith(
      cards: answerCards,
      sequences: sequences,
      answers: answers,
      currentSequenceIndex: 0,
      selectedAnswers: const [],
      moveCount: 0,
      matchesFound: 0,
      timeInSeconds: 0,
      level: 1, // Initialize at level 1
    );
  }
  
  List<MemoryPair<List<int>, List<int>>> _generateSequencePairs() {
    final pairCount = difficulty == DifficultyType.easy ? 3 : (difficulty == DifficultyType.medium ? 5 : 7);
    return SequenceMatchGenerator.generateSequencePairs(difficulty, pairCount);
  }
  
  List<SequenceItem> _generateAnswerOptions(List<List<int>> sequences, List<List<int>> answers) {
    final allPossibleAnswers = <int>{};
    
    // Add all correct answers
    for (final answer in answers) {
      allPossibleAnswers.addAll(answer);
    }
    
    // Add some misleading options
    final int extraOptions = difficulty == DifficultyType.easy ? 2 : (difficulty == DifficultyType.medium ? 4 : 6);
    final maxValue = 50; // Maximum value for a misleading option
    
    while (allPossibleAnswers.length < answers.length * 2 + extraOptions) {
      allPossibleAnswers.add(_random.nextInt(maxValue) + 1);
    }
    
    // Create sequence items
    final List<SequenceItem> items = [];
    int id = 0;
    
    for (final value in allPossibleAnswers) {
      items.add(SequenceItem(
        id: id++,
        value: value,
      ));
    }
    
    // Shuffle the items
    items.shuffle(_random);
    
    return items;
  }
  
  @override
  void generateNewGame() {
    initializeGame();
  }
  
  @override
  void startGame() {
    // Start the countdown
    updateState(status: SequenceMatchStatus.ready);
    
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.countdown > 1) {
          updateCountdown(state.countdown - 1);
        } else {
          _countdownTimer?.cancel();
          _startGameAfterCountdown();
        }
      },
    );
  }
  
  void _startGameAfterCountdown() {
    // Start with clean state
    updateState(
      status: SequenceMatchStatus.playing,
      timeInSeconds: 0,
      moveCount: 0,
      matchesFound: 0,
    );
    
    // Start the game timer
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.isPlaying) {
          updateTimeInSeconds(state.timeInSeconds + 1);
        }
      },
    );
  }
  
  @override
  void handleCardTap(int index) {
    // Ignore if we're not playing or card is already selected
    if (!state.isPlaying || state.cards[index].isSelected || state.cards[index].isMatched) {
      return;
    }
    
    // Get the selected value
    final selectedValue = state.cards[index].value;
    
    // Add to selected answers
    final newSelectedAnswers = [...state.selectedAnswers, selectedValue];
    
    // Mark card as selected
    final updatedCards = List<SequenceItem>.from(state.cards);
    updatedCards[index] = updatedCards[index].copyWith(isSelected: true);
    
    // Update state
    state = state.copyWith(
      cards: updatedCards,
      selectedAnswers: newSelectedAnswers,
      moveCount: state.moveCount + 1,
    );
    
    // Check if we have enough answers (2) to check the sequence
    if (newSelectedAnswers.length >= 2) {
      _checkAnswer();
    }
  }
  
  void _checkAnswer() {
    // Delay to show the selected answers before checking
    Timer(const Duration(milliseconds: 1000), () {
      final currentAnswers = state.currentAnswer;
      final selectedAnswers = state.selectedAnswers;
      
      // Check if selected answers match the expected next values in the sequence
      final isCorrect = currentAnswers.length == selectedAnswers.length && 
          currentAnswers.every((element) => selectedAnswers.contains(element));
      
      if (isCorrect) {
        // Mark selected cards as matched
        final updatedCards = List<SequenceItem>.from(state.cards);
        
        for (int i = 0; i < updatedCards.length; i++) {
          if (updatedCards[i].isSelected && !updatedCards[i].isMatched) {
            updatedCards[i] = updatedCards[i].copyWith(
              isSelected: false,
              isMatched: true,
              isHighlighted: true,
            );
          }
        }
        
        final newMatchesFound = state.matchesFound + 1;
        
        // Move to next sequence or complete game
        if (state.currentSequenceIndex < state.sequences.length - 1) {
          state = state.copyWith(
            cards: updatedCards,
            matchesFound: newMatchesFound,
            currentSequenceIndex: state.currentSequenceIndex + 1,
            selectedAnswers: const [],
          );
          
          // Clear highlighted status after a moment
          Timer(const Duration(milliseconds: 1000), () {
            final clearedCards = List<SequenceItem>.from(state.cards);
            for (int i = 0; i < clearedCards.length; i++) {
              if (clearedCards[i].isHighlighted) {
                clearedCards[i] = clearedCards[i].copyWith(isHighlighted: false);
              }
            }
            state = state.copyWith(cards: clearedCards);
          });
            } else {
          // Game completed - Update level
          state = state.copyWith(
            cards: updatedCards,
            matchesFound: newMatchesFound,
            level: state.level + 1, // Increment the level
          );
          
          _completeGame(true);
        }
      } else {
        // Wrong answer - Clear selected status
        final updatedCards = List<SequenceItem>.from(state.cards);
        
        for (int i = 0; i < updatedCards.length; i++) {
          if (updatedCards[i].isSelected && !updatedCards[i].isMatched) {
            updatedCards[i] = updatedCards[i].copyWith(isSelected: false);
          }
        }
        
        state = state.copyWith(
          cards: updatedCards,
          selectedAnswers: const [],
        );
      }
    });
  }
  
  void _completeGame(bool won) {
    // Calculate score
    final int baseScore = difficulty == DifficultyType.easy 
        ? 150 
        : (difficulty == DifficultyType.medium ? 250 : 400);
        
    // Bonus for more matches
    final matchBonus = state.matchesFound * 50;
    
    // Speed bonus
    final speedBonus = max(0, 500 - (state.timeInSeconds * 5));
    
    // Efficiency bonus (fewer moves)
    final efficiencyBonus = max(0, 500 - (state.moveCount - state.totalPairs * 2) * 10);
    
    final int totalScore = baseScore + matchBonus + speedBonus + efficiencyBonus;
    
    // Calculate accuracy
    final double accuracy = state.matchesFound / max(1, state.totalPairs);
    final double accuracyPercentage = (accuracy * 100).clamp(0, 100);
    
    // Create result
    final result = MemoryMatchResult(
      score: totalScore,
      timeInSeconds: state.timeInSeconds,
      matchesFound: state.matchesFound,
      totalMoves: state.moveCount,
      accuracyPercentage: accuracyPercentage,
    );
    
    state = state.copyWith(
      status: SequenceMatchStatus.completed,
      result: result,
    );
  }
  
  @override
  void resetToInitialState() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    
    state = SequenceMatchState(
      cards: const [],
      status: SequenceMatchStatus.initial,
      difficulty: difficulty,
      totalPairs: difficulty == DifficultyType.easy ? 3 : (difficulty == DifficultyType.medium ? 5 : 7),
    );
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  // Implement abstract methods from MemoryMatchController
  @override
  void updateCards(List<SequenceItem> cards) {
    state = state.copyWith(cards: cards);
  }
  
  @override
  void updateMatchesFound(int matchesFound) {
    state = state.copyWith(matchesFound: matchesFound);
  }
  
  @override
  void updateMoveCount(int moveCount) {
    state = state.copyWith(moveCount: moveCount);
  }
  
  @override
  void updateState({
    List<SequenceItem>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    SequenceMatchStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    MemoryMatchResult? result,
    String? errorMessage,
    bool? showHelp,
    int? selectedCardIndex,
    int? countdown,
    bool? isAnimatingCard,
  }) {
    state = state.copyWith(
      cards: cards,
      moveCount: moveCount,
      matchesFound: matchesFound,
      totalPairs: totalPairs,
      timeInSeconds: timeInSeconds,
      status: status,
      difficulty: difficulty,
      soundEnabled: soundEnabled,
      result: result,
      errorMessage: errorMessage,
      showHelp: showHelp,
      selectedCardIndex: selectedCardIndex,
      countdown: countdown,
    );
  }
  
  // Helper methods
  void updateCountdown(int countdown) {
    state = state.copyWith(countdown: countdown);
  }
  
  void updateTimeInSeconds(int timeInSeconds) {
    state = state.copyWith(timeInSeconds: timeInSeconds);
  }
}
