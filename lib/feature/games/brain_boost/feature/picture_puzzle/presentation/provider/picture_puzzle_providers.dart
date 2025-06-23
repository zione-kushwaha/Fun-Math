import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/data/repository/picture_puzzle_repository.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/controller/picture_puzzle_controller.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/state/picture_puzzle_state.dart';

// Repository provider
final picturePuzzleRepositoryProvider = Provider<PicturePuzzleRepository>((ref) {
  return PicturePuzzleRepository();
});

// Controller provider
final picturePuzzleControllerProvider = StateNotifierProvider.family<
    PicturePuzzleController,
    PicturePuzzleState,
    PuzzleLevel>((ref, difficulty) {
  final repository = ref.watch(picturePuzzleRepositoryProvider);
  return PicturePuzzleController(repository, level: difficulty);
});

// Current level provider
final picturePuzzleLevelProvider = StateProvider<PuzzleLevel>((ref) {
  return PuzzleLevel.easy;
});

// Image provider - keeps track of the selected image
final picturePuzzleImageProvider = StateProvider<String?>((ref) {
  return null;
});

// High score provider
final picturePuzzleHighScoreProvider = StateProvider.family<int, PuzzleLevel>((ref, level) {
  // In a real app, this would fetch from local storage or a database
  switch (level) {
    case PuzzleLevel.easy:
      return 500;
    case PuzzleLevel.medium:
      return 1000;
    case PuzzleLevel.hard:
      return 1500;
  }
});
