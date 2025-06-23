import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/data/repository/math_pairs_repository.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/presentation/controller/math_pairs_controller.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/presentation/state/math_pairs_state.dart';

// Repository provider
final mathPairsRepositoryProvider = Provider<MathPairsRepository>((ref) {
  return MathPairsRepository();
});

// Controller provider
final mathPairsControllerProvider = StateNotifierProvider.autoDispose<MathPairsController, MathPairsState>((ref) {
  final repository = ref.watch(mathPairsRepositoryProvider);
  final difficultyType = ref.watch(difficultyProvider);
  
  return MathPairsController(repository, difficultyType);
});

// Difficulty provider (this should be moved to a common location later)
final difficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.medium; // Default difficulty
});
