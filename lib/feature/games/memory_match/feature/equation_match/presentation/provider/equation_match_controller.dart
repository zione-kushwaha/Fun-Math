import 'dart:async';
import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/controller/memory_match_controller.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import '../state/equation_match_state.dart';

class EquationMatchController extends MemoryMatchController<MemoryCard<dynamic>, MemoryMatchResult, EquationMatchState> {
  final DifficultyType difficulty;
  final Random _random = Random();
  
  EquationMatchController(this.difficulty) 
    : super(EquationMatchState(
        cards: const [],
        status: EquationMatchStatus.initial,
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
        
    // Generate equation pairs
    final pairs = EquationMatchGenerator.generateEquationPairs(difficulty, pairCount);
    
    // Create cards from pairs
    final List<MemoryCard<dynamic>> cards = [];
    
    // Create question cards
    for (int i = 0; i < pairs.length; i++) {
      cards.add(MemoryCard<String>(
        id: i * 2,
        value: pairs[i].question,
        isFlipped: false,
        isMatched: false,
      ));
    }
    
    // Create answer cards
    for (int i = 0; i < pairs.length; i++) {
      cards.add(MemoryCard<int>(
        id: i * 2 + 1,
        value: pairs[i].answer,
        isFlipped: false,
        isMatched: false,
      ));
    }
    
    // Shuffle cards
    cards.shuffle(_random);
    
    // Update state with new game
    state = state.copyWith(
      cards: cards,
      pairs: pairs,
      totalPairs: pairCount,
      matchesFound: 0,
      moveCount: 0,
      timeInSeconds: 0,
      status: EquationMatchStatus.initial,
      clearFirstSelected: true,
      clearSecondSelected: true,
    );
  }
  
  @override
  void handleCardTap(int index) {
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
    final List<MemoryCard<dynamic>> updatedCards = List.from(state.cards);
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
      
      bool isMatch = false;
      
      // Check for equation and result match
      if (firstCard.value is String && secondCard.value is int) {
        final String equation = firstCard.value as String;
        final int result = secondCard.value as int;
        
        // Find the pair with this equation
        final pairIndex = state.pairs.indexWhere((pair) => pair.question == equation);
        if (pairIndex != -1 && state.pairs[pairIndex].answer == result) {
          isMatch = true;
        }
      } else if (firstCard.value is int && secondCard.value is String) {
        final int result = firstCard.value as int;
        final String equation = secondCard.value as String;
        
        // Find the pair with this equation
        final pairIndex = state.pairs.indexWhere((pair) => pair.question == equation);
        if (pairIndex != -1 && state.pairs[pairIndex].answer == result) {
          isMatch = true;
        }
      }
      
      final List<MemoryCard<dynamic>> updatedCards = List.from(state.cards);
      
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
        ? 100 
        : (difficulty == DifficultyType.medium ? 200 : 300);
        
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
      status: EquationMatchStatus.completed,
      result: result,
    );
  }
  
  @override
  void resetToInitialState() {
    state = EquationMatchState(
      cards: const [],
      status: EquationMatchStatus.initial,
      difficulty: difficulty,
      totalPairs: difficulty == DifficultyType.easy ? 6 : (difficulty == DifficultyType.medium ? 8 : 10),
    );
  }
    // State update helpers
  void updateCountdown(int countdown) {
    state = state.copyWith(countdown: countdown);
  }
  
  void updateTimeInSeconds(int timeInSeconds) {
    state = state.copyWith(timeInSeconds: timeInSeconds);
  }
  
  // Implement abstract methods from MemoryMatchController
  @override
  void updateCards(List<MemoryCard<dynamic>> cards) {
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
    List<MemoryCard<dynamic>>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    EquationMatchStatus? status,
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
