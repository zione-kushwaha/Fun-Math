import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/core/util/score_utils.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/data/repository/math_pairs_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/domain/model/math_pairs.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/presentation/state/math_pairs_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MathPairsController extends StateNotifier<MathPairsState> {
  final MathPairsRepository _repository;
  final DifficultyType _difficultyType;
  Timer? _timer;

  static const int _initialTimeInSeconds = 60;
  static const String _highScoreKey = 'math_pairs_high_score';

  MathPairsController(this._repository, this._difficultyType)
      : super(const MathPairsState()) {
    _loadHighScore();
    _startGame();
  }

  void _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final highScore = prefs.getInt(_highScoreKey) ?? 0;
    state = state.copyWith(highScore: highScore);
  }

  void _saveHighScore(int score) async {
    if (score > state.highScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highScoreKey, score);
      state = state.copyWith(highScore: score);
    }
  }

  void _startGame() {
    final mathPairs = _repository.generateMathPairs(_difficultyType);
    state = state.copyWith(
      mathPairs: mathPairs,
      status: MathPairsStatus.playing,
      timeLeft: _initialTimeInSeconds,
      score: 0,
      firstSelectedIndex: -1,
      isFirstAttempt: true,
    );
    _startTimer();
  }

  void _startTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        _endGame();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _endGame() {
    _cancelTimer();
    _saveHighScore(state.score);
    state = state.copyWith(status: MathPairsStatus.gameOver);
  }

  void pauseGame() {
    if (state.status == MathPairsStatus.playing) {
      _cancelTimer();
      state = state.copyWith(status: MathPairsStatus.paused);
    }
  }

  void resumeGame() {
    if (state.status == MathPairsStatus.paused) {
      state = state.copyWith(status: MathPairsStatus.playing);
      _startTimer();
    }
  }

  void restartGame() {
    _startGame();
  }

  void selectCard(int index) {
    if (state.status != MathPairsStatus.playing) return;
    if (index == state.firstSelectedIndex) return;
    
    final mathPairs = state.mathPairs;
    if (mathPairs == null) return;
    
    if (!mathPairs.list[index].isVisible) return;
    if (mathPairs.list[index].isActive) return;
    
    // Deep copy the list to modify it
    final updatedList = List<Pair>.from(mathPairs.list);
    updatedList[index] = Pair(
      updatedList[index].uid, 
      updatedList[index].text, 
      true, // Set isActive to true
      updatedList[index].isVisible,
    );
    
    final updatedMathPairs = MathPairs(updatedList, mathPairs.availableItem);
    
    if (state.firstSelectedIndex == -1) {
      // First card selected
      state = state.copyWith(
        mathPairs: updatedMathPairs,
        firstSelectedIndex: index,
      );
    } else {
      // Second card selected, check for match
      final firstIndex = state.firstSelectedIndex;
      
      if (updatedList[firstIndex].uid == updatedList[index].uid) {
        // Match found
        // Set both cards to invisible (matched)
        updatedList[firstIndex] = Pair(
          updatedList[firstIndex].uid, 
          updatedList[firstIndex].text, 
          true, 
          false, // Set isVisible to false
        );
        
        updatedList[index] = Pair(
          updatedList[index].uid, 
          updatedList[index].text, 
          true, 
          false, // Set isVisible to false
        );
        
        final availableItems = mathPairs.availableItem - 2;
        final updatedMathPairs = MathPairs(updatedList, availableItems);
        
        // Add score
        final newScore = state.score + ScoreUtils.mathPairsScore;
        
        state = state.copyWith(
          mathPairs: updatedMathPairs,
          score: newScore,
          firstSelectedIndex: -1,
        );
        
        // Check if game is over (all pairs found)
        if (availableItems == 0) {
          // Generate new set
          final newMathPairs = _repository.generateMathPairs(_difficultyType);
          
          // Update state with new pairs
          state = state.copyWith(
            mathPairs: newMathPairs,
            firstSelectedIndex: -1,
          );
          
          // Add bonus time
          _addBonusTime();
        }
      } else {
        // No match
        // Keep cards visible for a short time, then flip them back
        state = state.copyWith(
          mathPairs: updatedMathPairs,
          isFirstAttempt: false,
        );
        
        // Schedule to flip cards back after delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (state.status != MathPairsStatus.playing) return;
          
          final currentList = state.mathPairs?.list;
          if (currentList == null) return;
          
          final updatedList = List<Pair>.from(currentList);
          
          // Set both cards back to inactive
          updatedList[firstIndex] = Pair(
            updatedList[firstIndex].uid, 
            updatedList[firstIndex].text, 
            false, // Set isActive to false
            updatedList[firstIndex].isVisible,
          );
          
          updatedList[index] = Pair(
            updatedList[index].uid, 
            updatedList[index].text, 
            false, // Set isActive to false
            updatedList[index].isVisible,
          );
          
          final updatedMathPairs = MathPairs(
            updatedList, 
            state.mathPairs!.availableItem,
          );
          
          state = state.copyWith(
            mathPairs: updatedMathPairs,
            firstSelectedIndex: -1,
          );
        });
      }
    }
  }

  void _addBonusTime() {
    int bonusTime = 0;
    
    switch (_difficultyType) {
      case DifficultyType.easy:
        bonusTime = 10;
        break;
      case DifficultyType.medium:
        bonusTime = 15;
        break;
      case DifficultyType.hard:
        bonusTime = 20;
        break;
    }
    
    state = state.copyWith(timeLeft: state.timeLeft + bonusTime);
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
