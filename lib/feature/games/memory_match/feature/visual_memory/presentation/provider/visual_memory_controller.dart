import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/controller/memory_match_controller.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import '../state/visual_memory_state.dart';

class VisualMemoryController extends MemoryMatchController<MemoryCard<Color>, MemoryMatchResult, VisualMemoryState> {
  final DifficultyType difficulty;
  Timer? _flashTimer;
  Timer? _gameTimer;
  Timer? _countdownTimer;
  
  VisualMemoryController(this.difficulty) 
    : super(VisualMemoryState(
        cards: const [],
        status: VisualMemoryStatus.initial,
        difficulty: difficulty,
        totalPairs: difficulty == DifficultyType.easy ? 6 : (difficulty == DifficultyType.medium ? 8 : 10),
      ));
  
  @override
  void initializeGame() {
    generateNewGame();
  }
  
  @override
  void generateNewGame() {
    // Generate pairs based on difficulty
    final int pairCount = difficulty == DifficultyType.easy 
        ? 6 
        : (difficulty == DifficultyType.medium ? 8 : 10);
        
    // Generate visual cards with color pairs
    final List<MemoryCard<Color>> cards = VisualMemoryGenerator.generateVisualCards(
      difficulty, 
      pairCount * 2
    );
    
    // Update state with new game
    state = state.copyWith(
      cards: cards,
      totalPairs: pairCount,
      matchesFound: 0,
      moveCount: 0,
      timeInSeconds: 0,
      status: VisualMemoryStatus.initial,
      clearFirstSelected: true,
      clearSecondSelected: true,
    );
  }
    @override
  void startGame() {
    // Start the countdown
    updateState(status: VisualMemoryStatus.ready);
    
    // Start the countdown
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
      status: VisualMemoryStatus.playing,
      timeInSeconds: 0,
      moveCount: 0,
      matchesFound: 0,
    );
    
    // Flash all cards initially
    _flashAllCards();
    
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
  
  void _flashAllCards() {
    // Show all cards
    final List<MemoryCard<Color>> flashedCards = state.cards.map(
      (card) => card.copyWith(isFlipped: true)
    ).toList();
    
    state = state.copyWith(cards: flashedCards, isShowingAll: true);
    
    // Hide the cards after a delay based on difficulty
    final flashTime = difficulty == DifficultyType.easy 
        ? 4000 
        : (difficulty == DifficultyType.medium ? 3000 : 2000);
        
    _flashTimer = Timer(Duration(milliseconds: flashTime), () {
      final List<MemoryCard<Color>> hiddenCards = state.cards.map(
        (card) => card.copyWith(isFlipped: false)
      ).toList();
      
      state = state.copyWith(cards: hiddenCards, isShowingAll: false);
    });
  }
  
  @override
  void handleCardTap(int index) {
    // Ignore if all cards are being shown
    if (state.isShowingAll) {
      return;
    }
    
    // Ignore if card is already matched or flipped
    if (state.cards[index].isMatched || state.cards[index].isFlipped) {
      return;
    }
    
    // First selection
    if (state.firstSelectedIndex == null) {
      _flipCard(index);
      state = state.copyWith(firstSelectedIndex: index);
      return;
    }
    
    // Ignore if same card is tapped twice
    if (index == state.firstSelectedIndex) {
      return;
    }
    
    // Second selection
    _flipCard(index);
    state = state.copyWith(secondSelectedIndex: index, moveCount: state.moveCount + 1);
    
    // Check if the pair matches
    _checkMatch();
  }
  
  void _flipCard(int index) {
    final List<MemoryCard<Color>> updatedCards = List.from(state.cards);
    updatedCards[index] = updatedCards[index].copyWith(isFlipped: true);
    state = state.copyWith(cards: updatedCards);
  }
  
  void _checkMatch() {
    // Delay to show the second card before checking
    Timer(const Duration(milliseconds: 800), () {
      if (state.firstSelectedIndex == null || state.secondSelectedIndex == null) {
        return;
      }
      
      final firstCard = state.cards[state.firstSelectedIndex!];
      final secondCard = state.cards[state.secondSelectedIndex!];
      
      // Check for color match
      final isMatch = firstCard.value == secondCard.value;
      
      final List<MemoryCard<Color>> updatedCards = List.from(state.cards);
      
      if (isMatch) {
        // Mark cards as matched
        updatedCards[state.firstSelectedIndex!] = updatedCards[state.firstSelectedIndex!]
            .copyWith(isMatched: true, isFlipped: true);
        updatedCards[state.secondSelectedIndex!] = updatedCards[state.secondSelectedIndex!]
            .copyWith(isMatched: true, isFlipped: true);
            
        final newMatchesFound = state.matchesFound + 1;
        
        state = state.copyWith(
          cards: updatedCards,
          matchesFound: newMatchesFound,
          clearFirstSelected: true,
          clearSecondSelected: true,
        );
        
        // Check if game is completed
        if (newMatchesFound >= state.totalPairs) {
          _completeGame();
        }
      } else {
        // Flip cards back
        updatedCards[state.firstSelectedIndex!] = updatedCards[state.firstSelectedIndex!]
            .copyWith(isFlipped: false);
        updatedCards[state.secondSelectedIndex!] = updatedCards[state.secondSelectedIndex!]
            .copyWith(isFlipped: false);
            
        state = state.copyWith(
          cards: updatedCards,
          clearFirstSelected: true,
          clearSecondSelected: true,
        );
      }
    });
  }
  
  void _completeGame() {
    // Calculate score
    final int baseScore = difficulty == DifficultyType.easy 
        ? 150 
        : (difficulty == DifficultyType.medium ? 250 : 400);
        
    // Bonus for faster time
    final int timeBonus = max(0, 300 - (state.timeInSeconds * 2));
    
    // Bonus for fewer moves
    final int moveBonus = max(0, 300 - ((state.moveCount - state.totalPairs) * 10));
    
    final int totalScore = baseScore + timeBonus + moveBonus;
    
    // Calculate accuracy
    final double accuracy = (state.totalPairs * 2) / state.moveCount;
    final double accuracyPercentage = (accuracy * 100).clamp(0, 100);
    
    // Create result
    final result = MemoryMatchResult(
      score: totalScore,
      timeInSeconds: state.timeInSeconds,
      matchesFound: state.totalPairs,
      totalMoves: state.moveCount,
      accuracyPercentage: accuracyPercentage,
    );
    
    state = state.copyWith(
      status: VisualMemoryStatus.completed,
      result: result,
    );
  }
  
  @override
  void resetToInitialState() {
    _flashTimer?.cancel();
    _flashTimer = null;
    
    state = VisualMemoryState(
      cards: const [],
      status: VisualMemoryStatus.initial,
      difficulty: difficulty,
      totalPairs: difficulty == DifficultyType.easy ? 6 : (difficulty == DifficultyType.medium ? 8 : 10),
    );
  }
  
  @override
  void dispose() {
    _flashTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }
  
  // Implement abstract methods from MemoryMatchController
  @override
  void updateCards(List<MemoryCard<Color>> cards) {
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
  
  // State update helpers
  void updateCountdown(int countdown) {
    state = state.copyWith(countdown: countdown);
  }
  
  void updateTimeInSeconds(int timeInSeconds) {
    state = state.copyWith(timeInSeconds: timeInSeconds);
  }
  
  @override
  void updateState({
    List<MemoryCard<Color>>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    VisualMemoryStatus? status,
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
}
