import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/data/repository/square_root_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/presentation/controller/square_root_controller.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/presentation/state/square_root_state.dart';

// Repository provider
final squareRootRepositoryProvider = Provider<SquareRootRepository>((ref) {
  return SquareRootRepository();
});

// Controller provider
final squareRootControllerProvider = StateNotifierProvider.family<
    SquareRootController,
    SquareRootState,
    DifficultyType>((ref, difficulty) {
  final repository = ref.watch(squareRootRepositoryProvider);
  return SquareRootController(repository, difficulty: difficulty);
});

// Current difficulty provider
final squareRootDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// High score provider
final squareRootHighScoreProvider = FutureProvider.family<int, DifficultyType>((ref, difficulty) async {
  final repository = ref.watch(squareRootRepositoryProvider);
  return repository.getHighScore(difficulty);
});
