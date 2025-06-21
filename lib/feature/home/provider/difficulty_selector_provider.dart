import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Difficulty levels available in the app
enum Difficulty {
  easy,
  medium,
  hard,
}

/// Notifier to manage difficulty selection state
class DifficultyNotifier extends StateNotifier<Difficulty> {
  DifficultyNotifier() : super(Difficulty.medium); // Default to medium difficulty

  /// Set the selected difficulty
  void setDifficulty(Difficulty difficulty) {
    state = difficulty;
  }
}

/// Provider for the difficulty level
final difficultyProvider = StateNotifierProvider<DifficultyNotifier, Difficulty>(
  (ref) => DifficultyNotifier(),
);
