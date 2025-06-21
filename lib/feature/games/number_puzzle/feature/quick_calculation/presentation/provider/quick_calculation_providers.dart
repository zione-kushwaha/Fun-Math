import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/data/repository/quick_calculation_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/presentation/controller/quick_calculation_controller.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/presentation/state/quick_calculation_state.dart';

// Repository provider
final quickCalculationRepositoryProvider = Provider<QuickCalculationRepository>((ref) {
  return QuickCalculationRepository();
});

// Current difficulty provider
final quickCalculationDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// Game time provider (in seconds)
final quickCalculationGameTimeProvider = StateProvider<int>((ref) {
  return 60; // Default 60 seconds (1 minute)
});

// Quick Calculation controller provider
final quickCalculationControllerProvider = StateNotifierProvider.autoDispose<QuickCalculationNotifier, QuickCalculationState>((ref) {
  final repository = ref.watch(quickCalculationRepositoryProvider);
  final difficulty = ref.watch(quickCalculationDifficultyProvider);
  final gameTime = ref.watch(quickCalculationGameTimeProvider);
  
  return QuickCalculationNotifier(
    repository,
    difficultyType: difficulty,
    gameTimeInSeconds: gameTime,
  );
});
