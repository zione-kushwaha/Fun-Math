import 'dart:async';
import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/controller/memory_match_controller.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import '../state/pattern_memory_state.dart';

class PatternMemoryController extends MemoryMatchController<MemoryCard<bool>, MemoryMatchResult, PatternMemoryState> {
  final DifficultyType difficulty;
  final Random _random = Random();
  Timer? _flashTimer;
  Timer? _gameTimer;
  Timer? _countdownTimer;
  
  PatternMemoryController(this.difficulty) 
    : super(PatternMemoryState(
        cards: const [],
        status: PatternMemoryStatus.initial,
        difficulty: difficulty,
        totalPairs: difficulty == DifficultyType.easy ? 5 : (difficulty == DifficultyType.medium ? 8 : 10),
        flashTime: difficulty == DifficultyType.easy ? 3000 : (difficulty == DifficultyType.medium ? 2000 : 1500),
      ));
  
  @override
  void initializeGame() {
    generateNewGame();
  }
    @override
  void generateNewGame() {
    // Generate pattern based on difficulty
      // Generate a pattern pair (original and similar)
    final patterns = PatternMemoryGenerator.generatePatternPairs(difficulty, 1).first;
    final originalPattern = patterns.question;
    
    // Generate options (including the correct one and distractors)
    final correctOptionIndex = _random.nextInt(3); // 0-2
    final similarPattern = patterns.answer;
    
    final List<List<bool>> options = [];
    for (int i = 0; i < 3; i++) {
      if (i == correctOptionIndex) {
        // One option is similar to the original with a few changes
        options.add(similarPattern);
      } else {        // Other options are completely different
        // Generate another pattern pair and use its answer
        options.add(PatternMemoryGenerator.generatePatternPairs(difficulty, 1).first.answer);
      }
    }
    
    // Update state with new game
    state = state.copyWith(
      originalPattern: originalPattern,
      patternOptions: options,
      correctOptionIndex: correctOptionIndex,
      showOriginalPattern: false,
      showOptions: false,
      selectedOptionIndex: -1,
      moveCount: 0,
      matchesFound: state.matchesFound,
      level: state.isInitial ? 1 : state.level,
    );
  }
  
  @override
  void startGame() {
    // Start the countdown
    updateState(status: PatternMemoryStatus.ready);
    
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
      status: PatternMemoryStatus.playing,
      timeInSeconds: 0,
      moveCount: 0,
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
    
    // Show the original pattern
    _showOriginalPattern();
  }
  
  void _showOriginalPattern() {
    // Show the original pattern for the defined flash time
    state = state.copyWith(showOriginalPattern: true, showOptions: false);
    
    _flashTimer = Timer(Duration(milliseconds: state.flashTime), () {
      // Hide the original pattern and show options
      state = state.copyWith(showOriginalPattern: false, showOptions: true);
    });
  }
  
  void handleOptionSelection(int optionIndex) {
    // Ignore if already selected
    if (state.selectedOptionIndex != -1) return;
    
    state = state.copyWith(
      selectedOptionIndex: optionIndex,
      moveCount: state.moveCount + 1,
    );
    
    // Check if option is correct
    final bool isCorrect = optionIndex == state.correctOptionIndex;
    
    // Add delay before moving to next level or ending game
    Timer(const Duration(milliseconds: 1000), () {
      if (isCorrect) {
        // Correct selection
        final newMatchesFound = state.matchesFound + 1;
        final nextLevel = state.level + 1;
        
        state = state.copyWith(
          matchesFound: newMatchesFound,
          level: nextLevel,
        );
        
        if (newMatchesFound >= state.totalPairs) {
          _completeGame(true); // Game won
        } else {
          // Continue to next level
          generateNewGame();
          _showOriginalPattern();
        }
      } else {
        // Wrong selection - game over for medium and hard difficulty
        if (difficulty == DifficultyType.easy) {
          // For easy mode, just show the pattern again
          state = state.copyWith(selectedOptionIndex: -1);
          generateNewGame();
          _showOriginalPattern();
        } else {
          _completeGame(false); // Game lost
        }
      }
    });
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
      perfectMatchStreak: won ? state.matchesFound : state.matchesFound - 1,
      accuracyPercentage: accuracy,
    );
    
    state = state.copyWith(
      status: PatternMemoryStatus.completed,
      result: result,
    );
  }
  
  @override
  void resetToInitialState() {
    _flashTimer?.cancel();
    _flashTimer = null;
    _gameTimer?.cancel();
    _gameTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    
    state = PatternMemoryState(
      cards: const [],
      status: PatternMemoryStatus.initial,
      difficulty: difficulty,
      totalPairs: difficulty == DifficultyType.easy ? 5 : (difficulty == DifficultyType.medium ? 8 : 10),
      flashTime: difficulty == DifficultyType.easy ? 3000 : (difficulty == DifficultyType.medium ? 2000 : 1500),
    );
  }

  @override
  void handleCardTap(int index) {
    // Not used in pattern memory game
  }
  
  @override
  void dispose() {
    _flashTimer?.cancel();
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  // Implement abstract methods from MemoryMatchController
  @override
  void updateCards(List<MemoryCard<bool>> cards) {
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
    List<MemoryCard<bool>>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    PatternMemoryStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    MemoryMatchResult? result,
    String? errorMessage,
    bool? showHelp,
    int? selectedCardIndex,
    int? countdown,
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
