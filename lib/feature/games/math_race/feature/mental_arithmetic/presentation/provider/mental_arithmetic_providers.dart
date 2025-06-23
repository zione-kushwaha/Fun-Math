import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/data/repository/mental_arithmetic_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/presentation/controller/mental_arithmetic_controller.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/presentation/state/mental_arithmetic_state.dart';

// Repository provider
final mentalArithmeticRepositoryProvider = Provider<MentalArithmeticRepository>((ref) {
  return MentalArithmeticRepository();
});

// Controller provider
final mentalArithmeticControllerProvider = StateNotifierProvider.family<
    MentalArithmeticController, 
    MentalArithmeticState,
    DifficultyType>((ref, difficulty) {
  final repository = ref.watch(mentalArithmeticRepositoryProvider);
  return MentalArithmeticController(repository, difficulty: difficulty);
});

// Current difficulty provider
final mentalArithmeticDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// High score provider
final mentalArithmeticHighScoreProvider = FutureProvider.family<int, DifficultyType>((ref, difficulty) async {
  final repository = ref.watch(mentalArithmeticRepositoryProvider);
  return repository.getHighScore(difficulty);
});
