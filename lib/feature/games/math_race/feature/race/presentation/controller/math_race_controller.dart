import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/race/data/repository/math_race_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/race/domain/model/math_race.dart';
import 'package:fun_math/feature/games/math_race/feature/race/presentation/state/math_race_state.dart';

class MathRaceController extends StateNotifier<MathRaceState> {
  final MathRaceRepository _repository;
  Timer? _gameTimer;
  Timer? _countdownTimer;
  Timer? _opponentTimer;
  
  MathRaceController(this._repository, {required DifficultyType difficulty})
      : super(MathRaceState(difficulty: difficulty));
  
  void initializeGame() {
    state = MathRaceState(difficulty: state.difficulty);
    _generateNewProblem();
  }
  
  void startGame() {
    // Start the countdown
    state = state.copyWith(status: MathRaceStatus.ready);
    _startCountdown();
  }
  
  void _startCountdown() {
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.countdown > 1) {
          state = state.copyWith(countdown: state.countdown - 1);
        } else {
          _countdownTimer?.cancel();
          _startRealGame();
        }
      },
    );
  }
  
  void _startRealGame() {
    // Reset any previous game state
    state = state.copyWith(
      status: MathRaceStatus.playing,
      timeInSeconds: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      score: 0,
      raceProgress: const RaceProgress(),
      questionResults: [],
    );
    
    // Generate the first problem
    _generateNewProblem();
    
    // Start the game timer
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.isPlaying) {
          final newTime = state.timeInSeconds + 1;
          state = state.copyWith(timeInSeconds: newTime);
          
          // Update opponent position
          _updateOpponentPosition();
          
          // Check if race has finished
          if (state.raceProgress.isRaceFinished) {
            _completeRace();
          }
        }
      },
    );
    
    // Start the opponent movement timer (more frequent updates for smoother animation)
    _opponentTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        if (state.isPlaying) {
          _updateOpponentPosition();
          
          // Check if race has finished
          if (state.raceProgress.isRaceFinished) {
            _completeRace();
          }
        }
      },
    );
  }
  
  void _updateOpponentPosition() {
    // Calculate the opponent's new position
    final opponentPosition = _repository.calculateOpponentProgress(
      state.difficulty,
      state.timeInSeconds,
      state.raceProgress.totalDistance,
    );
    
    // Update race progress
    state = state.copyWith(
      raceProgress: state.raceProgress.copyWith(
        opponentPosition: opponentPosition,
      ),
    );
  }
  
  void selectAnswer(int optionIndex) {
    if (!state.isPlaying) return;
    
    final currentProblem = state.currentProblem;
    if (currentProblem == null) return;
    
    final selectedAnswer = currentProblem.options[optionIndex];
    final isCorrect = selectedAnswer == currentProblem.correctAnswer;
    
    // Calculate points for correct answers (faster answers get more points)
    int pointsEarned = 0;
    if (isCorrect) {
      // Base points by difficulty
      switch (state.difficulty) {
        case DifficultyType.easy:
          pointsEarned = 10;
          break;
        case DifficultyType.medium:
          pointsEarned = 15;
          break;
        case DifficultyType.hard:
          pointsEarned = 20;
          break;
      }
      
      // Progress in the race
      final progressIncrease = isCorrect ? 
          min(15, state.raceProgress.totalDistance - state.raceProgress.position) : 0;
      
      // Update the state
      state = state.copyWith(
        correctAnswers: state.correctAnswers + 1,
        score: state.score + pointsEarned,
        questionResults: [...state.questionResults, isCorrect],
        raceProgress: state.raceProgress.copyWith(
          position: state.raceProgress.position + progressIncrease,
        ),
      );
    } else {
      // Penalty for wrong answers - slow down slightly
      state = state.copyWith(
        incorrectAnswers: state.incorrectAnswers + 1,
        questionResults: [...state.questionResults, isCorrect],
      );
    }
    
    // Check if player has finished the race
    if (state.raceProgress.position >= state.raceProgress.totalDistance) {
      _completeRace();
      return;
    }
    
    // Generate a new problem
    _generateNewProblem();
  }
  
  void _generateNewProblem() {
    final newProblem = _repository.generateProblem(state.difficulty);
    state = state.copyWith(
      currentProblem: newProblem,
      selectedOptionIndex: null,
    );
  }
  
  void pauseGame() {
    if (state.isPlaying) {
      state = state.copyWith(status: MathRaceStatus.paused);
    }
  }
  
  void resumeGame() {
    if (state.isPaused) {
      state = state.copyWith(status: MathRaceStatus.playing);
    }
  }
  
  void _completeRace() {
    // Cancel all timers
    _gameTimer?.cancel();
    _opponentTimer?.cancel();
    _gameTimer = null;
    _opponentTimer = null;
    
    // Create the final result
    final result = MathRaceResult(
      score: state.score,
      correctAnswers: state.correctAnswers,
      totalQuestions: state.totalQuestions,
      timeInSeconds: state.timeInSeconds,
      isWinner: state.raceProgress.isPlayerWinner,
    );
    
    // Update the state to completed
    state = state.copyWith(
      status: MathRaceStatus.completed,
      result: result,
    );
    
    // Save high score if applicable
    _repository.saveHighScore(state.difficulty, state.score);
  }
  
  void resetGame() {
    // Cancel any active timers
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    _opponentTimer?.cancel();
    _gameTimer = null;
    _countdownTimer = null;
    _opponentTimer = null;
    
    // Reset to initial state with the same difficulty
    state = MathRaceState(difficulty: state.difficulty);
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    _opponentTimer?.cancel();
    super.dispose();
  }
}
