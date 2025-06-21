import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/domain/model/quick_calculation.dart';

class QuickCalculationRepository {
  final Random _random = Random();
  
  QuickCalculation generateCalculation(DifficultyType difficultyType) {
    switch (difficultyType) {
      case DifficultyType.easy:
        return _generateEasyCalculation();
      case DifficultyType.medium:
        return _generateMediumCalculation();
      case DifficultyType.hard:
        return _generateHardCalculation();
      default:
        return _generateEasyCalculation();
    }
  }

  QuickCalculation _generateEasyCalculation() {
    int operationType = _random.nextInt(2); // 0: addition, 1: subtraction
    int num1, num2;
    String question;
    int answer;
    
    if (operationType == 0) {
      // Addition
      num1 = _random.nextInt(10) + 1; // 1-10
      num2 = _random.nextInt(10) + 1; // 1-10
      question = '$num1 + $num2 = ?';
      answer = num1 + num2;
    } else {
      // Subtraction (ensure positive result)
      num1 = _random.nextInt(10) + 5; // 5-14
      num2 = _random.nextInt(num1) + 1; // 1 to num1
      question = '$num1 - $num2 = ?';
      answer = num1 - num2;
    }
    
    // Easy questions have more time
    return QuickCalculation(
      question: question,
      answer: answer,
      timeInSeconds: 10,
    );
  }

  QuickCalculation _generateMediumCalculation() {
    int operationType = _random.nextInt(3); // 0: addition, 1: subtraction, 2: multiplication
    int num1, num2;
    String question;
    int answer;
    
    switch (operationType) {
      case 0: // Addition
        num1 = _random.nextInt(50) + 10; // 10-59
        num2 = _random.nextInt(50) + 10; // 10-59
        question = '$num1 + $num2 = ?';
        answer = num1 + num2;
        break;
      case 1: // Subtraction
        num1 = _random.nextInt(90) + 10; // 10-99
        num2 = _random.nextInt(num1 - 1) + 1; // 1-(num1-1)
        question = '$num1 - $num2 = ?';
        answer = num1 - num2;
        break;
      case 2: // Multiplication
        num1 = _random.nextInt(11) + 2; // 2-12
        num2 = _random.nextInt(11) + 2; // 2-12
        question = '$num1 × $num2 = ?';
        answer = num1 * num2;
        break;
      default:
        num1 = _random.nextInt(50) + 1;
        num2 = _random.nextInt(50) + 1;
        question = '$num1 + $num2 = ?';
        answer = num1 + num2;
    }
    
    // Medium questions have less time
    return QuickCalculation(
      question: question,
      answer: answer,
      timeInSeconds: 7,
    );
  }

  QuickCalculation _generateHardCalculation() {
    int operationType = _random.nextInt(4); // 0: add, 1: subtract, 2: multiply, 3: combined
    int num1, num2, num3;
    String question;
    int answer;
    
    switch (operationType) {
      case 0: // Addition
        num1 = _random.nextInt(500) + 100; // 100-599
        num2 = _random.nextInt(500) + 100; // 100-599
        question = '$num1 + $num2 = ?';
        answer = num1 + num2;
        break;
      case 1: // Subtraction
        num1 = _random.nextInt(900) + 100; // 100-999
        num2 = _random.nextInt(num1 - 50) + 50; // 50-(num1-50)
        question = '$num1 - $num2 = ?';
        answer = num1 - num2;
        break;
      case 2: // Multiplication
        num1 = _random.nextInt(21) + 5; // 5-25
        num2 = _random.nextInt(21) + 5; // 5-25
        question = '$num1 × $num2 = ?';
        answer = num1 * num2;
        break;
      case 3: // Combined
        num1 = _random.nextInt(20) + 5; // 5-24
        num2 = _random.nextInt(20) + 5; // 5-24
        num3 = _random.nextInt(10) + 2; // 2-11
        
        int combinationType = _random.nextInt(2);
        if (combinationType == 0) {
          // (num1 + num2) × num3
          question = '($num1 + $num2) × $num3 = ?';
          answer = (num1 + num2) * num3;
        } else {
          // num1 + (num2 × num3)
          question = '$num1 + ($num2 × $num3) = ?';
          answer = num1 + (num2 * num3);
        }
        break;
      default:
        num1 = _random.nextInt(50) + 1;
        num2 = _random.nextInt(50) + 1;
        question = '$num1 + $num2 = ?';
        answer = num1 + num2;
    }
    
    // Hard questions have even less time
    return QuickCalculation(
      question: question,
      answer: answer,
      timeInSeconds: 5,
    );
  }
}
