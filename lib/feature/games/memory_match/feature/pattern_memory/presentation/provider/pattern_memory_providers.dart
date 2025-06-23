import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'pattern_memory_controller.dart';

// Provider for PatternMemoryController
final patternMemoryControllerProvider = StateNotifierProvider.autoDispose((ref) {
  // Default to easy difficulty
  return PatternMemoryController(DifficultyType.easy);
});

// Provider with difficulty parameter
final patternMemoryControllerWithDifficultyProvider = StateNotifierProvider.family.autoDispose((ref, DifficultyType difficulty) {
  return PatternMemoryController(difficulty);
});
