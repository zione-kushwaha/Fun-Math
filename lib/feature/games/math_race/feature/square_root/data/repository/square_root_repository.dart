import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/domain/model/square_root.dart';

class SquareRootRepository {
  // Generate a new square root problem
  SquareRoot generateProblem(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return _generateEasyProblem();
      case DifficultyType.medium:
        return _generateMediumProblem();
      case DifficultyType.hard:
        return _generateHardProblem();
    }
  }

  // Generate an easy square root problem (smaller numbers, simple operations)
  SquareRoot _generateEasyProblem() {
    final random = Random();
    final correctAnswer = random.nextInt(10) + 1; // 1-10
    
    final question = "√${correctAnswer * correctAnswer} = ?";
    
    // Generate 3 wrong answers (unique and different from correct)
    final wrongAnswers = <int>[];
    while (wrongAnswers.length < 3) {
      final wrongAnswer = random.nextInt(15) + 1; // 1-15
      if (wrongAnswer != correctAnswer && !wrongAnswers.contains(wrongAnswer)) {
        wrongAnswers.add(wrongAnswer);
      }
    }
    
    // Combine all answers and shuffle them
    final allAnswers = [correctAnswer, ...wrongAnswers];
    allAnswers.shuffle();
    
    // Find the position of the correct answer (1-based)
    final correctAnswerPosition = allAnswers.indexOf(correctAnswer) + 1;
    
    return SquareRoot(
      question,
      allAnswers[0].toString(),
      allAnswers[1].toString(),
      allAnswers[2].toString(),
      allAnswers[3].toString(),
      correctAnswerPosition,
    );
  }

  // Generate a medium square root problem (medium-sized numbers, slightly more complex)
  SquareRoot _generateMediumProblem() {
    final random = Random();
    final correctAnswer = random.nextInt(15) + 6; // 6-20
    
    final question = "√${correctAnswer * correctAnswer} = ?";
    
    // Generate 3 wrong answers (unique and different from correct)
    final wrongAnswers = <int>[];
    while (wrongAnswers.length < 3) {
      final wrongAnswer = random.nextInt(20) + 1; // 1-20
      if (wrongAnswer != correctAnswer && !wrongAnswers.contains(wrongAnswer)) {
        wrongAnswers.add(wrongAnswer);
      }
    }
    
    // Combine all answers and shuffle them
    final allAnswers = [correctAnswer, ...wrongAnswers];
    allAnswers.shuffle();
    
    // Find the position of the correct answer (1-based)
    final correctAnswerPosition = allAnswers.indexOf(correctAnswer) + 1;
    
    return SquareRoot(
      question,
      allAnswers[0].toString(),
      allAnswers[1].toString(),
      allAnswers[2].toString(),
      allAnswers[3].toString(),
      correctAnswerPosition,
    );
  }

  // Generate a hard square root problem (larger numbers, more complex)
  SquareRoot _generateHardProblem() {
    final random = Random();
    final correctAnswer = random.nextInt(20) + 11; // 11-30
    
    final question = "√${correctAnswer * correctAnswer} = ?";
    
    // Generate 3 wrong answers (unique and different from correct)
    final wrongAnswers = <int>[];
    while (wrongAnswers.length < 3) {
      final wrongAnswer = random.nextInt(30) + 1; // 1-30
      if (wrongAnswer != correctAnswer && !wrongAnswers.contains(wrongAnswer)) {
        wrongAnswers.add(wrongAnswer);
      }
    }
    
    // Combine all answers and shuffle them
    final allAnswers = [correctAnswer, ...wrongAnswers];
    allAnswers.shuffle();
    
    // Find the position of the correct answer (1-based)
    final correctAnswerPosition = allAnswers.indexOf(correctAnswer) + 1;
    
    return SquareRoot(
      question,
      allAnswers[0].toString(),
      allAnswers[1].toString(),
      allAnswers[2].toString(),
      allAnswers[3].toString(),
      correctAnswerPosition,
    );
  }
  
  // Save high score (would connect to local storage in a real app)
  Future<void> saveHighScore(DifficultyType difficulty, int score) async {
    // In a real app, this would save to storage
    print('Saved square root high score $score for difficulty $difficulty');
  }
  
  // Get high score (would retrieve from local storage in a real app)
  Future<int> getHighScore(DifficultyType difficulty) async {
    // In a real app, this would retrieve from storage
    switch (difficulty) {
      case DifficultyType.easy:
        return 50;
      case DifficultyType.medium:
        return 100;
      case DifficultyType.hard:
        return 150;
    }
  }
}
