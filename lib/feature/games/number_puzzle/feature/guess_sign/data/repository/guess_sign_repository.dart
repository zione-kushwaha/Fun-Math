import 'dart:math';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/guess_sign/domain/model/guess_sign.dart';

class GuessSignRepository {
  final Random _random = Random();
  final List<String> _basicSigns = ['+', '-', '×', '÷'];
    GuessSign generateQuestion(DifficultyType difficultyType) {
    switch (difficultyType) {
      case DifficultyType.easy:
        return _generateEasyQuestion();
      case DifficultyType.medium:
        return _generateMediumQuestion();
      case DifficultyType.hard:
        return _generateHardQuestion();
    }
  }

  GuessSign _generateEasyQuestion() {
    String sign = _basicSigns[_random.nextInt(2)]; // Only + and -
    int num1, num2, result;
    
    switch (sign) {
      case '+':
        num1 = _random.nextInt(10) + 1; // 1-10
        num2 = _random.nextInt(10) + 1; // 1-10
        result = num1 + num2;
        break;
      case '-':
        num1 = _random.nextInt(10) + 5; // 5-14
        num2 = _random.nextInt(num1) + 1; // Ensure num2 < num1
        result = num1 - num2;
        break;
      default:
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
        result = num1 + num2;
        sign = '+';
    }
    
    return GuessSign(
      num1: num1,
      num2: num2,
      result: result,
      correctSign: sign,
      options: ['+', '-'],
    );
  }

  GuessSign _generateMediumQuestion() {
    String sign = _basicSigns[_random.nextInt(4)]; // All operations
    int num1, num2, result;
    
    switch (sign) {
      case '+':
        num1 = _random.nextInt(50) + 10; // 10-59
        num2 = _random.nextInt(50) + 10; // 10-59
        result = num1 + num2;
        break;
      case '-':
        num1 = _random.nextInt(90) + 10; // 10-99
        num2 = _random.nextInt(num1 - 1) + 1; // Ensure num2 < num1
        result = num1 - num2;
        break;
      case '×':
        num1 = _random.nextInt(10) + 2; // 2-11
        num2 = _random.nextInt(10) + 2; // 2-11
        result = num1 * num2;
        break;
      case '÷':
        num2 = _random.nextInt(10) + 2; // 2-11
        result = _random.nextInt(10) + 1; // 1-10
        num1 = num2 * result; // Ensure clean division
        break;
      default:
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
        result = num1 + num2;
        sign = '+';
    }
    
    return GuessSign(
      num1: num1,
      num2: num2,
      result: result,
      correctSign: sign,
      options: _basicSigns,
    );
  }

  GuessSign _generateHardQuestion() {
    // Additional operations for hard mode
    final List<String> hardSigns = ['^', '√', '%'];
    List<String> allSigns = [..._basicSigns, ...hardSigns];
    
    String sign = allSigns[_random.nextInt(allSigns.length)];
    int num1, num2, result;
    
    switch (sign) {
      case '+':
        num1 = _random.nextInt(500) + 100; // 100-599
        num2 = _random.nextInt(500) + 100; // 100-599
        result = num1 + num2;
        break;
      case '-':
        num1 = _random.nextInt(900) + 100; // 100-999
        num2 = _random.nextInt(num1 - 10) + 10; // Ensure num2 < num1
        result = num1 - num2;
        break;
      case '×':
        num1 = _random.nextInt(20) + 5; // 5-24
        num2 = _random.nextInt(20) + 5; // 5-24
        result = num1 * num2;
        break;
      case '÷':
        num2 = _random.nextInt(20) + 5; // 5-24
        result = _random.nextInt(10) + 1; // 1-10
        num1 = num2 * result; // Ensure clean division
        break;
      case '^':
        num1 = _random.nextInt(6) + 2; // 2-7
        num2 = _random.nextInt(3) + 2; // 2-4
        result = pow(num1, num2).toInt();
        break;
      case '%':
        num1 = _random.nextInt(90) + 10; // 10-99
        num2 = _random.nextInt(9) + 2; // 2-10
        result = num1 % num2;
        break;
      case '√':
        result = _random.nextInt(10) + 1; // 1-10
        num1 = result * result;
        num2 = 2; // Square root
        break;
      default:
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
        result = num1 + num2;
        sign = '+';
    }
    
    List<String> options = _random.nextBool() 
        ? _basicSigns 
        : _random.nextBool() ? hardSigns : allSigns.sublist(0, 4);
    
    // Ensure correct sign is in options
    if (!options.contains(sign)) {
      options[_random.nextInt(options.length)] = sign;
    }
    
    return GuessSign(
      num1: num1,
      num2: num2,
      result: result,
      correctSign: sign,
      options: options,
    );
  }
}
