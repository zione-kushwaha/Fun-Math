import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/domain/model/magic_triangle.dart';

enum MagicTriangleStatus {
  initial,
  loading,
  playing,
  paused,
  completed,
}

class MagicTriangleState {
  final MagicTriangle triangle;
  final MagicTriangleStats stats;
  final DifficultyType difficulty;
  final MagicTriangleStatus status;
  final String? errorMessage;
  final bool soundEnabled;
  final bool showHelp;
  final int? selectedNumberIndex;  // Index of the selected number from available numbers
  final int? selectedPositionIndex; // Index of the selected position in the triangle
  final List<int> availableNumbers;  // Numbers that can be placed in the triangle
  final bool isValidatingMove;  // Whether the current move is being validated
  
  const MagicTriangleState({
    this.triangle = const MagicTriangle(
      numbers: [],
      targetSum: 0,
      size: 3,
      difficulty: DifficultyType.easy,
    ),
    this.stats = const MagicTriangleStats(
      difficulty: DifficultyType.easy,
    ),
    this.difficulty = DifficultyType.easy,
    this.status = MagicTriangleStatus.initial,
    this.errorMessage,
    this.soundEnabled = true,
    this.showHelp = false,
    this.selectedNumberIndex,
    this.selectedPositionIndex,
    this.availableNumbers = const [],
    this.isValidatingMove = false,
  });
  
  bool get isPlaying => status == MagicTriangleStatus.playing;
  bool get isPaused => status == MagicTriangleStatus.paused;
  bool get isCompleted => status == MagicTriangleStatus.completed;
  bool get isLoading => status == MagicTriangleStatus.loading;
  
  MagicTriangleState copyWith({
    MagicTriangle? triangle,
    MagicTriangleStats? stats,
    DifficultyType? difficulty,
    MagicTriangleStatus? status,
    String? errorMessage,
    bool? soundEnabled,
    bool? showHelp,
    int? selectedNumberIndex,
    int? selectedPositionIndex,
    List<int>? availableNumbers,
    bool? isValidatingMove,
  }) {
    return MagicTriangleState(
      triangle: triangle ?? this.triangle,
      stats: stats ?? this.stats,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      showHelp: showHelp ?? this.showHelp,
      selectedNumberIndex: selectedNumberIndex ?? this.selectedNumberIndex,
      selectedPositionIndex: selectedPositionIndex ?? this.selectedPositionIndex,
      availableNumbers: availableNumbers ?? this.availableNumbers,
      isValidatingMove: isValidatingMove ?? this.isValidatingMove,
    );
  }
  
  // Reset selection state
  MagicTriangleState resetSelections() {
    return copyWith(
      selectedNumberIndex: null,
      selectedPositionIndex: null,
    );
  }
  
  // Clear error message
  MagicTriangleState clearError() {
    return copyWith(
      errorMessage: null,
    );
  }
}
