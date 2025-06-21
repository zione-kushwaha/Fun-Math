import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/data/repository/calculator_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/presentation/controller/calculator_controller.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/presentation/state/calculator_state.dart';

// Repository provider
final calculatorRepositoryProvider = Provider<CalculatorRepository>((ref) {
  return CalculatorRepository();
});

// Current difficulty provider
final calculatorDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// Calculator controller provider
final calculatorControllerProvider = StateNotifierProvider.autoDispose<CalculatorNotifier, CalculatorState>((ref) {
  final repository = ref.watch(calculatorRepositoryProvider);
  final difficulty = ref.watch(calculatorDifficultyProvider);
  
  return CalculatorNotifier(repository, difficulty);
});
