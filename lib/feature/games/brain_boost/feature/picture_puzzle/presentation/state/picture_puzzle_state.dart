import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';

enum PicturePuzzleStatus {
  initial,
  loading,
  playing,
  paused,
  completed,
}

class PicturePuzzleState {
  final List<PicturePuzzleTile> tiles;
  final PuzzleStats stats;
  final PuzzleLevel level;
  final PicturePuzzleStatus status;
  final String? errorMessage;
  final bool soundEnabled;
  final bool showHelp;
  final int? selectedTileIndex;
  final int? lastMovedTileIndex;
  final int emptyTileIndex; // Index of the empty tile
  final String? imagePath; // Path to the image being used
  final int gridSize;
  
  const PicturePuzzleState({
    this.tiles = const [],
    this.stats = const PuzzleStats(
      moves: 0,
      timeInSeconds: 0,
      isCompleted: false,
      level: PuzzleLevel.easy,
    ),
    this.level = PuzzleLevel.easy,
    this.status = PicturePuzzleStatus.initial,
    this.errorMessage,
    this.soundEnabled = true,
    this.showHelp = false,
    this.selectedTileIndex,
    this.lastMovedTileIndex,
    this.emptyTileIndex = -1,
    this.imagePath,
    this.gridSize = 3,
  });
  
  bool get isPlaying => status == PicturePuzzleStatus.playing;
  bool get isPaused => status == PicturePuzzleStatus.paused;
  bool get isCompleted => status == PicturePuzzleStatus.completed;
  bool get isLoading => status == PicturePuzzleStatus.loading;
  
  PicturePuzzleState copyWith({
    List<PicturePuzzleTile>? tiles,
    PuzzleStats? stats,
    PuzzleLevel? level,
    PicturePuzzleStatus? status,
    String? errorMessage,
    bool? soundEnabled,
    bool? showHelp,
    int? selectedTileIndex,
    int? lastMovedTileIndex,
    int? emptyTileIndex,
    String? imagePath,
    int? gridSize,
  }) {
    return PicturePuzzleState(
      tiles: tiles ?? this.tiles,
      stats: stats ?? this.stats,
      level: level ?? this.level,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      showHelp: showHelp ?? this.showHelp,
      selectedTileIndex: selectedTileIndex ?? this.selectedTileIndex,
      lastMovedTileIndex: lastMovedTileIndex ?? this.lastMovedTileIndex,
      emptyTileIndex: emptyTileIndex ?? this.emptyTileIndex,
      imagePath: imagePath ?? this.imagePath,
      gridSize: gridSize ?? this.gridSize,
    );
  }
  
  PicturePuzzleState clearSelection() {
    return copyWith(
      selectedTileIndex: null,
    );
  }
  
  PicturePuzzleState clearError() {
    return copyWith(
      errorMessage: null,
    );
  }
}
