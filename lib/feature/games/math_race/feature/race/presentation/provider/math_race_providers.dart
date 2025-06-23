import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/race/data/repository/math_race_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/race/presentation/controller/math_race_controller.dart';
import 'package:fun_math/feature/games/math_race/feature/race/presentation/state/math_race_state.dart';

// Repository provider
final mathRaceRepositoryProvider = Provider<MathRaceRepository>((ref) {
  return MathRaceRepository();
});

// Controller provider
final mathRaceControllerProvider = StateNotifierProvider.family<
    MathRaceController,
    MathRaceState,
    DifficultyType>((ref, difficulty) {
  final repository = ref.watch(mathRaceRepositoryProvider);
  return MathRaceController(repository, difficulty: difficulty);
});

// Current difficulty provider
final mathRaceDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// High score provider
final mathRaceHighScoreProvider = FutureProvider.family<int, DifficultyType>((ref, difficulty) async {
  final repository = ref.watch(mathRaceRepositoryProvider);
  return repository.getHighScore(difficulty);
});
