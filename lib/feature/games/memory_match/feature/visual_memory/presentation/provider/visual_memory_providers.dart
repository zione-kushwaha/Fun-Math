import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'visual_memory_controller.dart';

final visualMemoryControllerProvider = StateNotifierProvider.family<VisualMemoryController, dynamic, DifficultyType>(
  (ref, difficulty) => VisualMemoryController(difficulty),
);
