import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/repository/number_puzzle_repository.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/data/service/score_storage_service.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/domain/model/number_puzzle.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/controller/number_puzzle_controller.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/state/number_puzzle_state.dart';
import 'package:fun_math/feature/home/provider/difficulty_selector_provider.dart';

// Repository provider
final numberPuzzleRepositoryProvider = Provider<NumberPuzzleRepository>((ref) {
  return NumberPuzzleRepository();
});

// Convert app-wide difficulty to DifficultyType
final numberPuzzleDifficultyProvider = Provider<DifficultyType>((ref) {
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

// Puzzle size provider
final puzzleSizeProvider = StateProvider<PuzzleSize>((ref) {
  final difficulty = ref.watch(numberPuzzleDifficultyProvider);
  return difficulty == DifficultyType.easy ? PuzzleSize.threeByThree : PuzzleSize.fourByFour;
});

// Number puzzle controller provider
final numberPuzzleControllerProvider = StateNotifierProvider.autoDispose<NumberPuzzleNotifier, NumberPuzzleState>((ref) {
  final repository = ref.watch(numberPuzzleRepositoryProvider);
  final scoreService = ref.watch(scoreStorageServiceProvider);
  final difficulty = ref.watch(numberPuzzleDifficultyProvider);
  
  return NumberPuzzleNotifier(
    repository,
    scoreService,
    difficulty: difficulty,
  );
});

// Score storage service provider
final scoreStorageServiceProvider = Provider<ScoreStorageService>((ref) {
  return ScoreStorageService();
});

// Best score provider with persistence
final bestScoreProvider = FutureProvider.family<int?, DifficultyType>((ref, difficulty) async {
  final storageService = ref.read(scoreStorageServiceProvider);
  return await storageService.getBestScore(difficulty);
});
