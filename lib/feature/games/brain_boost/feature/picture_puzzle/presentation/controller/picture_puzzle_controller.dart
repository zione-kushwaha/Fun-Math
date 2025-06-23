import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/data/repository/picture_puzzle_repository.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/state/picture_puzzle_state.dart';

class PicturePuzzleController extends StateNotifier<PicturePuzzleState> {
  final PicturePuzzleRepository _repository;
  final PuzzleLevel level;
  Timer? _gameTimer;

  PicturePuzzleController(this._repository, {required this.level})
      : super(_initialState(_repository, level));

  static PicturePuzzleState _initialState(PicturePuzzleRepository repository, PuzzleLevel level) {
    // Get grid size based on level
    final gridSize = level == PuzzleLevel.easy ? 3 : level == PuzzleLevel.medium ? 4 : 5;
    
    // Generate empty puzzle initially
    return PicturePuzzleState(
      level: level,
      gridSize: gridSize,
    );
  }

  /// Initialize the puzzle with tiles
  void initializePuzzle(String? imagePath) {
    // Generate a shuffled puzzle
    final tiles = _repository.generatePuzzle(state.level);
    
    // Find empty tile index
    final emptyTileIndex = tiles.indexWhere((tile) => 
        tile.id == tiles.length - 1);
    
    state = state.copyWith(
      tiles: tiles,
      status: PicturePuzzleStatus.initial,
      stats: PuzzleStats(
        moves: 0,
        timeInSeconds: 0,
        isCompleted: false,
        level: state.level,
      ),
      emptyTileIndex: emptyTileIndex,
      imagePath: imagePath,
    );
  }

  /// Start the game
  void startGame() {
    _startTimer();
    state = state.copyWith(status: PicturePuzzleStatus.playing);
  }

  /// Pause the game
  void pauseGame() {
    if (state.isPlaying) {
      _cancelTimer();
      state = state.copyWith(status: PicturePuzzleStatus.paused);
    }
  }

  /// Resume the game
  void resumeGame() {
    if (state.isPaused) {
      _startTimer();
      state = state.copyWith(status: PicturePuzzleStatus.playing);
    }
  }

  /// Reset the game
  void resetGame() {
    _cancelTimer();
    
    // Generate a new puzzle
    final tiles = _repository.generatePuzzle(state.level);
    
    // Find empty tile index
    final emptyTileIndex = tiles.indexWhere((tile) => 
        tile.id == tiles.length - 1);
    
    state = state.copyWith(
      tiles: tiles,
      status: PicturePuzzleStatus.initial,
      stats: PuzzleStats(
        moves: 0,
        timeInSeconds: 0,
        isCompleted: false,
        level: state.level,
      ),
      emptyTileIndex: emptyTileIndex,
    );
  }

  /// Set difficulty level
  void setLevel(PuzzleLevel level) {
    // If already playing, reset the game
    if (state.isPlaying || state.isPaused) {
      _cancelTimer();
    }
    
    // Get grid size based on level
    final gridSize = level == PuzzleLevel.easy ? 3 : level == PuzzleLevel.medium ? 4 : 5;
    
    state = state.copyWith(
      level: level,
      status: PicturePuzzleStatus.initial,
      gridSize: gridSize,
    );
    
    // Initialize new puzzle
    resetGame();
  }

  /// Select an image
  void selectImage(String imagePath) {
    state = state.copyWith(
      imagePath: imagePath,
    );
    
    // Reinitialize puzzle with the new image
    resetGame();
  }

  /// Toggle help display
  void toggleHelp() {
    state = state.copyWith(showHelp: !state.showHelp);
  }

  /// Toggle sound
  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  /// Handle tile tap
  void tapTile(int index) {
    if (!state.isPlaying) return;
    
    // Check if the tile is adjacent to the empty tile
    if (_canMoveTile(index)) {
      _moveTile(index);
      
      // Check if puzzle is solved after move
      _checkCompletion();
    }
  }

  /// Check if tile can be moved
  bool _canMoveTile(int index) {
    // Can't move the empty tile itself
    if (index == state.emptyTileIndex) return false;
    
    // Check if the tile is in the same row or column as the empty tile
    final gridSize = state.gridSize;
    final emptyRow = state.emptyTileIndex ~/ gridSize;
    final emptyCol = state.emptyTileIndex % gridSize;
    final tileRow = index ~/ gridSize;
    final tileCol = index % gridSize;
    
    // Tile must be adjacent to empty space
    return (tileRow == emptyRow && (tileCol == emptyCol - 1 || tileCol == emptyCol + 1)) ||
           (tileCol == emptyCol && (tileRow == emptyRow - 1 || tileRow == emptyRow + 1));
  }

  /// Move a tile to the empty position
  void _moveTile(int index) {
    final tiles = List<PicturePuzzleTile>.from(state.tiles);
    
    // Swap positions
    final tileToMove = tiles[index];
    final emptyTile = tiles[state.emptyTileIndex];
    
    final tileNewPosition = emptyTile.currentPosition;
    final emptyNewPosition = tileToMove.currentPosition;
    
    tiles[index] = tileToMove.copyWith(currentPosition: tileNewPosition);
    tiles[state.emptyTileIndex] = emptyTile.copyWith(currentPosition: emptyNewPosition);
    
    // Update stats
    final stats = state.stats.copyWith(
      moves: state.stats.moves + 1,
    );
    
    state = state.copyWith(
      tiles: tiles,
      stats: stats,
      lastMovedTileIndex: index,
      emptyTileIndex: index,
    );
  }

  /// Check if the puzzle is completed
  void _checkCompletion() {
    bool isCompleted = _repository.isPuzzleSolved(state.tiles);
    
    if (isCompleted) {
      _cancelTimer();
        // Calculate score and update stats with completion
      final stats = state.stats.copyWith(
        isCompleted: true,
      );
      
      state = state.copyWith(
        status: PicturePuzzleStatus.completed,
        stats: stats,
      );
    }
  }

  /// Start the game timer
  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newTime = state.stats.timeInSeconds + 1;
      
      state = state.copyWith(
        stats: state.stats.copyWith(
          timeInSeconds: newTime,
        ),
      );
    });
  }

  /// Cancel the game timer
  void _cancelTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }
  
  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
