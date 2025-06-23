import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'sequence_match_controller.dart';

// Provider for SequenceMatchController
final sequenceMatchControllerProvider = StateNotifierProvider.autoDispose((ref) {
  // Default to easy difficulty
  return SequenceMatchController(DifficultyType.easy);
});

// Provider with difficulty parameter
final sequenceMatchControllerWithDifficultyProvider = StateNotifierProvider.family.autoDispose((ref, DifficultyType difficulty) {
  return SequenceMatchController(difficulty);
});
