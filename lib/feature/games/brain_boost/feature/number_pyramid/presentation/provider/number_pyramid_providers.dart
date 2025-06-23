import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/data/repository/number_pyramid_repository.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/controller/number_pyramid_controller.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/state/number_pyramid_state.dart';

// Repository provider
final numberPyramidRepositoryProvider = Provider<NumberPyramidRepository>((ref) {
  return NumberPyramidRepository();
});

// Controller provider
final numberPyramidControllerProvider = StateNotifierProvider.family<
    NumberPyramidController,
    NumberPyramidState,
    DifficultyType>((ref, difficulty) {
  final repository = ref.watch(numberPyramidRepositoryProvider);
  return NumberPyramidController(repository, difficulty: difficulty);
});

// Current difficulty provider
final numberPyramidDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// High score provider
final numberPyramidHighScoreProvider = StateProvider.family<int, DifficultyType>((ref, difficulty) {
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
