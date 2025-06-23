import 'dart:async';
import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/controller/memory_match_controller.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import 'package:fun_math/feature/games/memory_match/feature/number_match/presentation/state/number_match_state.dart';

class NumberMatchController extends MemoryMatchController<MemoryCard<int>, MemoryMatchResult, NumberMatchState> {
  final DifficultyType difficulty;
  Timer? _gameTimer;
  final Random _random = Random();

  NumberMatchController(this.difficulty)
      : super(const NumberMatchState());

  @override
  void initializeGame() {
    // Generate pairs based on difficulty
    final totalPairs = difficulty == DifficultyType.easy
        ? 8  // 16 cards
        : (difficulty == DifficultyType.medium ? 12 : 18);  // 24 or 36 cards
            
    final cards = _generateNumberCards(totalPairs);
    
    state = NumberMatchState(
      cards: cards,
      moveCount: 0, 
      matchesFound: 0,
      totalPairs: totalPairs,
      timeInSeconds: 0,
      difficulty: difficulty,
      status: NumberMatchStatus.initial,
    );
  }

  List<MemoryCard<int>> _generateNumberCards(int pairCount) {
    final List<MemoryCard<int>> cards = [];
    final List<int> values = [];
    
    // Generate values based on difficulty
    final int maxValue = difficulty == DifficultyType.easy
        ? 50
        : (difficulty == DifficultyType.medium ? 100 : 200);
        
    // Generate unique values
    while (values.length < pairCount) {
      final value = _random.nextInt(maxValue) + 1;
      if (!values.contains(value)) {
        values.add(value);
      }
    }
    
    // Create pairs of cards with matching values
    int id = 0;
    for (final value in values) {
      cards.add(MemoryCard<int>(id: id++, value: value));
      cards.add(MemoryCard<int>(id: id++, value: value));
    }
    
    // Shuffle the cards
    cards.shuffle(_random);
    
    return cards;
  }

  @override
  void generateNewGame() {
    initializeGame();
  }

  @override
  void startGame() {
    updateState(status: NumberMatchStatus.playing);
    
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
    // Ignore taps when the game is not in playing state or the card is already flipped
    if (!state.isPlaying || state.cards[index].isFlipped) return;
    
    // Get the tapped card
    final tappedCard = state.cards[index];
    
    // Update the card to show it's flipped
    final updatedCards = [...state.cards];
    updatedCards[index] = tappedCard.copyWith(isFlipped: true);
    
    // Update the state with the new cards and increment the move count
    updateCards(updatedCards);
    updateMoveCount(state.moveCount + 1);
    
    // Check if this is the first or second card flipped in the current move
    if (state.selectedCardIndex == null) {
      // This is the first card, just store its index
      updateState(selectedCardIndex: index);
    } else {
      // This is the second card, check for a match
      final firstCardIndex = state.selectedCardIndex!;
      final firstCard = state.cards[firstCardIndex];
      
      // Check if the cards match
      if (tappedCard.value == firstCard.value) {
        // Match found
        final newMatchesFound = state.matchesFound + 1;
        updateMatchesFound(newMatchesFound);
        
        // Reset selected card index
        updateState(selectedCardIndex: null);
        
        // Check if all matches have been found
        if (newMatchesFound == state.totalPairs) {
          _completeGame();
        }
      } else {
        // No match, flip the cards back after a delay
        Timer(const Duration(milliseconds: 1000), () {
          if (state.isPlaying) {
            final resetCards = [...state.cards];
            resetCards[firstCardIndex] = firstCard.copyWith(isFlipped: false);
            resetCards[index] = tappedCard.copyWith(isFlipped: false);
            updateCards(resetCards);
          }
          updateState(selectedCardIndex: null);
        });
      }
    }
  }
  
  void _completeGame() {
    // Calculate score based on moves, time and difficulty
    final int baseScore = difficulty == DifficultyType.easy
        ? 1000
        : (difficulty == DifficultyType.medium ? 1500 : 2000);
        
    // Less moves and faster time = more score
    final int movesPenalty = state.moveCount * 10;
    final int timePenalty = state.timeInSeconds * 5;
    
    final int score = max(baseScore - movesPenalty - timePenalty, 0);
    
    // Calculate perfect match ratio (matches/moves)
    final double perfectMatchRatio = state.totalPairs / (state.moveCount / 2);
    final int perfectMatches = (perfectMatchRatio * state.totalPairs).round();
    
    // Create result
    final result = MemoryMatchResult(
      score: score,
      timeInSeconds: state.timeInSeconds,
      matchesFound: state.matchesFound,
      totalMoves: state.moveCount,
      perfectMatchStreak: perfectMatches,
      accuracyPercentage: (perfectMatchRatio * 100).clamp(0, 100),
    );
    
    updateState(
      status: NumberMatchStatus.completed,
      result: result,
    );
    
    // Stop the timer
    _gameTimer?.cancel();
  }
  
  void pauseGame() {
    if (state.isPlaying) {
      updateState(status: NumberMatchStatus.paused);
    }
  }
  
  void resumeGame() {
    if (state.isPaused) {
      updateState(status: NumberMatchStatus.playing);
    }
  }
  
  void toggleHelp() {
    updateState(showHelp: !state.showHelp);
  }
  
  void toggleSound() {
    updateState(soundEnabled: !state.soundEnabled);
  }

  @override
  void resetGame() {
    _gameTimer?.cancel();
    generateNewGame();
  }

  @override
  void resetToInitialState() {
    resetGame();
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
  
  // Implement abstract methods from MemoryMatchController
  @override
  void updateCards(List<MemoryCard<int>> cards) {
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
    List<MemoryCard<int>>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    NumberMatchStatus? status,
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
    void updateTimeInSeconds(int timeInSeconds) {
    state = state.copyWith(timeInSeconds: timeInSeconds);
  }
  
  void updateCountdown(int countdown) {
    state = state.copyWith(countdown: countdown);
  }
}
