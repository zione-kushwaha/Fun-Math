import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/domain/model/math_pairs.dart';

class MathPairsRepository {
  final Random _random = Random();
  
  MathPairs generateMathPairs(DifficultyType difficultyType) {
    int size = 12; // 3x4 grid
    List<Pair> pairs = [];
    List<int> uids = [];
    
    // Generate unique UIDs
    for (int i = 0; i < size ~/ 2; i++) {
      uids.add(i);
    }
    
    // Create pairs with matching UIDs
    for (int uid in uids) {
      // First value (equation)
      int a, b, result;
      String operatorSymbol;
      
      switch (difficultyType) {
        case DifficultyType.easy:
          a = _random.nextInt(10) + 1;
          b = _random.nextInt(10) + 1;
          break;
        case DifficultyType.medium:
          a = _random.nextInt(20) + 1;
          b = _random.nextInt(20) + 1;
          break;
        case DifficultyType.hard:
          a = _random.nextInt(50) + 1;
          b = _random.nextInt(30) + 1;
          break;
      }
      
      // Randomly choose operator
      int operatorChoice = _random.nextInt(4);
      switch (operatorChoice) {
        case 0:
          result = a + b;
          operatorSymbol = "+";
          break;
        case 1:
          // Ensure a > b for subtraction
          if (a < b) {
            int temp = a;
            a = b;
            b = temp;
          }
          result = a - b;
          operatorSymbol = "-";
          break;
        case 2:
          result = a * b;
          operatorSymbol = "×";
          break;
        case 3:
          // Ensure division results in an integer
          result = a;
          a = result * b;
          operatorSymbol = "÷";
          break;
        default:
          result = a + b;
          operatorSymbol = "+";
      }
      
      // Create the equation pair
      String equationText = "$a $operatorSymbol $b";
      pairs.add(Pair(uid, equationText, false, true));
      
      // Create the result pair
      pairs.add(Pair(uid, result.toString(), false, true));
    }
    
    // Shuffle the pairs
    pairs.shuffle();
    
    return MathPairs(pairs, pairs.length);
  }
}
