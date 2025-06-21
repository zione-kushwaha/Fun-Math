import 'dart:math' as math;
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/domain/model/math_memory.dart';

class MathMemoryRepository {
  final math.Random _random = math.Random();

  /// Generate math pairs based on difficulty
  List<MathPair> generateMathPairs(DifficultyType difficulty, int count) {
    final pairs = <MathPair>[];
    
    switch (difficulty) {
      case DifficultyType.easy:
        pairs.addAll(_generateEasyPairs(count));
        break;
      case DifficultyType.medium:
        pairs.addAll(_generateMediumPairs(count));
        break;
      case DifficultyType.hard:
        pairs.addAll(_generateHardPairs(count));
        break;
    }
    
    return pairs;
  }

  /// Generate cards from math pairs
  List<MathMemoryCard> generateCards(List<MathPair> pairs) {
    final cards = <MathMemoryCard>[];
    int id = 0;
    
    // Add question cards
    for (var pair in pairs) {
      cards.add(MathMemoryCard(
        id: id++,
        value: pair.question,
        isQuestion: true,
      ));
    }
    
    // Add answer cards
    for (var pair in pairs) {
      cards.add(MathMemoryCard(
        id: id++,
        value: pair.answer,
        isQuestion: false,
      ));
    }
    
    // Shuffle the cards
    cards.shuffle(_random);
    
    return cards;
  }

  /// Calculate score based on time, moves, and matches found
  int calculateScore(int timeInSeconds, int totalMoves, int matchesFound, int totalPairs, DifficultyType difficulty) {
    // Base score depends on difficulty
    final baseScore = difficulty == DifficultyType.easy ? 500 : 
                      difficulty == DifficultyType.medium ? 1000 : 1500;
    
    // Time factor - faster completion means higher score
    final maxTime = difficulty == DifficultyType.easy ? 180 : 
                    difficulty == DifficultyType.medium ? 240 : 300;
    final timeFactor = math.max(0.1, 1 - (timeInSeconds / maxTime));
    
    // Moves factor - fewer moves means higher score
    final idealMoves = totalPairs * 2; // Each pair requires 2 moves in ideal scenario
    final movesFactor = math.max(0.1, idealMoves / totalMoves);
    
    // Calculate final score
    final score = (baseScore * timeFactor * movesFactor * (matchesFound / totalPairs)).toInt();
    
    return score;
  }

  /// Check if two cards form a match
  bool isMatch(MathMemoryCard card1, MathMemoryCard card2, List<MathPair> pairs) {
    // Cards must be one question and one answer
    if (card1.isQuestion == card2.isQuestion) return false;
    
    // Get question and answer
    final question = card1.isQuestion ? card1.value : card2.value;
    final answer = card1.isQuestion ? card2.value : card1.value;
    
    // Check if they match in our pairs
    return pairs.any((pair) => pair.question == question && pair.answer == answer);
  }

  /// Get grid dimensions based on difficulty
  List<int> getGridDimensions(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return [3, 4]; // 12 cards = 6 pairs
      case DifficultyType.medium:
        return [4, 4]; // 16 cards = 8 pairs
      case DifficultyType.hard:
        return [4, 6]; // 24 cards = 12 pairs
    }
  }

  // Helper methods to generate pairs of different difficulties
  
  List<MathPair> _generateEasyPairs(int count) {
    final pairs = <MathPair>[];
    
    // Simple addition and subtraction with numbers 1-10
    for (int i = 0; i < count; i++) {
      final a = _random.nextInt(10) + 1;
      final b = _random.nextInt(10) + 1;
      
      if (_random.nextBool()) {
        // Addition
        pairs.add(MathPair(
          question: "$a + $b = ?",
          answer: "${a + b}",
        ));
      } else {
        // Subtraction (ensure positive result)
        final larger = math.max(a, b);
        final smaller = math.min(a, b);
        pairs.add(MathPair(
          question: "$larger - $smaller = ?",
          answer: "${larger - smaller}",
        ));
      }
    }
    
    return pairs;
  }
  
  List<MathPair> _generateMediumPairs(int count) {
    final pairs = <MathPair>[];
    
    // Addition, subtraction with numbers 1-20, and simple multiplication
    for (int i = 0; i < count; i++) {
      final operation = _random.nextInt(3); // 0: addition, 1: subtraction, 2: multiplication
      
      switch (operation) {
        case 0: // Addition
          final a = _random.nextInt(20) + 1;
          final b = _random.nextInt(20) + 1;
          pairs.add(MathPair(
            question: "$a + $b = ?",
            answer: "${a + b}",
          ));
          break;
        case 1: // Subtraction
          final larger = _random.nextInt(20) + 10; // 10-30
          final smaller = _random.nextInt(math.min(larger, 10)) + 1; // 1-10 or 1-larger
          pairs.add(MathPair(
            question: "$larger - $smaller = ?",
            answer: "${larger - smaller}",
          ));
          break;
        case 2: // Multiplication
          final a = _random.nextInt(10) + 1;
          final b = _random.nextInt(5) + 1;
          pairs.add(MathPair(
            question: "$a × $b = ?",
            answer: "${a * b}",
          ));
          break;
      }
    }
    
    return pairs;
  }
  
  List<MathPair> _generateHardPairs(int count) {
    final pairs = <MathPair>[];
    
    // Addition, subtraction, multiplication, division
    for (int i = 0; i < count; i++) {
      final operation = _random.nextInt(4); // 0: addition, 1: subtraction, 2: multiplication, 3: division
      
      switch (operation) {
        case 0: // Addition with larger numbers
          final a = _random.nextInt(50) + 10;
          final b = _random.nextInt(50) + 10;
          pairs.add(MathPair(
            question: "$a + $b = ?",
            answer: "${a + b}",
          ));
          break;
        case 1: // Subtraction with larger numbers
          final larger = _random.nextInt(90) + 10; // 10-100
          final smaller = _random.nextInt(larger - 5) + 5; // 5-(larger-5)
          pairs.add(MathPair(
            question: "$larger - $smaller = ?",
            answer: "${larger - smaller}",
          ));
          break;
        case 2: // Multiplication
          final a = _random.nextInt(12) + 1;
          final b = _random.nextInt(12) + 1;
          pairs.add(MathPair(
            question: "$a × $b = ?",
            answer: "${a * b}",
          ));
          break;
        case 3: // Division (ensure clean division)
          final b = _random.nextInt(10) + 1;
          final result = _random.nextInt(10) + 1;
          final a = b * result;
          pairs.add(MathPair(
            question: "$a ÷ $b = ?",
            answer: "$result",
          ));
          break;
      }
    }
    
    return pairs;
  }
}
