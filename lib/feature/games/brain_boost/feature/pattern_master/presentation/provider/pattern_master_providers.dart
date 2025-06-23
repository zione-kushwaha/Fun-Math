import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/data/repository/pattern_master_repository.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/controller/pattern_master_controller.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/state/pattern_master_state.dart';

// Repository provider
final patternMasterRepositoryProvider = Provider<PatternMasterRepository>((ref) {
  return PatternMasterRepository();
});

// Controller provider
final patternMasterControllerProvider = StateNotifierProvider.family<
    PatternMasterController,
    PatternMasterState,
    DifficultyType>((ref, difficulty) {
  final repository = ref.watch(patternMasterRepositoryProvider);
  return PatternMasterController(repository, difficulty: difficulty);
});

// Current difficulty provider
final patternMasterDifficultyProvider = StateProvider<DifficultyType>((ref) {
  return DifficultyType.easy;
});

// High score provider
final patternMasterHighScoreProvider = StateProvider.family<int, DifficultyType>((ref, difficulty) {
  // In a real app, this would fetch from local storage or a database
  switch (difficulty) {
    case DifficultyType.easy:
      return 100;
    case DifficultyType.medium:
      return 200;
    case DifficultyType.hard:
      return 300;
  }
});
