import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/data/repository/correct_answer_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/presentation/controller/correct_answer_controller.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/presentation/state/correct_answer_state.dart';

// Repository provider
final correctAnswerRepositoryProvider = Provider<CorrectAnswerRepository>((ref) {
  return CorrectAnswerRepository();
});

// Current difficulty provider
final correctAnswerDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// Number of questions provider
final correctAnswerTotalQuestionsProvider = StateProvider<int>((ref) {
  return 10; // Default 10 questions
});

// Correct Answer controller provider
final correctAnswerControllerProvider = StateNotifierProvider.autoDispose<CorrectAnswerNotifier, CorrectAnswerState>((ref) {
  final repository = ref.watch(correctAnswerRepositoryProvider);
  final difficulty = ref.watch(correctAnswerDifficultyProvider);
  final totalQuestions = ref.watch(correctAnswerTotalQuestionsProvider);
  
  return CorrectAnswerNotifier(
    repository,
    difficultyType: difficulty,
    totalQuestions: totalQuestions,
  );
});
