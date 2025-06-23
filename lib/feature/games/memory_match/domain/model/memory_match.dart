import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fun_math/core/data/difficulty_type.dart';

// Base classes for memory games
class MemoryCard<T> {
  final int id;
  final T value;
  final bool isFlipped;
  final bool isMatched;
  final bool isSpecial; // Can be used for card variants and special functions

  const MemoryCard({
    required this.id,
    required this.value,
    this.isFlipped = false,
    this.isMatched = false,
    this.isSpecial = false,
  });

  MemoryCard<T> copyWith({
    int? id,
    T? value,
    bool? isFlipped,
    bool? isMatched,
    bool? isSpecial,
  }) {
    return MemoryCard<T>(
      id: id ?? this.id,
      value: value ?? this.value,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
      isSpecial: isSpecial ?? this.isSpecial,
    );
  }
}

class MemoryPair<Q, A> {
  final Q question;
  final A answer;

  const MemoryPair({
    required this.question,
    required this.answer,
  });
}

class MemoryMatchResult {
  final int score;
  final int timeInSeconds;
  final int matchesFound;
  final int totalMoves;
  final int perfectMatchStreak;
  final double accuracyPercentage;

  const MemoryMatchResult({
    required this.score,
    required this.timeInSeconds,
    required this.matchesFound,
    required this.totalMoves,
    this.perfectMatchStreak = 0,
    required this.accuracyPercentage,
  });
}

// Number Match Generator
class NumberMatchGenerator {
  static List<MemoryPair<int, int>> generateNumberPairs(DifficultyType difficulty, int pairCount) {
    final random = Random();
    final List<MemoryPair<int, int>> pairs = [];

    // Number range based on difficulty
    int minValue = 1;
    int maxValue = difficulty == DifficultyType.easy 
        ? 10 
        : (difficulty == DifficultyType.medium ? 20 : 50);

    // Generate pairs of identical numbers
    final Set<int> usedNumbers = {};

    while (pairs.length < pairCount) {
      int number = minValue + random.nextInt(maxValue - minValue + 1);
      
      // Ensure uniqueness
      if (!usedNumbers.contains(number)) {
        usedNumbers.add(number);
        pairs.add(MemoryPair<int, int>(question: number, answer: number));
      }
    }

    return pairs;
  }
}

// Equation Match Generator
class EquationMatchGenerator {
  static List<MemoryPair<String, int>> generateEquationPairs(DifficultyType difficulty, int pairCount) {
    final random = Random();
    final List<MemoryPair<String, int>> pairs = [];
    final Set<int> usedResults = {};

    while (pairs.length < pairCount) {
      int first;
      int second;
      String operator;
      int result;

      // Generate equation based on difficulty
      switch (difficulty) {
        case DifficultyType.easy:
          first = random.nextInt(10) + 1;
          second = random.nextInt(10) + 1;
          operator = ['+', '-'][random.nextInt(2)];
          if (operator == '-' && second > first) {
            final temp = first;
            first = second;
            second = temp;
          }
          result = operator == '+' ? first + second : first - second;
          break;

        case DifficultyType.medium:
          first = random.nextInt(20) + 1;
          second = random.nextInt(10) + 1;
          operator = ['+', '-', '×'][random.nextInt(3)];
          if (operator == '-' && second > first) {
            final temp = first;
            first = second;
            second = temp;
          }
          if (operator == '×') {
            first = random.nextInt(10) + 1;
          }
          result = operator == '+' 
              ? first + second 
              : (operator == '-' ? first - second : first * second);
          break;

        case DifficultyType.hard:
          first = random.nextInt(50) + 1;
          second = random.nextInt(25) + 1;
          operator = ['+', '-', '×', '÷'][random.nextInt(4)];
          
          if (operator == '-' && second > first) {
            final temp = first;
            first = second;
            second = temp;
          }
          
          if (operator == '×') {
            first = random.nextInt(12) + 1;
            second = random.nextInt(12) + 1;
          }
          
          if (operator == '÷') {
            // Ensure clean division
            second = random.nextInt(10) + 1;
            result = random.nextInt(10) + 1;
            first = second * result;
          } else {
            result = operator == '+' 
                ? first + second 
                : (operator == '-' 
                    ? first - second 
                    : first * second);
          }
          break;
      }

      // Ensure unique results
      if (!usedResults.contains(result)) {
        usedResults.add(result);
        String equation = '$first $operator $second';
        pairs.add(MemoryPair<String, int>(question: equation, answer: result));
      }
    }

    return pairs;
  }
}

// Visual Memory Generator
class VisualMemoryGenerator {
  static List<MemoryCard<Color>> generateVisualCards(DifficultyType difficulty, int totalCards) {
    final random = Random();
    final List<MemoryCard<Color>> cards = [];
    
    // Define base colors
    final List<Color> baseColors = [
      Color(0xFFE53935),   // Red
      Color(0xFF43A047),   // Green
      Color(0xFF1E88E5),   // Blue
      Color(0xFFFFB300),   // Amber
      Color(0xFF8E24AA),   // Purple
      Color(0xFF00ACC1),   // Cyan
      Color(0xFFFFB74D),   // Orange
      Color(0xFF26A69A),   // Teal
      Color(0xFFEC407A),   // Pink
      Color(0xFF7CB342),   // Light Green
      Color(0xFFAB47BC),   // Deep Purple
      Color(0xFFD81B60),   // Deep Pink
      Color(0xFF039BE5),   // Light Blue
      Color(0xFFFF7043),   // Deep Orange
      Color(0xFF42A5F5),   // Light Blue
    ];
    
    // Determine how many colors to use based on difficulty
    int colorCount;
    switch (difficulty) {
      case DifficultyType.easy:
        colorCount = 6;
        break;
      case DifficultyType.medium:
        colorCount = 8;
        break;
      case DifficultyType.hard:
        colorCount = 12;
        break;
    }
    
    // Only use the determined number of colors
    final List<Color> selectedColors = baseColors.take(colorCount).toList();
    
    // Create pairs of cards with matching colors
    int id = 0;
    for (int i = 0; i < totalCards ~/ 2; i++) {
      final Color color = selectedColors[i % selectedColors.length];
      
      cards.add(MemoryCard<Color>(id: id++, value: color));
      cards.add(MemoryCard<Color>(id: id++, value: color));
    }
    
    // Shuffle the cards
    cards.shuffle(random);
    
    return cards;
  }
}

// Speed Memory Generator
class SpeedMemoryGenerator {
  static List<MemoryCard<String>> generateSpeedCards(DifficultyType difficulty, int totalCards) {
    final random = Random();
    final List<MemoryCard<String>> cards = [];
    
    // Define symbols
    final List<String> symbols = [
      '🔵', '🟠', '🟢', '🔴', '🟣', '🟡', '⬛', '⬜',
      '🚗', '🍎', '🌈', '🎮', '🎲', '🔑', '🌟', '🎵',
      '🏆', '🎁', '🛒', '📱', '🔍', '⚽', '🎨', '🍉'
    ];
    
    // Determine how many unique symbols to use based on difficulty
    int symbolCount;
    switch (difficulty) {
      case DifficultyType.easy:
        symbolCount = 6;
        break;
      case DifficultyType.medium:
        symbolCount = 10;
        break;
      case DifficultyType.hard:
        symbolCount = 12;
        break;
    }
    
    // Only use the determined number of symbols
    final List<String> selectedSymbols = [...symbols];
    selectedSymbols.shuffle(random);
    selectedSymbols.length = symbolCount;
    
    // Create pairs of cards with matching symbols
    int id = 0;
    for (int i = 0; i < totalCards ~/ 2; i++) {
      final String symbol = selectedSymbols[i % selectedSymbols.length];
      
      cards.add(MemoryCard<String>(id: id++, value: symbol));
      cards.add(MemoryCard<String>(id: id++, value: symbol));
    }
    
    // Shuffle the cards
    cards.shuffle(random);
    
    return cards;
  }
}

// Sequence Match Generator
class SequenceMatchGenerator {
  static List<MemoryPair<List<int>, List<int>>> generateSequencePairs(DifficultyType difficulty, int pairCount) {
    final random = Random();
    final List<MemoryPair<List<int>, List<int>>> pairs = [];
    final Set<String> usedSequences = {};
    
    for (int i = 0; i < pairCount; i++) {
      List<int> sequence;
      List<int> nextValues;
      
      // Generate sequences based on difficulty
      switch (difficulty) {
        case DifficultyType.easy:
          // Arithmetic sequences with common difference
          final start = random.nextInt(5) + 1;
          final difference = random.nextInt(3) + 1;
          sequence = List.generate(3, (i) => start + i * difference);
          nextValues = [start + 3 * difference, start + 4 * difference];
          break;
          
        case DifficultyType.medium:
          // Mix of arithmetic and geometric sequences
          if (random.nextBool()) {
            // Arithmetic
            final start = random.nextInt(10) + 1;
            final difference = random.nextInt(5) + 1;
            sequence = List.generate(4, (i) => start + i * difference);
            nextValues = [start + 4 * difference, start + 5 * difference];
          } else {
            // Geometric
            final start = random.nextInt(5) + 1;
            final ratio = random.nextInt(2) + 2;
            sequence = List.generate(3, (i) => start * pow(ratio, i).toInt());
            nextValues = [
              start * pow(ratio, 3).toInt(),
              start * pow(ratio, 4).toInt()
            ];
          }
          break;
          
        case DifficultyType.hard:
          // Complex patterns
          final patternType = random.nextInt(3);
          
          if (patternType == 0) {
            // Fibonacci-like: a, b, a+b, a+2b, 2a+3b...
            final a = random.nextInt(5) + 1;
            final b = random.nextInt(5) + 1;
            sequence = [a, b, a + b, a + 2*b, 2*a + 3*b];
            nextValues = [3*a + 5*b, 5*a + 8*b];
          } else if (patternType == 1) {
            // Quadratic: an² + bn + c
            final a = random.nextInt(2) + 1;
            final b = random.nextInt(5);
            final c = random.nextInt(5);
            sequence = List.generate(4, (n) => a*n*n + b*n + c);
            nextValues = [a*4*4 + b*4 + c, a*5*5 + b*5 + c];
          } else {
            // Alternating pattern
            final a = random.nextInt(5) + 1;
            final b = random.nextInt(5) + 1;
            sequence = [a, b, a+1, b+1, a+2];
            nextValues = [b+2, a+3];
          }
          break;
      }
      
      // Ensure unique sequence
      final sequenceKey = sequence.join(',');
      if (!usedSequences.contains(sequenceKey)) {
        usedSequences.add(sequenceKey);
        pairs.add(MemoryPair<List<int>, List<int>>(
          question: sequence,
          answer: nextValues,
        ));
      } else {
        // Try again if we generated a duplicate
        i--;
      }
    }
    
    return pairs;
  }
}

// Pattern Memory Generator
class PatternMemoryGenerator {
  static List<MemoryPair<List<bool>, List<bool>>> generatePatternPairs(DifficultyType difficulty, int pairCount) {
    final random = Random();
    final List<MemoryPair<List<bool>, List<bool>>> pairs = [];
    final Set<String> usedPatterns = {};
    
    for (int i = 0; i < pairCount; i++) {
      int gridSize;
      
      // Grid size based on difficulty
      switch (difficulty) {
        case DifficultyType.easy:
          gridSize = 3;
          break;
        case DifficultyType.medium:
          gridSize = 4;
          break;
        case DifficultyType.hard:
          gridSize = 5;
          break;
      }
      
      // Generate a pattern
      List<bool> pattern = List.generate(
        gridSize * gridSize, 
        (_) => random.nextDouble() > 0.65
      );
      
      // Generate a similar pattern with some differences
      List<bool> similarPattern = List.from(pattern);
      
      // Number of cells to change
      int changeCells = difficulty == DifficultyType.easy 
          ? 1 
          : (difficulty == DifficultyType.medium ? 2 : 3);
      
      // Change some cells
      for (int j = 0; j < changeCells; j++) {
        int randomCell = random.nextInt(similarPattern.length);
        similarPattern[randomCell] = !similarPattern[randomCell];
      }
      
      // Ensure unique pattern
      final patternKey = pattern.map((b) => b ? '1' : '0').join();
      if (!usedPatterns.contains(patternKey)) {
        usedPatterns.add(patternKey);
        pairs.add(MemoryPair<List<bool>, List<bool>>(
          question: pattern,
          answer: similarPattern,
        ));
      } else {
        // Try again if we generated a duplicate
        i--;
      }
    }
    
    return pairs;
  }
}
