import 'dart:math';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';

class PicturePuzzleRepository {
  final Random _random = Random();
  
  /// Generate a shuffled puzzle grid
  List<PicturePuzzleTile> generatePuzzle(PuzzleLevel level) {
    // Determine grid size based on level
    final gridSize = _getGridSize(level);
    final totalTiles = gridSize * gridSize;
    
    // Create ordered tiles (last tile is empty)
    final List<PicturePuzzleTile> orderedTiles = List.generate(
      totalTiles - 1,
      (index) => PicturePuzzleTile(
        id: index,
        correctPosition: index,
        currentPosition: index,
      ),
    );
    
    // Add empty tile at the end
    orderedTiles.add(PicturePuzzleTile(
      id: totalTiles - 1,
      correctPosition: totalTiles - 1,
      currentPosition: totalTiles - 1,
    ));
    
    // Create a copy for shuffling
    final shuffledTiles = List<PicturePuzzleTile>.from(orderedTiles);
    
    // Shuffle tiles (ensure puzzle is solvable)
    _shuffleTiles(shuffledTiles, gridSize);
    
    return shuffledTiles;
  }
  
  /// Shuffle tiles ensuring the puzzle is solvable
  void _shuffleTiles(List<PicturePuzzleTile> tiles, int gridSize) {
    // Shuffle a number of times based on difficulty
    final moves = gridSize * gridSize * 20;
    
    int emptyPos = tiles.length - 1;
    
    for (var i = 0; i < moves; i++) {
      // Get possible moves for empty tile
      final possibleMoves = _getValidMoves(emptyPos, gridSize);
      
      // Choose a random valid move
      final movePos = possibleMoves[_random.nextInt(possibleMoves.length)];
      
      // Swap tiles
      final movedTile = tiles[movePos].copyWith(currentPosition: emptyPos);
      final emptyTile = tiles[emptyPos].copyWith(currentPosition: movePos);
      
      tiles[emptyPos] = movedTile;
      tiles[movePos] = emptyTile;
      
      // Update empty position
      emptyPos = movePos;
    }
  }
  
  /// Get valid moves for the empty tile
  List<int> _getValidMoves(int emptyPos, int gridSize) {
    final result = <int>[];
    
    // Check top
    if (emptyPos >= gridSize) {
      result.add(emptyPos - gridSize);
    }
    
    // Check bottom
    if (emptyPos < gridSize * (gridSize - 1)) {
      result.add(emptyPos + gridSize);
    }
    
    // Check left (if not in first column)
    if (emptyPos % gridSize != 0) {
      result.add(emptyPos - 1);
    }
    
    // Check right (if not in last column)
    if (emptyPos % gridSize != gridSize - 1) {
      result.add(emptyPos + 1);
    }
    
    return result;
  }
  
  /// Get grid size based on difficulty level
  int _getGridSize(PuzzleLevel level) {
    switch (level) {
      case PuzzleLevel.easy:
        return 3; // 3x3 grid
      case PuzzleLevel.medium:
        return 4; // 4x4 grid
      case PuzzleLevel.hard:
        return 5; // 5x5 grid
    }
  }
  
  /// Calculate score based on moves and time
  int calculateScore(int moves, int timeInSeconds, PuzzleLevel level) {
    // Base score depends on difficulty
    final baseScore = level == PuzzleLevel.easy ? 500 : 
                      level == PuzzleLevel.medium ? 1000 : 1500;
    
    // Time factor (faster is better)
    final maxTime = level == PuzzleLevel.easy ? 180 : 
                    level == PuzzleLevel.medium ? 300 : 500;
    final timeFactor = timeInSeconds < maxTime 
        ? 1.0 
        : 0.5; // Half score if taking too long
    
    // Moves factor (fewer moves is better)
    final minMoves = level == PuzzleLevel.easy ? 15 : 
                     level == PuzzleLevel.medium ? 30 : 60;
    final movesFactor = moves < minMoves * 2 
        ? 1.0 
        : moves < minMoves * 4 
            ? 0.8 
            : 0.6; // Reduce score for excessive moves
    
    return (baseScore * timeFactor * movesFactor).toInt();
  }
  
  /// Check if the puzzle is solved
  bool isPuzzleSolved(List<PicturePuzzleTile> tiles) {
    // Check if each tile is in its correct position
    for (var i = 0; i < tiles.length; i++) {
      if (tiles[i].currentPosition != tiles[i].correctPosition) {
        return false;
      }
    }
    return true;
  }
}
