import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/domain/model/mental_arithmetic.dart';

class MentalArithmeticRepository {
  // Generate a new mental arithmetic problem
  MentalArithmetic generateProblem(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return _generateEasyProblem();
      case DifficultyType.medium:
        return _generateMediumProblem();
      case DifficultyType.hard:
        return _generateHardProblem();
    }
  }

  // Generate an easy problem (add/subtract 2 numbers)
  MentalArithmetic _generateEasyProblem() {
    Random random = Random();
    int a = random.nextInt(10) + 1; // 1-10
    int b = random.nextInt(10) + 1; // 1-10
    int operationType = random.nextInt(2); // 0: addition, 1: subtraction

    int answer;
    List<String> questionList;

    if (operationType == 0) {
      // Addition
      answer = a + b;
      questionList = ["$a + $b = ?"];
    } else {
      // Subtraction, ensure no negative result
      if (b > a) {
        int temp = a;
        a = b;
        b = temp;
      }
      answer = a - b;
      questionList = ["$a - $b = ?"];
    }

    return MentalArithmetic(questionList: questionList, answer: answer);
  }

  // Generate a medium problem (add/subtract/multiply 2-3 numbers)
  MentalArithmetic _generateMediumProblem() {
    Random random = Random();
    int operationType = random.nextInt(3); // 0: addition, 1: subtraction, 2: multiplication
    
    int answer;
    List<String> questionList;

    if (operationType == 2) {
      // Multiplication
      int a = random.nextInt(10) + 1; // 1-10
      int b = random.nextInt(10) + 1; // 1-10
      answer = a * b;
      questionList = ["$a × $b = ?"];
    } else {
      // Addition or subtraction with 3 numbers
      int a = random.nextInt(20) + 1; // 1-20
      int b = random.nextInt(15) + 1; // 1-15
      int c = random.nextInt(10) + 1; // 1-10

      if (operationType == 0) {
        // Addition
        answer = a + b + c;
        questionList = ["$a + $b + $c = ?"];
      } else {
        // Subtraction with mixed operations
        if (random.nextBool()) {
          answer = a + b - c;
          questionList = ["$a + $b - $c = ?"];
        } else {
          answer = a - b + c;
          questionList = ["$a - $b + $c = ?"];
        }
      }
    }

    return MentalArithmetic(questionList: questionList, answer: answer);
  }

  // Generate a hard problem (mixed operations, larger numbers)
  MentalArithmetic _generateHardProblem() {
    Random random = Random();
    int operationType = random.nextInt(4); // 0: complex add/sub, 1: complex mult, 2: division, 3: mixed
    
    int answer;
    List<String> questionList;

    if (operationType == 0) {
      // Complex addition/subtraction
      int a = random.nextInt(50) + 10; // 10-59
      int b = random.nextInt(30) + 10; // 10-39
      int c = random.nextInt(20) + 5;  // 5-24
      
      if (random.nextBool()) {
        answer = a + b - c;
        questionList = ["$a + $b - $c = ?"];
      } else {
        answer = a - b + c;
        questionList = ["$a - $b + $c = ?"];
      }
    } else if (operationType == 1) {
      // Multiplication with addition/subtraction
      int a = random.nextInt(9) + 2; // 2-10
      int b = random.nextInt(9) + 2; // 2-10
      int c = random.nextInt(15) + 5; // 5-19
      
      if (random.nextBool()) {
        answer = a * b + c;
        questionList = ["$a × $b + $c = ?"];
      } else {
        answer = a * b - c;
        // Ensure positive result
        if (answer < 0) {
          answer = c - a * b;
          questionList = ["$c - $a × $b = ?"];
        } else {
          questionList = ["$a × $b - $c = ?"];
        }
      }
    } else if (operationType == 2) {
      // Division with whole number result
      int b = random.nextInt(9) + 2; // 2-10
      int a = b * (random.nextInt(10) + 2); // Ensure divisible
      answer = a ~/ b;
      questionList = ["$a ÷ $b = ?"];
    } else {
      // Complex mixed operations
      int a = random.nextInt(15) + 5; // 5-19
      int b = random.nextInt(9) + 2; // 2-10
      int c = random.nextInt(9) + 2; // 2-10
      
      // (a + b) * c or a + (b * c)
      if (random.nextBool()) {
        answer = (a + b) * c;
        questionList = ["($a + $b) × $c = ?"];
      } else {
        answer = a + (b * c);
        questionList = ["$a + ($b × $c) = ?"];
      }
    }

    return MentalArithmetic(questionList: questionList, answer: answer);
  }

  // Save high score (would connect to local storage in a real app)
  Future<void> saveHighScore(DifficultyType difficulty, int score) async {
    // In a real app, this would save to storage
    print('Saved mental arithmetic high score $score for difficulty $difficulty');
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
