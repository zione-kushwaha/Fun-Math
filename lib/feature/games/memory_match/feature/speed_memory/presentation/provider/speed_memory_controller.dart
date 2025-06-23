import 'dart:async';
import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/controller/memory_match_controller.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/speed_memory_generator.dart' as speed_gen;
import 'package:fun_math/feature/games/memory_match/feature/speed_memory/presentation/state/speed_memory_state.dart';

class SpeedMemoryController extends MemoryMatchController<SpeedMemoryCard, MemoryMatchResult, SpeedMemoryState> {
  final DifficultyType difficulty;
  Timer? _sequenceTimer;
  Timer? _gameTimer;
  Timer? _countdownTimer;
  
  SpeedMemoryController(this.difficulty) 
    : super(SpeedMemoryState(
        cards: [],
        status: SpeedMemoryStatus.initial,
        difficulty: difficulty,
        sequenceLength: difficulty == DifficultyType.easy ? 3 : (difficulty == DifficultyType.medium ? 5 : 7),
        flashDuration: difficulty == DifficultyType.easy ? 1000 : (difficulty == DifficultyType.medium ? 800 : 600),
      ));
    @override
  void initializeGame() {
    // Generate initial set of input cards
    final inputCards = speed_gen.SpeedMemoryGenerator.generateInputCards(difficulty);
    
    state = state.copyWith(
      cards: inputCards,
      moveCount: 0,
      timeInSeconds: 0,
      level: 1,
      matchesFound: 0,
      totalPairs: difficulty == DifficultyType.easy ? 5 : (difficulty == DifficultyType.medium ? 7 : 10),
      sequence: [],
      playerSequence: [],
      isShowingSequence: false,
      isInputPhase: false,
      currentIndexShowing: -1,
      status: SpeedMemoryStatus.initial,
    );
    
    generateNewGame();
  }
  
  @override
  void generateNewGame() {
    // Generate new sequence based on difficulty and level
    int sequenceLength = difficulty == DifficultyType.easy 
        ? 3 + (state.level ~/ 2) 
        : (difficulty == DifficultyType.medium 
            ? 4 + (state.level ~/ 2)
            : 5 + (state.level ~/ 2));
            
    // Cap sequence length
    sequenceLength = min(sequenceLength, difficulty == DifficultyType.easy ? 7 : (difficulty == DifficultyType.medium ? 10 : 12));
    
    final sequence = speed_gen.SpeedMemoryGenerator.generateRandomSequence(difficulty, sequenceLength);
    
    state = state.copyWith(
      sequence: sequence,
      playerSequence: [],
      sequenceLength: sequenceLength,
      isShowingSequence: false,
      isInputPhase: false,
      currentIndexShowing: -1,
    );
  }
  
  @override
  void startGame() {
    // Start the countdown
    updateState(status: SpeedMemoryStatus.ready);
    
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
      status: SpeedMemoryStatus.playing,
      timeInSeconds: 0,
      moveCount: 0,
      matchesFound: 0,
    );
    
    // Start showing the sequence
    _showSequence();
    
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
  
  void _showSequence() {
    state = state.copyWith(isShowingSequence: true);
    
    int currentIndex = 0;
    
    _sequenceTimer = Timer.periodic(
      Duration(milliseconds: state.flashDuration),
      (timer) {
        if (currentIndex < state.sequence.length) {
          state = state.copyWith(currentIndexShowing: currentIndex);
          currentIndex++;
        } else {
          _sequenceTimer?.cancel();
          state = state.copyWith(
            isShowingSequence: false,
            isInputPhase: true, 
            currentIndexShowing: -1
          );
        }
      },
    );
  }
  
  @override
  void handleCardTap(int index) {
    if (!state.isInputPhase) return; // Ignore taps when not in input phase
    if (state.isSequenceComplete) return; // Ignore taps when sequence is complete
    
    final tappedCard = state.cards[index];
    final newPlayerSequence = [...state.playerSequence, tappedCard.value];
    
    // Update selected status
    final updatedCards = [...state.cards];
    updatedCards[index] = tappedCard.copyWith(isSelected: true);
    
    state = state.copyWith(
      playerSequence: newPlayerSequence,
      cards: updatedCards,
      moveCount: state.moveCount + 1,
    );
    
    // Show briefly that card was selected, then reset its status
    Timer(const Duration(milliseconds: 300), () {
      final resetCards = [...state.cards];
      resetCards[index] = tappedCard.copyWith(isSelected: false);
      state = state.copyWith(cards: resetCards);
    });
    
    // Check if sequence is complete
    if (newPlayerSequence.length == state.sequence.length) {
      _checkSequence();
    }
  }
  
  void _checkSequence() {
    if (state.isCorrectSequence) {
      // Player got the sequence right!
      final nextLevel = state.level + 1;
      final newMatchesFound = state.matchesFound + 1;
      
      state = state.copyWith(
        level: nextLevel,
        matchesFound: newMatchesFound,
      );
      
      if (newMatchesFound >= state.totalPairs) {
        _completeGame(true); // Won the game
      } else {
        // Show success animation and move to next level
        Timer(const Duration(seconds: 1), () {
          generateNewGame();
          _showSequence();
        });
      }
    } else {
      // Player got the sequence wrong
      if (difficulty == DifficultyType.easy) {
        // For easy mode, show the sequence again
        Timer(const Duration(seconds: 1), () {
          state = state.copyWith(playerSequence: []);
          _showSequence();
        });
      } else {
        // For medium/hard, game over
        _completeGame(false); // Lost the game
      }
    }
  }
  
  void _completeGame(bool won) {
    final baseScore = difficulty == DifficultyType.easy 
        ? 150 
        : (difficulty == DifficultyType.medium ? 250 : 400);
    
    // Level bonus
    final levelBonus = state.level * 50;
    
    // Speed bonus
    final speedBonus = max(0, 300 - (state.timeInSeconds * 10));
    
    // Penalty for wrong moves
    final penalty = max(0, (state.moveCount - state.matchesFound) * 20);
    
    final score = won ? (baseScore + levelBonus + speedBonus - penalty) : (state.level * 30);
    
    // Calculate accuracy
    final correctMoves = state.matchesFound;
    final totalMoves = state.moveCount > 0 ? state.moveCount : 1;
    final accuracy = (correctMoves / totalMoves) * 100;
    
    // Create result
    final result = MemoryMatchResult(
      score: score,
      timeInSeconds: state.timeInSeconds,
      matchesFound: state.matchesFound,
      totalMoves: state.moveCount,
      perfectMatchStreak: state.level - 1,
      accuracyPercentage: accuracy,
    );
    
    state = state.copyWith(
      status: SpeedMemoryStatus.completed,
      result: result,
    );
  }
  
  @override
  void resetToInitialState() {
    _sequenceTimer?.cancel();
    _sequenceTimer = null;
    _gameTimer?.cancel();
    _gameTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    
    state = SpeedMemoryState(
      cards: speed_gen.SpeedMemoryGenerator.generateInputCards(difficulty),
      status: SpeedMemoryStatus.initial,
      difficulty: difficulty,
      sequenceLength: difficulty == DifficultyType.easy ? 3 : (difficulty == DifficultyType.medium ? 5 : 7),
      flashDuration: difficulty == DifficultyType.easy ? 1000 : (difficulty == DifficultyType.medium ? 800 : 600),
    );
  }
  
  @override
  void dispose() {
    _sequenceTimer?.cancel();
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  // Implement abstract methods from MemoryMatchController
  @override
  void updateCards(List<SpeedMemoryCard> cards) {
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
    List<SpeedMemoryCard>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    SpeedMemoryStatus? status,
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
