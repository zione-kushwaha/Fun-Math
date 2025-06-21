import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/domain/model/correct_answer.dart';

class CorrectAnswerRepository {
  final Random _random = Random();
  
  CorrectAnswer generateQuestion(DifficultyType difficultyType) {
    switch (difficultyType) {
      case DifficultyType.easy:
        return _generateEasyQuestion();
      case DifficultyType.medium:
        return _generateMediumQuestion();
      case DifficultyType.hard:
        return _generateHardQuestion();
      default:
        return _generateEasyQuestion();
    }
  }

  CorrectAnswer _generateEasyQuestion() {
    int operationType = _random.nextInt(2); // 0: addition, 1: subtraction
    int num1, num2, correctAnswer;
    String question;
    List<int> options = [];
    
    if (operationType == 0) {
      // Addition
      num1 = _random.nextInt(10) + 1; // 1-10
      num2 = _random.nextInt(10) + 1; // 1-10
      question = '$num1 + $num2 = ?';
      correctAnswer = num1 + num2;
    } else {
      // Subtraction (ensure positive result)
      num1 = _random.nextInt(10) + 5; // 5-14
      num2 = _random.nextInt(num1) + 1; // 1 to num1
      question = '$num1 - $num2 = ?';
      correctAnswer = num1 - num2;
    }
    
    // Generate options
    options.add(correctAnswer);
    
    // Add 3 wrong options
    while (options.length < 4) {
      // Generate option +/- 5 from correct answer, but not the correct answer
      int wrongOption = correctAnswer + (_random.nextInt(11) - 5);
      if (!options.contains(wrongOption) && wrongOption >= 0) {
        options.add(wrongOption);
      }
    }
    
    // Shuffle options
    options.shuffle();
    
    return CorrectAnswer(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
    );
  }

  CorrectAnswer _generateMediumQuestion() {
    int operationType = _random.nextInt(3); // 0: addition, 1: subtraction, 2: multiplication
    int num1, num2, correctAnswer;
    String question;
    List<int> options = [];
    
    switch (operationType) {
      case 0: // Addition
        num1 = _random.nextInt(50) + 10; // 10-59
        num2 = _random.nextInt(50) + 10; // 10-59
        question = '$num1 + $num2 = ?';
        correctAnswer = num1 + num2;
        break;
      case 1: // Subtraction
        num1 = _random.nextInt(90) + 10; // 10-99
        num2 = _random.nextInt(num1 - 1) + 1; // 1-(num1-1)
        question = '$num1 - $num2 = ?';
        correctAnswer = num1 - num2;
        break;
      case 2: // Multiplication
        num1 = _random.nextInt(11) + 2; // 2-12
        num2 = _random.nextInt(11) + 2; // 2-12
        question = '$num1 × $num2 = ?';
        correctAnswer = num1 * num2;
        break;
      default:
        num1 = _random.nextInt(50) + 1;
        num2 = _random.nextInt(50) + 1;
        question = '$num1 + $num2 = ?';
        correctAnswer = num1 + num2;
        break;
    }
    
    // Generate options
    options.add(correctAnswer);
    
    // Add 3 wrong options
    while (options.length < 4) {
      // Generate option +/- 10 from correct answer, but not the correct answer
      int wrongOption = correctAnswer + (_random.nextInt(21) - 10);
      if (!options.contains(wrongOption) && wrongOption >= 0) {
        options.add(wrongOption);
      }
    }
    
    // Shuffle options
    options.shuffle();
    
    return CorrectAnswer(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
    );
  }

  CorrectAnswer _generateHardQuestion() {
    int operationType = _random.nextInt(4); // 0: addition, 1: subtraction, 2: multiplication, 3: combined
    int num1, num2, num3, correctAnswer;
    String question;
    List<int> options = [];
    
    switch (operationType) {
      case 0: // Addition
        num1 = _random.nextInt(500) + 100; // 100-599
        num2 = _random.nextInt(500) + 100; // 100-599
        question = '$num1 + $num2 = ?';
        correctAnswer = num1 + num2;
        break;
      case 1: // Subtraction
        num1 = _random.nextInt(900) + 100; // 100-999
        num2 = _random.nextInt(num1 - 50) + 50; // 50-(num1-50)
        question = '$num1 - $num2 = ?';
        correctAnswer = num1 - num2;
        break;
      case 2: // Multiplication
        num1 = _random.nextInt(21) + 5; // 5-25
        num2 = _random.nextInt(21) + 5; // 5-25
        question = '$num1 × $num2 = ?';
        correctAnswer = num1 * num2;
        break;
      case 3: // Combined
        num1 = _random.nextInt(20) + 5; // 5-24
        num2 = _random.nextInt(20) + 5; // 5-24
        num3 = _random.nextInt(10) + 2; // 2-11
        
        int combinationType = _random.nextInt(2);
        if (combinationType == 0) {
          // (num1 + num2) × num3
          question = '($num1 + $num2) × $num3 = ?';
          correctAnswer = (num1 + num2) * num3;
        } else {
          // num1 + (num2 × num3)
          question = '$num1 + ($num2 × $num3) = ?';
          correctAnswer = num1 + (num2 * num3);
        }
        break;
      default:
        num1 = _random.nextInt(50) + 1;
        num2 = _random.nextInt(50) + 1;
        question = '$num1 + $num2 = ?';
        correctAnswer = num1 + num2;
        break;
    }
    
    // Generate options
    options.add(correctAnswer);
    
    // Add 3 wrong options
    while (options.length < 4) {
      // Generate more challenging wrong options
      int deviation;
      
      if (operationType == 2) { // Multiplication
        // For multiplication, use multiplication-based errors
        // e.g., if 7 × 8 = 56, offer options like 7 × 7 = 49, 7 × 9 = 63
        deviation = (_random.nextBool() ? 1 : -1) * (_random.nextInt(2) + 1) * 
                   (operationType == 2 ? max(num1, num2) : 5);
      } else {
        // For other operations, use +/- deviations
        deviation = (_random.nextBool() ? 1 : -1) * (_random.nextInt(20) + 5);
      }
      
      int wrongOption = correctAnswer + deviation;
      if (!options.contains(wrongOption) && wrongOption >= 0) {
        options.add(wrongOption);
      }
    }
    
    // Shuffle options
    options.shuffle();
    
    return CorrectAnswer(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
    );
  }
}
