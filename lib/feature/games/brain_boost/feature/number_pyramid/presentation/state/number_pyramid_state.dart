import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/domain/model/number_pyramid.dart';

enum NumberPyramidStatus {
  initial,
  loading,
  playing,
  paused,
  completed,
}

class NumberPyramidState {
  final NumberPyramid pyramid;
  final NumberPyramidStats stats;
  final DifficultyType difficulty;
  final NumberPyramidStatus status;
  final String? errorMessage;
  final bool soundEnabled;
  final bool showHelp;
  final List<List<int>>? solution;  // The complete solution (for validation and hints)
  final int? selectedRow;          // Currently selected cell row index
  final int? selectedCol;          // Currently selected cell column index
  final int? selectedNumber;       // Currently selected number to input
  
  const NumberPyramidState({
    this.pyramid = const NumberPyramid(
      rows: [],
      difficulty: DifficultyType.easy,
      height: 0,
    ),
    this.stats = const NumberPyramidStats(
      difficulty: DifficultyType.easy,
    ),
    this.difficulty = DifficultyType.easy,
    this.status = NumberPyramidStatus.initial,
    this.errorMessage,
    this.soundEnabled = true,
    this.showHelp = false,
    this.solution,
    this.selectedRow,
    this.selectedCol,
    this.selectedNumber,
  });
  
  bool get isPlaying => status == NumberPyramidStatus.playing;
  bool get isPaused => status == NumberPyramidStatus.paused;
  bool get isCompleted => status == NumberPyramidStatus.completed;
  bool get isLoading => status == NumberPyramidStatus.loading;
  
  NumberPyramidState copyWith({
    NumberPyramid? pyramid,
    NumberPyramidStats? stats,
    DifficultyType? difficulty,
    NumberPyramidStatus? status,
    String? errorMessage,
    bool? soundEnabled,
    bool? showHelp,
    List<List<int>>? solution,
    int? selectedRow,
    int? selectedCol,
    int? selectedNumber,
    bool clearSelectedCell = false,
    bool clearSelectedNumber = false,
    bool clearError = false,
  }) {
    return NumberPyramidState(
      pyramid: pyramid ?? this.pyramid,
      stats: stats ?? this.stats,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      soundEnabled: soundEnabled ?? this.soundEnabled,
      showHelp: showHelp ?? this.showHelp,
      solution: solution ?? this.solution,
      selectedRow: clearSelectedCell ? null : (selectedRow ?? this.selectedRow),
      selectedCol: clearSelectedCell ? null : (selectedCol ?? this.selectedCol),
      selectedNumber: clearSelectedNumber ? null : (selectedNumber ?? this.selectedNumber),
    );
  }
  
  // Check if a cell is editable (not part of the initial puzzle)
  bool isCellEditable(int row, int col) {
    if (row < 0 || row >= pyramid.rows.length || col < 0 || col >= pyramid.rows[row].length) {
      return false;
    }
    return pyramid.rows[row][col] == null;
  }
  
  // Check if a cell is selected
  bool isCellSelected(int row, int col) {
    return selectedRow == row && selectedCol == col;
  }
  
  // Get cell value at position
  int? getCellValue(int row, int col) {
    if (row < 0 || row >= pyramid.rows.length || col < 0 || col >= pyramid.rows[row].length) {
      return null;
    }
    return pyramid.rows[row][col];
  }
}
