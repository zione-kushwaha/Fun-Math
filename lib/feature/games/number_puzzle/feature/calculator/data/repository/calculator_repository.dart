import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/domain/model/calculator.dart';


class CalculatorRepository {
  final Random _random = Random();
  
  Calculator generateCalculatorQuestion(DifficultyType difficultyType) {
    switch (difficultyType) {
      case DifficultyType.easy:
        return _generateEasyQuestion();
      case DifficultyType.medium:
        return _generateMediumQuestion();
      case DifficultyType.hard:
        return _generateHardQuestion();
      }
  }

  Calculator _generateEasyQuestion() {
    int num1 = _random.nextInt(10) + 1; // 1-10
    int num2 = _random.nextInt(10) + 1; // 1-10
    
    String question = '$num1 + $num2';
    int answer = num1 + num2;
    
    return Calculator(question: question, answer: answer);
  }

  Calculator _generateMediumQuestion() {
    int operationType = _random.nextInt(3); // 0: add, 1: subtract, 2: multiply
    int num1, num2, answer;
    String question;
    
    switch (operationType) {
      case 0: // Addition
        num1 = _random.nextInt(50) + 10; // 10-59
        num2 = _random.nextInt(50) + 10; // 10-59
        question = '$num1 + $num2';
        answer = num1 + num2;
        break;
      case 1: // Subtraction
        num1 = _random.nextInt(90) + 10; // 10-99
        num2 = _random.nextInt(num1 - 1) + 1; // 1-(num1-1)
        question = '$num1 - $num2';
        answer = num1 - num2;
        break;
      case 2: // Multiplication
        num1 = _random.nextInt(11) + 2; // 2-12
        num2 = _random.nextInt(11) + 2; // 2-12
        question = '$num1 × $num2';
        answer = num1 * num2;
        break;
      default:
        num1 = _random.nextInt(50) + 1;
        num2 = _random.nextInt(50) + 1;
        question = '$num1 + $num2';
        answer = num1 + num2;
    }
    
    return Calculator(question: question, answer: answer);
  }

  Calculator _generateHardQuestion() {
    int operationType = _random.nextInt(4); // 0: add, 1: subtract, 2: multiply, 3: combined
    int num1, num2, num3, answer;
    String question;
    
    switch (operationType) {
      case 0: // Addition
        num1 = _random.nextInt(500) + 100; // 100-599
        num2 = _random.nextInt(500) + 100; // 100-599
        question = '$num1 + $num2';
        answer = num1 + num2;
        break;
      case 1: // Subtraction
        num1 = _random.nextInt(900) + 100; // 100-999
        num2 = _random.nextInt(num1 - 50) + 50; // 50-(num1-50)
        question = '$num1 - $num2';
        answer = num1 - num2;
        break;
      case 2: // Multiplication
        num1 = _random.nextInt(21) + 5; // 5-25
        num2 = _random.nextInt(21) + 5; // 5-25
        question = '$num1 × $num2';
        answer = num1 * num2;
        break;
      case 3: // Combined
        num1 = _random.nextInt(50) + 10; // 10-59
        num2 = _random.nextInt(50) + 10; // 10-59
        num3 = _random.nextInt(10) + 2; // 2-11
        
        // (num1 + num2) × num3
        question = '($num1 + $num2) × $num3';
        answer = (num1 + num2) * num3;
        break;
      default:
        num1 = _random.nextInt(50) + 1;
        num2 = _random.nextInt(50) + 1;
        question = '$num1 + $num2';
        answer = num1 + num2;
    }
    
    return Calculator(question: question, answer: answer);
  }
}
