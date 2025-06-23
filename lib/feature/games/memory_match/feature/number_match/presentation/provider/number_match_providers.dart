import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/feature/number_match/presentation/provider/number_match_controller.dart';
import 'package:fun_math/feature/games/memory_match/feature/number_match/presentation/state/number_match_state.dart';

final numberMatchControllerProvider = StateNotifierProvider.family<NumberMatchController, NumberMatchState, DifficultyType>(
  (ref, difficulty) => NumberMatchController(difficulty),
);
