import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/data/repository/math_grid_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/presentation/controller/math_grid_controller.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/presentation/state/math_grid_state.dart';

// Repository provider
final mathGridRepositoryProvider = Provider<MathGridRepository>((ref) {
  return MathGridRepository();
});

// Controller provider
final mathGridControllerProvider = StateNotifierProvider.autoDispose<MathGridController, MathGridState>((ref) {
  final repository = ref.watch(mathGridRepositoryProvider);
  final difficultyType = ref.watch(mathGridDifficultyProvider);
  
  return MathGridController(repository, difficultyType);
});

// Difficulty provider
final mathGridDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.medium; // Default difficulty
});
