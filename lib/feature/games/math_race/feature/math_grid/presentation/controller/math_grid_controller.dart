import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/core/util/score_utils.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/data/repository/math_grid_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/domain/model/math_grid.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/presentation/state/math_grid_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MathGridController extends StateNotifier<MathGridState> {
  final MathGridRepository _repository;
  final DifficultyType _difficultyType;
  Timer? _timer;

  static const int _initialTimeInSeconds = 60;
  static const String _highScoreKey = 'math_grid_high_score';

  MathGridController(this._repository, this._difficultyType)
      : super(const MathGridState()) {
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
    final mathGrid = _repository.generateMathGrid(_difficultyType);
    state = state.copyWith(
      mathGrid: mathGrid,
      status: MathGridStatus.playing,
      timeLeft: _initialTimeInSeconds,
      score: 0,
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
    state = state.copyWith(status: MathGridStatus.gameOver);
  }

  void pauseGame() {
    if (state.status == MathGridStatus.playing) {
      _cancelTimer();
      state = state.copyWith(status: MathGridStatus.paused);
    }
  }

  void resumeGame() {
    if (state.status == MathGridStatus.paused) {
      state = state.copyWith(status: MathGridStatus.playing);
      _startTimer();
    }
  }

  void restartGame() {
    _startGame();
  }

  void toggleCell(int index) {
    if (state.status != MathGridStatus.playing) return;
    
    final mathGrid = state.mathGrid;
    if (mathGrid == null) return;
    
    // Skip if cell is already removed
    if (mathGrid.listForSquare[index].isRemoved) return;
    
    // Deep copy the list to modify it
    final updatedList = List<MathGridCellModel>.from(mathGrid.listForSquare);
    
    // Toggle the active state of this cell
    updatedList[index] = MathGridCellModel(
      index,
      updatedList[index].value,
      !updatedList[index].isActive,
      updatedList[index].isRemoved,
    );
    
    // Create updated grid with the changed cell
    final updatedGrid = MathGrid(listForSquare: updatedList);
    state = state.copyWith(mathGrid: updatedGrid);
    
    // Check if the currently active cells sum up to the target number
    _checkSum();
  }
  
  void _checkSum() {
    final mathGrid = state.mathGrid;
    if (mathGrid == null) return;
    
    // Calculate sum of active cells
    int total = 0;
    final activeCells = mathGrid.listForSquare
        .where((cell) => cell.isActive)
        .toList();
        
    for (var cell in activeCells) {
      total += cell.value;
    }
    
    // Check if the sum matches the target
    if (total == mathGrid.currentAnswer) {
      // Mark all active cells as removed
      final updatedList = List<MathGridCellModel>.from(mathGrid.listForSquare);
      
      for (int i = 0; i < updatedList.length; i++) {
        if (updatedList[i].isActive) {
          updatedList[i] = MathGridCellModel(
            i, 
            updatedList[i].value,
            false, // not active anymore
            true, // now removed
          );
        }
      }
      
      // Create a new grid with updated cells
      var updatedGrid = MathGrid(listForSquare: updatedList);
      
      // Check if all cells are removed
      bool allRemoved = updatedList.every((cell) => cell.isRemoved);
      
      // Update score
      int scoreIncrease = ScoreUtils.mathGridScore * activeCells.length;
      int newScore = state.score + scoreIncrease;
      
      if (allRemoved) {
        // Generate new grid if all cells are removed
        updatedGrid = _repository.generateMathGrid(_difficultyType);
        
        // Add bonus time
        _addBonusTime();
      }
      
      // Update state with new grid and score
      state = state.copyWith(
        mathGrid: updatedGrid,
        score: newScore,
      );
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
