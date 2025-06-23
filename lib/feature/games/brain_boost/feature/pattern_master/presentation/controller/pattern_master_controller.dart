import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/data/repository/pattern_master_repository.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/domain/model/pattern_master.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/state/pattern_master_state.dart';

class PatternMasterController extends StateNotifier<PatternMasterState> {
  final PatternMasterRepository _repository;
  final DifficultyType difficulty;
  Timer? _gameTimer;
  Timer? _feedbackTimer;

  PatternMasterController(this._repository, {required this.difficulty})
      : super(_initialState(difficulty));

  static PatternMasterState _initialState(DifficultyType difficulty) {
    return PatternMasterState(
      difficulty: difficulty,
      totalQuestions: difficulty == DifficultyType.easy ? 5 :
                     difficulty == DifficultyType.medium ? 7 : 10,
    );
  }

  /// Initialize the game
  void initializeGame() {
    // Reset the state
    state = _initialState(difficulty);
  }

  /// Start the game
  void startGame() {
    // Generate first pattern
    _generateNewPattern();
    
    _startTimer();
    state = state.copyWith(
      status: PatternMasterStatus.playing,
      questionIndex: 0,
      correctAnswers: 0,
      timeInSeconds: 0,
      questionResults: [],
      hasGameStarted: true,
    );
  }

  /// Reset the game
  void resetGame() {
    _cancelTimer();
    _cancelFeedbackTimer();
    initializeGame();
  }

  /// Generate options for the current pattern
  List<PatternItem> generateOptions() {
    if (state.currentSequence == null) return [];
    return state.options;
  }

  /// Check the selected answer
  void checkAnswer(PatternItem selectedItem) {
    if (!state.isPlaying || state.selectedOptionIndex != null) return;
    
    // Find the index of the selected item in options
    final index = state.options.indexWhere((item) => 
      item.element == selectedItem.element && 
      item.color == selectedItem.color && 
      item.size == selectedItem.size
    );
    
    if (index != -1) {
      selectOption(index);
    }
  }

  /// Skip the current pattern
  void skipPattern() {
    if (!state.isPlaying) return;
    
    // Add a wrong answer
    state = state.addQuestionResult(false);
    
    // Move to next question
    _moveToNextQuestion();
  }

  /// Show a hint for the current pattern
  void showHint() {
    if (!state.isPlaying || state.currentSequence == null) return;
    
    // TODO: Implement hint system
    // For now, just display a message that would be shown to the user
    state = state.copyWith(
      showHelp: true,
    );
    
    // Hide hint after a few seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        state = state.copyWith(showHelp: false);
      }
    });
  }

  /// Pause the game
  void pauseGame() {
    if (state.isPlaying) {
      _cancelTimer();
      state = state.copyWith(status: PatternMasterStatus.paused);
    }
  }

  /// Resume the game
  void resumeGame() {
    if (state.isPaused) {
      _startTimer();
      state = state.copyWith(status: PatternMasterStatus.playing);
    }
  }

  /// Generate a new pattern
  void _generateNewPattern() {
    // Generate a new pattern sequence
    final sequence = _repository.generatePatternSequence(state.difficulty);
    
    // Generate possible answers
    final options = _repository.getPossibleAnswers(sequence);
    
    state = state.copyWith(
      currentSequence: sequence,
      options: options,
      selectedOptionIndex: null,
    );
  }

  /// Select an answer option
  void selectOption(int index) {
    if (!state.isPlaying || state.selectedOptionIndex != null) return;
    
    state = state.copyWith(
      selectedOptionIndex: index,
    );
    
    // Check if answer is correct
    _checkAnswer(index);
  }

  /// Check if the selected answer is correct
  void _checkAnswer(int selectedIndex) {
    if (state.currentSequence == null) return;
    
    final correctOption = _repository.getCorrectAnswer(state.currentSequence!);
    final selectedOption = state.options[selectedIndex];
    bool isCorrect = false;
    
    // Check if correct based on the pattern type
    switch (state.currentSequence!.patternType) {
      case PatternAttribute.shape:
        isCorrect = selectedOption.element == correctOption.element;
        break;
      case PatternAttribute.color:
        isCorrect = selectedOption.color == correctOption.color;
        break;
      case PatternAttribute.size:
        // Allow small differences due to floating point
        isCorrect = (selectedOption.size - correctOption.size).abs() < 0.1;
        break;
      case PatternAttribute.position:
        isCorrect = selectedOption.position == correctOption.position;
        break;
    }
    
    // Update state with result
    state = state.addQuestionResult(isCorrect);
    
    // Show feedback briefly
    _showFeedback(isCorrect);
  }

  /// Show feedback for the answer
  void _showFeedback(bool isCorrect) {
    _cancelFeedbackTimer();
    
    state = state.copyWith(
      status: PatternMasterStatus.showingFeedback,
    );
    
    _feedbackTimer = Timer(const Duration(seconds: 1), () {
      // Move to next question or end game
      _moveToNextQuestion();
    });
  }

  /// Move to the next question or end the game
  void _moveToNextQuestion() {
    if (state.hasMoreQuestions) {
      state = state.copyWith(
        questionIndex: state.questionIndex + 1,
        status: PatternMasterStatus.playing,
      );
      
      // Generate a new pattern for the next question
      _generateNewPattern();
    } else {
      // End the game
      _endGame();
    }
  }

  /// End the game and calculate final score
  void _endGame() {
    _cancelTimer();
    
    // Calculate final score
    final score = _repository.calculateScore(
      state.correctAnswers,
      state.totalQuestions,
      state.timeInSeconds,
      state.difficulty,
    );
    
    // Create result
    final result = PatternResult(
      score: score,
      correctAnswers: state.correctAnswers,
      totalQuestions: state.totalQuestions,
      timeInSeconds: state.timeInSeconds,
    );
    
    // Update highscore if needed
    _updateHighScoreIfNeeded(score);
    
    state = state.copyWith(
      status: PatternMasterStatus.completed,
      result: result,
    );
  }

  /// Update high score if the current score is higher
  void _updateHighScoreIfNeeded(int score) {
    // This would typically be handled by the provider
    // Implementation will be in the provider
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
    state = state.copyWith(animationsEnabled: !state.animationsEnabled);
  }

  /// Set difficulty level
  void setDifficulty(DifficultyType difficulty) {
    // If already playing, reset the game
    if (state.isPlaying || state.isPaused) {
      _cancelTimer();
    }
    
    state = state.copyWith(
      difficulty: difficulty,
      status: PatternMasterStatus.initial,
      totalQuestions: difficulty == DifficultyType.easy ? 5 :
                     difficulty == DifficultyType.medium ? 7 : 10,
    );
  }

  /// Start the game timer
  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        timeInSeconds: state.timeInSeconds + 1,
      );
    });
  }

  /// Cancel the game timer
  void _cancelTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }
  
  /// Cancel the feedback timer
  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }
  
  @override
  void dispose() {
    _cancelTimer();
    _cancelFeedbackTimer();
    super.dispose();
  }
}
