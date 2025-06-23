import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'equation_match_controller.dart';

final equationMatchControllerProvider = StateNotifierProvider.family<EquationMatchController, dynamic, DifficultyType>(
  (ref, difficulty) => EquationMatchController(difficulty),
);
