import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/data/repository/math_memory_repository_fixed.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/domain/model/math_memory.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/presentation/state/math_memory_state.dart';

class MathMemoryController extends StateNotifier<MathMemoryState> {
  final MathMemoryRepository _repository;
  final DifficultyType difficulty;
  Timer? _timer;
  Timer? _checkMatchTimer;

  MathMemoryController(this._repository, {required this.difficulty}) 
      : super(_initialState(_repository, difficulty));

  static MathMemoryState _initialState(MathMemoryRepository repository, DifficultyType difficulty) {
    // Get dimensions based on difficulty
    final gridDimensions = repository.getGridDimensions(difficulty);
    final totalPairs = (gridDimensions[0] * gridDimensions[1]) ~/ 2;
    
    // Generate math pairs
    final pairs = repository.generateMathPairs(difficulty, totalPairs);
    
    // Create cards
    final cards = repository.generateCards(pairs);
    
    return MathMemoryState(
      cards: cards,
      pairs: pairs,
    );
  }

  /// Start the game
  void startGame() {
    _startTimer();
    state = state.copyWith(status: MathMemoryStatus.playing);
  }

  /// Pause the game
  void pauseGame() {
    if (state.isPlaying) {
      _cancelTimer();
      state = state.copyWith(status: MathMemoryStatus.paused);
    }
  }

  /// Resume the game
  void resumeGame() {
    if (state.isPaused) {
      _startTimer();
      state = state.copyWith(status: MathMemoryStatus.playing);
    }
  }

  /// Reset the game
  void resetGame() {
    _cancelTimer();
    _cancelCheckMatchTimer();
    
    final gridDimensions = _repository.getGridDimensions(difficulty);
    final totalPairs = (gridDimensions[0] * gridDimensions[1]) ~/ 2;
    
    final pairs = _repository.generateMathPairs(difficulty, totalPairs);
    final cards = _repository.generateCards(pairs);
    
    state = MathMemoryState(
      cards: cards,
      pairs: pairs,
    );
  }

  /// Toggle help display
  void toggleHelp() {
    state = state.copyWith(showHelp: !state.showHelp);
  }

  /// Toggle sound
  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  /// Toggle animations
  void toggleAnimations() {
    state = state.copyWith(animationEnabled: !state.animationEnabled);
  }

  /// Handle card selection
  void selectCard(int index) {
    if (!state.isPlaying || state.isChecking) return;
    
    final card = state.cards[index];
    
    // Ignore if card is already flipped
    if (card.isFlipped || card.isMatched) return;
    
    // First selection
    if (state.firstSelectedCard == null) {
      final updatedCards = List<MathMemoryCard>.from(state.cards);
      updatedCards[index] = card.copyWith(isFlipped: true);
      
      state = state.copyWith(
        firstSelectedCard: card,
        cards: updatedCards,
      );
      return;
    }
    
    // Second selection
    if (state.secondSelectedCard == null) {
      final updatedCards = List<MathMemoryCard>.from(state.cards);
      updatedCards[index] = card.copyWith(isFlipped: true);
      
      state = state.copyWith(
        secondSelectedCard: card,
        cards: updatedCards,
        isChecking: true,
        moveCount: state.moveCount + 1,
      );
      
      // Check for match
      _checkMatch();
    }
  }

  /// Check if the selected cards match
  void _checkMatch() {
    final first = state.firstSelectedCard!;
    final second = state.secondSelectedCard!;
    
    // Wait a moment so player can see the cards
    _checkMatchTimer = Timer(const Duration(milliseconds: 1000), () {
      final isMatch = _repository.isMatch(first, second, state.pairs);
      final updatedCards = List<MathMemoryCard>.from(state.cards);
      
      // Update cards
      for (int i = 0; i < updatedCards.length; i++) {
        final card = updatedCards[i];
        
        if (card.id == first.id || card.id == second.id) {
          updatedCards[i] = card.copyWith(
            isFlipped: isMatch,
            isMatched: isMatch,
          );
        }
      }
      
      // Update state
      state = state.copyWith(
        cards: updatedCards,
        firstSelectedCard: null,
        secondSelectedCard: null,
        isChecking: false,
        matchesFound: isMatch ? state.matchesFound + 1 : state.matchesFound,
      );
      
      // Check if game is completed
      if (state.isGameOver) {
        _handleGameCompleted();
      }
    });
  }

  /// Handle game completion
  void _handleGameCompleted() {
    _cancelTimer();
    
    final result = MathMemoryResult(
      score: _repository.calculateScore(
        state.timeInSeconds, 
        state.moveCount, 
        state.matchesFound, 
        state.totalPairs, 
        difficulty
      ),
      timeInSeconds: state.timeInSeconds,
      matchesFound: state.matchesFound,
      totalMoves: state.moveCount,
    );
    
    state = state.copyWith(
      status: MathMemoryStatus.completed,
      result: result,
    );
  }

  /// Start the timer
  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(timeInSeconds: state.timeInSeconds + 1);
    });
  }

  /// Cancel the timer
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Cancel the match checking timer
  void _cancelCheckMatchTimer() {
    _checkMatchTimer?.cancel();
    _checkMatchTimer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    _cancelCheckMatchTimer();
    super.dispose();
  }
}
