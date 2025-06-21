import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/data/repository/math_memory_repository_fixed.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/presentation/controller/math_memory_controller.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/presentation/state/math_memory_state.dart';
import 'package:fun_math/feature/home/provider/difficulty_selector_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Repository provider
final mathMemoryRepositoryProvider = Provider<MathMemoryRepository>((ref) {
  return MathMemoryRepository();
});

// Convert app-wide difficulty to feature difficulty
final mathMemoryDifficultyProvider = Provider<DifficultyType>((ref) {
  final difficulty = ref.watch(difficultyProvider);
  switch (difficulty) {
    case Difficulty.easy:
      return DifficultyType.easy;
    case Difficulty.medium:
      return DifficultyType.medium;
    case Difficulty.hard:
      return DifficultyType.hard;
  }
});

// Controller provider
final mathMemoryControllerProvider = StateNotifierProvider.autoDispose<MathMemoryController, MathMemoryState>((ref) {
  final repository = ref.watch(mathMemoryRepositoryProvider);
  final difficulty = ref.watch(mathMemoryDifficultyProvider);
  
  return MathMemoryController(
    repository,
    difficulty: difficulty,
  );
});

// Best score provider with persistence
final mathMemoryBestScoreProvider = FutureProvider.family<int?, DifficultyType>((ref, difficulty) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'math_memory_best_score_${difficulty.toString().split('.').last}';
  return prefs.getInt(key);
});

// Save best score function
Future<bool> saveMathMemoryBestScore(DifficultyType difficulty, int score) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'math_memory_best_score_${difficulty.toString().split('.').last}';
  
  // Only save if the new score is higher
  final currentBestScore = prefs.getInt(key) ?? 0;
  if (score > currentBestScore) {
    return prefs.setInt(key, score);
  }
  return false;
}
