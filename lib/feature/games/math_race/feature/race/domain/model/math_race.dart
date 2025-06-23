import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';

class MathProblem {
  final int firstNumber;
  final int secondNumber;
  final String operator;
  final int correctAnswer;
  final List<int> options;
  
  MathProblem({
    required this.firstNumber,
    required this.secondNumber,
    required this.operator,
    required this.correctAnswer,
    required this.options,
  });
}

class RaceProgress {
  final int position; // Player's current position (0-100)
  final int opponentPosition; // Opponent's current position (0-100)
  final int totalDistance; // Total race distance (usually 100)
  
  const RaceProgress({
    this.position = 0,
    this.opponentPosition = 0,
    this.totalDistance = 100,
  });
  
  bool get isPlayerWinning => position > opponentPosition;
  bool get isRaceFinished => position >= totalDistance || opponentPosition >= totalDistance;
  bool get isPlayerWinner => position >= totalDistance && position > opponentPosition;
  bool get isTie => position >= totalDistance && position == opponentPosition;
  
  double get playerProgressPercent => position / totalDistance;
  double get opponentProgressPercent => opponentPosition / totalDistance;
  
  RaceProgress copyWith({
    int? position,
    int? opponentPosition,
    int? totalDistance,
  }) {
    return RaceProgress(
      position: position ?? this.position,
      opponentPosition: opponentPosition ?? this.opponentPosition,
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }
}

class MathRaceResult {
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final int timeInSeconds;
  final bool isWinner;
  
  MathRaceResult({
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeInSeconds,
    required this.isWinner,
  });
  
  double get accuracyPercent => 
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
}

class MathRaceGenerator {
  static MathProblem generateMathProblem(DifficultyType difficulty) {
    final random = Random();
    
    int firstNumber;
    int secondNumber;
    String operator;
    int correctAnswer;
    
    switch(difficulty) {
      case DifficultyType.easy:
        // Easy: Addition and subtraction of numbers between 1-20
        firstNumber = random.nextInt(20) + 1;
        secondNumber = random.nextInt(20) + 1;
        operator = random.nextBool() ? '+' : '-';
        
        // Make sure subtraction doesn't result in negative numbers
        if (operator == '-' && secondNumber > firstNumber) {
          final temp = firstNumber;
          firstNumber = secondNumber;
          secondNumber = temp;
        }
        
        correctAnswer = operator == '+' 
            ? firstNumber + secondNumber 
            : firstNumber - secondNumber;
        break;
        
      case DifficultyType.medium:
        // Medium: All operations with larger numbers
        firstNumber = random.nextInt(50) + 1;
        secondNumber = random.nextInt(30) + 1;
        
        // Choose operator: +, -, × (simple cases)
        final operatorIndex = random.nextInt(3);
        operator = ['+', '-', '×'][operatorIndex];
        
        // Ensure sensible problems
        if (operator == '-' && secondNumber > firstNumber) {
          final temp = firstNumber;
          firstNumber = secondNumber;
          secondNumber = temp;
        }
        
        // For multiplication, use smaller numbers
        if (operator == '×') {
          secondNumber = random.nextInt(12) + 1;
        }
        
        // Calculate correct answer
        switch (operator) {
          case '+':
            correctAnswer = firstNumber + secondNumber;
            break;
          case '-':
            correctAnswer = firstNumber - secondNumber;
            break;
          default: // ×
            correctAnswer = firstNumber * secondNumber;
            break;
        }
        break;
        
      case DifficultyType.hard:
        // Hard: All operations with larger numbers including division
        firstNumber = random.nextInt(100) + 1;
        secondNumber = random.nextInt(50) + 1;
        
        // Choose operator: +, -, ×, ÷
        final operatorIndex = random.nextInt(4);
        operator = ['+', '-', '×', '÷'][operatorIndex];
        
        // Ensure sensible problems
        if (operator == '-' && secondNumber > firstNumber) {
          final temp = firstNumber;
          firstNumber = secondNumber;
          secondNumber = temp;
        }
        
        // For multiplication, use smaller numbers
        if (operator == '×') {
          secondNumber = random.nextInt(20) + 1;
        }
        
        // For division, ensure the result is a whole number
        if (operator == '÷') {
          if (secondNumber == 0) secondNumber = 1; // Avoid division by zero
          // Make firstNumber a multiple of secondNumber
          correctAnswer = random.nextInt(20) + 1;
          firstNumber = correctAnswer * secondNumber;
        } else {
          // Calculate correct answer for non-division operations
          switch (operator) {
            case '+':
              correctAnswer = firstNumber + secondNumber;
              break;
            case '-':
              correctAnswer = firstNumber - secondNumber;
              break;
            default: // ×
              correctAnswer = firstNumber * secondNumber;
              break;
          }
        }
        break;
    }
    
    // Generate options including the correct answer
    final Set<int> optionSet = {correctAnswer};
    
    // Add random incorrect options
    while (optionSet.length < 4) {
      // Generate a wrong answer within a reasonable range of the correct answer
      int wrongOption;
      if (operator == '+' || operator == '-') {
        // For addition/subtraction, options are within ±30% of correct answer
        final offset = max(5, (correctAnswer * 0.3).round());
        wrongOption = correctAnswer + random.nextInt(offset * 2) - offset;
        
        // Ensure no negative options for elementary-level math
        if (wrongOption < 0) wrongOption = random.nextInt(correctAnswer + 5);
      } else if (operator == '×') {
        // For multiplication, options are within ±50% of correct answer
        final offset = max(5, (correctAnswer * 0.5).round());
        wrongOption = correctAnswer + random.nextInt(offset * 2) - offset;
        
        // Ensure no negative options for elementary-level math
        if (wrongOption < 0) wrongOption = random.nextInt(correctAnswer + 10);
      } else {
        // For division, options are small variations
        wrongOption = correctAnswer + random.nextInt(5) - 2;
        if (wrongOption <= 0) wrongOption = random.nextInt(5) + 1;
      }
      
      optionSet.add(wrongOption);
    }
    
    // Convert the set to a list and shuffle it
    final options = optionSet.toList()..shuffle();
    
    return MathProblem(
      firstNumber: firstNumber,
      secondNumber: secondNumber,
      operator: operator,
      correctAnswer: correctAnswer,
      options: options,
    );
  }
}
