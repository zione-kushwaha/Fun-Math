import 'dart:async';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/race/domain/model/math_race.dart';

class MathRaceRepository {
  // Generate a new math problem
  MathProblem generateProblem(DifficultyType difficulty) {
    return MathRaceGenerator.generateMathProblem(difficulty);
  }
  
  // Simulate opponent progress based on difficulty
  int calculateOpponentProgress(
    DifficultyType difficulty, 
    int elapsedTimeInSeconds, 
    int totalDistance
  ) {
    // Simulate different opponent speeds based on difficulty
    double speedFactor;
    switch (difficulty) {
      case DifficultyType.easy:
        speedFactor = 2.0; // Slower opponent
        break;
      case DifficultyType.medium:
        speedFactor = 2.5; // Medium-speed opponent
        break;
      case DifficultyType.hard:
        speedFactor = 3.0; // Faster opponent
        break;
    }
    
    // Calculate progress based on elapsed time
    final progress = (elapsedTimeInSeconds * speedFactor).round();
    
    // Ensure it doesn't exceed total distance
    return progress < totalDistance ? progress : totalDistance;
  }
  
  // Save high score (would connect to local storage in a real app)
  Future<void> saveHighScore(DifficultyType difficulty, int score) async {
    // In a real app, this would save to storage
    print('Saved high score $score for difficulty $difficulty');
  }
  
  // Get high score (would retrieve from local storage in a real app)
  Future<int> getHighScore(DifficultyType difficulty) async {
    // In a real app, this would retrieve from storage
    switch (difficulty) {
      case DifficultyType.easy:
        return 300;
      case DifficultyType.medium:
        return 500;
      case DifficultyType.hard:
        return 700;
    }
  }
}
