import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/guess_sign/data/repository/guess_sign_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/guess_sign/presentation/controller/guess_sign_controller.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/guess_sign/presentation/state/guess_sign_state.dart';

// Repository provider
final guessSignRepositoryProvider = Provider<GuessSignRepository>((ref) {
  return GuessSignRepository();
});

// Current difficulty provider
final guessSignDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// Number of questions provider
final guessSignTotalQuestionsProvider = StateProvider<int>((ref) {
  return 10; // Default 10 questions
});

// Guess Sign controller provider
final guessSignControllerProvider = StateNotifierProvider.autoDispose<GuessSignNotifier, GuessSignState>((ref) {
  final repository = ref.watch(guessSignRepositoryProvider);
  final difficulty = ref.watch(guessSignDifficultyProvider);
  final totalQuestions = ref.watch(guessSignTotalQuestionsProvider);
  
  return GuessSignNotifier(
    repository,
    difficultyType: difficulty,
    totalQuestions: totalQuestions,
  );
});
