import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import '../state/memory_match_state.dart';

/// Base controller class that can be extended by specific memory match game controllers
abstract class MemoryMatchController<T, U, S extends MemoryMatchState<T, U>> extends StateNotifier<S> {
  Timer? _gameTimer;
  Timer? _countdownTimer;
  
  MemoryMatchController(S initialState) : super(initialState);
  
  // Abstract methods to be implemented by subclasses
  void initializeGame();
  void handleCardTap(int index);
  void generateNewGame();
  
  // Common functionality
  void startGame() {
    // Start the countdown
    updateState(status: MemoryMatchStatus.ready);
    _startCountdown();
  }
  
  void _startCountdown() {
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.countdown > 1) {
          updateCountdown(state.countdown - 1);
        } else {
          _countdownTimer?.cancel();
          _startRealGame();
        }
      },
    );
  }
  
  void _startRealGame() {
    // Start with clean state
    updateState(
      status: MemoryMatchStatus.playing,
      timeInSeconds: 0,
      moveCount: 0,
      matchesFound: 0,
    );
    
    // Generate the game
    generateNewGame();
    
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
  
  void pauseGame() {
    if (state.isPlaying) {
      updateState(status: MemoryMatchStatus.paused);
    }
  }
  
  void resumeGame() {
    if (state.isPaused) {
      updateState(status: MemoryMatchStatus.playing);
    }
  }
  
  void toggleSound() {
    updateState(soundEnabled: !state.soundEnabled);
  }
  
  void toggleHelp() {
    updateState(showHelp: !state.showHelp);
  }
  
  void resetGame() {
    // Cancel active timers
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    _gameTimer = null;
    _countdownTimer = null;
    
    // Reset to initial state
    resetToInitialState();
  }
  
  // Helper methods to update state
  void updateState({
    List<T>? cards, 
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    MemoryMatchStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    U? result,
    String? errorMessage,
    bool? showHelp,
    int? selectedCardIndex,
    int? countdown,
  });
  
  void updateCards(List<T> cards);
  void updateMoveCount(int moveCount);
  void updateMatchesFound(int matchesFound);
  void updateTimeInSeconds(int timeInSeconds);
  void updateCountdown(int countdown);
  void resetToInitialState();
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
