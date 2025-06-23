import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/data/repository/magic_triangle_repository.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/controller/magic_triangle_controller.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/state/magic_triangle_state.dart';

// Repository provider
final magicTriangleRepositoryProvider = Provider<MagicTriangleRepository>((ref) {
  return MagicTriangleRepository();
});

// Controller provider
final magicTriangleControllerProvider = StateNotifierProvider.family<
    MagicTriangleController,
    MagicTriangleState,
    DifficultyType>((ref, difficulty) {
  final repository = ref.watch(magicTriangleRepositoryProvider);
  return MagicTriangleController(repository, difficulty: difficulty);
});

// Current difficulty provider
final magicTriangleDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// High score provider
final magicTriangleHighScoreProvider = StateProvider.family<int, DifficultyType>((ref, difficulty) {
  // In a real app, this would fetch from local storage or a database
  switch (difficulty) {
    case DifficultyType.easy:
      return 400;
    case DifficultyType.medium:
      return 800;
    case DifficultyType.hard:
      return 1200;
  }
});
