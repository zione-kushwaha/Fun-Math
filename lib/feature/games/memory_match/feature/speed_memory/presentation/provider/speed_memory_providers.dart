import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'speed_memory_controller.dart';

final speedMemoryControllerProvider = StateNotifierProvider.family<SpeedMemoryController, dynamic, DifficultyType>(
  (ref, difficulty) => SpeedMemoryController(difficulty),
);
