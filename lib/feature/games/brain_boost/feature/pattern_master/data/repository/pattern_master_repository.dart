import 'dart:math';
import 'dart:ui';

import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/domain/model/pattern_master.dart';
import 'package:flutter/material.dart';

class PatternMasterRepository {
  final Random _random = Random();
  
  // Available colors for patterns
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.pink,
  ];
  
  // Available sizes for patterns
  final List<double> _sizes = [20.0, 30.0, 40.0, 50.0];
  
  /// Generate a pattern sequence with one element missing
  PatternSequence generatePatternSequence(DifficultyType difficulty) {
    // Determine sequence length based on difficulty
    final sequenceLength = _getSequenceLength(difficulty);
    
    // Select a pattern type
    final patternType = _getRandomPatternAttribute();
    
    // Generate the pattern sequence
    List<PatternItem> items = [];
    
    // Set the missing index (not first or last)
    final missingIndex = 1 + _random.nextInt(sequenceLength - 2);
    
    // Generate pattern based on the type
    switch (patternType) {
      case PatternAttribute.shape:
        items = _generateShapePattern(sequenceLength, missingIndex);
        break;
      case PatternAttribute.color:
        items = _generateColorPattern(sequenceLength, missingIndex);
        break;
      case PatternAttribute.size:
        items = _generateSizePattern(sequenceLength, missingIndex);
        break;
      case PatternAttribute.position:
        items = _generatePositionPattern(sequenceLength, missingIndex);
        break;
    }
    
    return PatternSequence(
      items: items,
      patternType: patternType,
      missingIndex: missingIndex,
    );
  }
  
  /// Get possible answers for a pattern sequence
  List<PatternItem> getPossibleAnswers(PatternSequence sequence) {
    final correctAnswer = getCorrectAnswer(sequence);
    final answers = <PatternItem>[correctAnswer];
    
    // Generate additional wrong options based on pattern type
    switch (sequence.patternType) {
      case PatternAttribute.shape:
        // Add different shapes but same color and size
        for (var i = 0; i < 3; i++) {
          var element = _getRandomElement();
          while (element == correctAnswer.element) {
            element = _getRandomElement();
          }
          
          answers.add(PatternItem(
            element: element,
            color: correctAnswer.color,
            size: correctAnswer.size,
            position: correctAnswer.position,
          ));
        }
        break;
        
      case PatternAttribute.color:
        // Add same shape but different colors
        for (var i = 0; i < 3; i++) {
          var color = _colors[_random.nextInt(_colors.length)];
          while (color == correctAnswer.color) {
            color = _colors[_random.nextInt(_colors.length)];
          }
          
          answers.add(PatternItem(
            element: correctAnswer.element,
            color: color,
            size: correctAnswer.size,
            position: correctAnswer.position,
          ));
        }
        break;
        
      case PatternAttribute.size:
        // Add same shape and color but different sizes
        for (var i = 0; i < 3; i++) {
          var size = _sizes[_random.nextInt(_sizes.length)];
          while ((size - correctAnswer.size).abs() < 5.0) {
            size = _sizes[_random.nextInt(_sizes.length)];
          }
          
          answers.add(PatternItem(
            element: correctAnswer.element,
            color: correctAnswer.color,
            size: size,
            position: correctAnswer.position,
          ));
        }
        break;
        
      case PatternAttribute.position:
        // Add same shape, color, and size but different position
        for (var i = 0; i < 3; i++) {
          var position = _random.nextInt(8);
          while (position == correctAnswer.position) {
            position = _random.nextInt(8);
          }
          
          answers.add(PatternItem(
            element: correctAnswer.element,
            color: correctAnswer.color,
            size: correctAnswer.size,
            position: position,
          ));
        }
        break;
    }
    
    // Shuffle all options
    answers.shuffle();
    
    return answers;
  }
  
  /// Get the correct answer for a pattern sequence
  PatternItem getCorrectAnswer(PatternSequence sequence) {
    final items = sequence.items;
    final missingIndex = sequence.missingIndex;
    final patternType = sequence.patternType;
    
    // The correct answer depends on the pattern type and the surrounding items
    switch (patternType) {
      case PatternAttribute.shape:
        return _determineCorrectShapePattern(items, missingIndex);
      case PatternAttribute.color:
        return _determineCorrectColorPattern(items, missingIndex);
      case PatternAttribute.size:
        return _determineCorrectSizePattern(items, missingIndex);
      case PatternAttribute.position:
        return _determineCorrectPositionPattern(items, missingIndex);
    }
  }
  
  /// Calculate score based on results and difficulty
  int calculateScore(int correctAnswers, int totalQuestions, int timeInSeconds, DifficultyType difficulty) {
    // Base score: correct answers * points per answer
    int pointsPerAnswer = difficulty == DifficultyType.easy ? 10 :
                          difficulty == DifficultyType.medium ? 15 : 20;
    
    int baseScore = correctAnswers * pointsPerAnswer;
    
    // Time bonus: faster completion gets more points
    // Average time per question (in seconds)
    final avgTimePerQuestion = timeInSeconds / totalQuestions;
    
    // Max time bonus per question
    final maxTimeBonus = difficulty == DifficultyType.easy ? 5 :
                        difficulty == DifficultyType.medium ? 8 : 10;
    
    // Time threshold for bonus
    final timeThreshold = difficulty == DifficultyType.easy ? 15 :
                         difficulty == DifficultyType.medium ? 12 : 10;
    
    // Calculate time bonus
    int timeBonus = 0;
    if (avgTimePerQuestion < timeThreshold) {
      // Faster is better, calculate bonus as percentage of max
      final bonusPercent = 1.0 - (avgTimePerQuestion / timeThreshold);
      timeBonus = (maxTimeBonus * bonusPercent * totalQuestions).round();
    }
    
    // Difficulty multiplier
    final difficultyMultiplier = difficulty == DifficultyType.easy ? 1.0 :
                                difficulty == DifficultyType.medium ? 1.25 : 1.5;
    
    // Final score
    final finalScore = ((baseScore + timeBonus) * difficultyMultiplier).round();
    
    return finalScore;
  }
  
  // Helper methods for sequence generation and answer determination
  
  /// Determine the correct shape for a pattern
  PatternItem _determineCorrectShapePattern(List<PatternItem> items, int missingIndex) {
    // Get the pattern from surrounding items
    final patternLength = _detectPatternLength(items, missingIndex);
    final patternElements = <PatternElement>[];
    
    // Collect elements in the pattern
    for (int i = 0; i < items.length; i++) {
      if (i != missingIndex) {
        patternElements.add(items[i].element);
      }
    }
    
    // Figure out which element should be at the missing position
    final correctElementIndex = missingIndex % patternLength;
    var elementsBeforePattern = 0;
    
    for (int i = 0; i < missingIndex; i++) {
      if (i % patternLength == correctElementIndex) {
        elementsBeforePattern++;
      }
    }
    
    // Find correct element from pattern
    var correctElementPattern = 0;
    for (int i = 0; i < items.length; i++) {
      if (i != missingIndex && i % patternLength == correctElementIndex) {
        correctElementPattern = i;
        break;
      }
    }
    
    return PatternItem(
      element: items[correctElementPattern].element,
      color: items[missingIndex > 0 ? missingIndex - 1 : 0].color,
      size: items[missingIndex > 0 ? missingIndex - 1 : 0].size,
      position: missingIndex,
    );
  }
  
  /// Determine the correct color for a pattern
  PatternItem _determineCorrectColorPattern(List<PatternItem> items, int missingIndex) {
    // Similar to shape pattern but for colors
    final patternLength = _detectPatternLength(items, missingIndex);
    final patternColors = <Color>[];
    
    // Collect colors in the pattern
    for (int i = 0; i < items.length; i++) {
      if (i != missingIndex) {
        patternColors.add(items[i].color);
      }
    }
    
    // Figure out which color should be at the missing position
    final correctColorIndex = missingIndex % patternLength;
    var colorsBeforePattern = 0;
    
    for (int i = 0; i < missingIndex; i++) {
      if (i % patternLength == correctColorIndex) {
        colorsBeforePattern++;
      }
    }
    
    // Find correct color from pattern
    var correctColorPattern = 0;
    for (int i = 0; i < items.length; i++) {
      if (i != missingIndex && i % patternLength == correctColorIndex) {
        correctColorPattern = i;
        break;
      }
    }
    
    return PatternItem(
      element: items[missingIndex > 0 ? missingIndex - 1 : 0].element,
      color: items[correctColorPattern].color,
      size: items[missingIndex > 0 ? missingIndex - 1 : 0].size,
      position: missingIndex,
    );
  }
  
  /// Determine the correct size for a pattern
  PatternItem _determineCorrectSizePattern(List<PatternItem> items, int missingIndex) {
    // For size, it could be incremental or repeating
    // Check if it's an incremental pattern
    bool isIncremental = true;
    double sizeIncrement = 0.0;
    
    // Check items before missing index
    if (missingIndex >= 2) {
      sizeIncrement = items[1].size - items[0].size;
      for (int i = 2; i < missingIndex; i++) {
        if ((items[i].size - items[i - 1].size - sizeIncrement).abs() > 0.1) {
          isIncremental = false;
          break;
        }
      }
    }
    
    // Check items after missing index
    if (isIncremental && items.length - missingIndex >= 2) {
      final afterIncrement = items[missingIndex + 1].size - items[missingIndex - 1].size - sizeIncrement;
      if (afterIncrement.abs() > 0.1) {
        isIncremental = false;
      }
    }
    
    if (isIncremental) {
      // Calculate size based on increment
      return PatternItem(
        element: items[missingIndex > 0 ? missingIndex - 1 : 0].element,
        color: items[missingIndex > 0 ? missingIndex - 1 : 0].color,
        size: items[missingIndex - 1].size + sizeIncrement,
        position: missingIndex,
      );
    } else {
      // It's a repeating pattern
      final patternLength = _detectPatternLength(items, missingIndex);
      final correctSizeIndex = missingIndex % patternLength;
      
      // Find correct size from pattern
      var correctSizePattern = 0;
      for (int i = 0; i < items.length; i++) {
        if (i != missingIndex && i % patternLength == correctSizeIndex) {
          correctSizePattern = i;
          break;
        }
      }
      
      return PatternItem(
        element: items[missingIndex > 0 ? missingIndex - 1 : 0].element,
        color: items[missingIndex > 0 ? missingIndex - 1 : 0].color,
        size: items[correctSizePattern].size,
        position: missingIndex,
      );
    }
  }
  
  /// Determine the correct position for a pattern
  PatternItem _determineCorrectPositionPattern(List<PatternItem> items, int missingIndex) {
    // Similar to other patterns but for position attribute
    final patternLength = _detectPatternLength(items, missingIndex);
    final patternPositions = <int>[];
    
    // Collect positions in the pattern
    for (int i = 0; i < items.length; i++) {
      if (i != missingIndex) {
        patternPositions.add(items[i].position);
      }
    }
    
    // Figure out which position should be at the missing index
    final correctPositionIndex = missingIndex % patternLength;
    
    // Find correct position from pattern
    var correctPositionPattern = 0;
    for (int i = 0; i < items.length; i++) {
      if (i != missingIndex && i % patternLength == correctPositionIndex) {
        correctPositionPattern = i;
        break;
      }
    }
    
    return PatternItem(
      element: items[missingIndex > 0 ? missingIndex - 1 : 0].element,
      color: items[missingIndex > 0 ? missingIndex - 1 : 0].color,
      size: items[missingIndex > 0 ? missingIndex - 1 : 0].size,
      position: items[correctPositionPattern].position,
    );
  }
  
  /// Detect the length of a repeating pattern
  int _detectPatternLength(List<PatternItem> items, int missingIndex) {
    // For simplicity, we'll use predefined pattern lengths based on difficulty
    // In a more complex implementation, we could detect the pattern dynamically
    return 2;  // Most patterns will repeat every 2-3 items
  }
  
  /// Generate a shape pattern
  List<PatternItem> _generateShapePattern(int length, int missingIndex) {
    final items = <PatternItem>[];
    
    // Choose a repeating pattern of shapes
    final patternLength = _random.nextInt(3) + 1; // 1-3 elements in pattern
    final shapePattern = <PatternElement>[];
    
    // Generate the base pattern
    for (int i = 0; i < patternLength; i++) {
      shapePattern.add(_getRandomElement());
    }
    
    // Generate color and size (consistent)
    final color = _colors[_random.nextInt(_colors.length)];
    final size = _sizes[_random.nextInt(_sizes.length)];
    
    // Create the sequence with pattern
    for (int i = 0; i < length; i++) {
      if (i != missingIndex) {
        items.add(PatternItem(
          element: shapePattern[i % patternLength],
          color: color,
          size: size,
          position: i,
        ));
      } else {
        // Add a placeholder for missing item (null can't be used with PatternElement)
        items.add(PatternItem(
          element: PatternElement.circle, // Will be replaced by correct answer
          color: Colors.transparent, // Make it invisible
          size: 0.0, // Zero size
          position: i,
        ));
      }
    }
    
    return items;
  }
  
  /// Generate a color pattern
  List<PatternItem> _generateColorPattern(int length, int missingIndex) {
    final items = <PatternItem>[];
    
    // Choose a repeating pattern of colors
    final patternLength = _random.nextInt(3) + 1; // 1-3 elements in pattern
    final colorPattern = <Color>[];
    
    // Generate the base pattern
    for (int i = 0; i < patternLength; i++) {
      colorPattern.add(_colors[_random.nextInt(_colors.length)]);
    }
    
    // Generate shape and size (consistent)
    final element = _getRandomElement();
    final size = _sizes[_random.nextInt(_sizes.length)];
    
    // Create the sequence with pattern
    for (int i = 0; i < length; i++) {
      if (i != missingIndex) {
        items.add(PatternItem(
          element: element,
          color: colorPattern[i % patternLength],
          size: size,
          position: i,
        ));
      } else {
        // Add a placeholder for missing item
        items.add(PatternItem(
          element: element,
          color: Colors.transparent, // Make it invisible
          size: 0.0, // Zero size
          position: i,
        ));
      }
    }
    
    return items;
  }
  
  /// Generate a size pattern
  List<PatternItem> _generateSizePattern(int length, int missingIndex) {
    final items = <PatternItem>[];
    
    // Decide between incremental or repeating pattern
    final isIncremental = _random.nextBool();
    
    // Generate shape and color (consistent)
    final element = _getRandomElement();
    final color = _colors[_random.nextInt(_colors.length)];
    
    if (isIncremental) {
      // Create an incremental pattern
      final startSize = _sizes[0]; // Smallest size
      final increment = (_sizes[_sizes.length - 1] - _sizes[0]) / length * (_random.nextBool() ? 1 : -1);
      
      for (int i = 0; i < length; i++) {
        final size = startSize + (i * increment);
        
        if (i != missingIndex) {
          items.add(PatternItem(
            element: element,
            color: color,
            size: size,
            position: i,
          ));
        } else {
          // Add a placeholder for missing item
          items.add(PatternItem(
            element: element,
            color: color,
            size: 0.0, // Zero size
            position: i,
          ));
        }
      }
    } else {
      // Choose a repeating pattern of sizes
      final patternLength = _random.nextInt(3) + 1; // 1-3 elements in pattern
      final sizePattern = <double>[];
      
      // Generate the base pattern
      for (int i = 0; i < patternLength; i++) {
        sizePattern.add(_sizes[_random.nextInt(_sizes.length)]);
      }
      
      // Create the sequence with pattern
      for (int i = 0; i < length; i++) {
        if (i != missingIndex) {
          items.add(PatternItem(
            element: element,
            color: color,
            size: sizePattern[i % patternLength],
            position: i,
          ));
        } else {
          // Add a placeholder for missing item
          items.add(PatternItem(
            element: element,
            color: color,
            size: 0.0, // Zero size
            position: i,
          ));
        }
      }
    }
    
    return items;
  }
  
  /// Generate a position pattern
  List<PatternItem> _generatePositionPattern(int length, int missingIndex) {
    final items = <PatternItem>[];
    
    // Choose a repeating pattern of positions (0-7)
    final patternLength = _random.nextInt(3) + 1; // 1-3 elements in pattern
    final positionPattern = <int>[];
    
    // Generate the base pattern
    for (int i = 0; i < patternLength; i++) {
      positionPattern.add(_random.nextInt(8)); // 8 possible positions (0-7)
    }
    
    // Generate shape, color, and size (consistent)
    final element = _getRandomElement();
    final color = _colors[_random.nextInt(_colors.length)];
    final size = _sizes[_random.nextInt(_sizes.length)];
    
    // Create the sequence with pattern
    for (int i = 0; i < length; i++) {
      if (i != missingIndex) {
        items.add(PatternItem(
          element: element,
          color: color,
          size: size,
          position: positionPattern[i % patternLength],
        ));
      } else {
        // Add a placeholder for missing item
        items.add(PatternItem(
          element: element,
          color: color,
          size: 0.0, // Zero size
          position: 0, // Default position
        ));
      }
    }
    
    return items;
  }
  
  /// Get sequence length based on difficulty
  int _getSequenceLength(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return 5;
      case DifficultyType.medium:
        return 6;
      case DifficultyType.hard:
        return 7;
    }
  }
  
  /// Get a random pattern attribute
  PatternAttribute _getRandomPatternAttribute() {
    final values = PatternAttribute.values;
    return values[_random.nextInt(values.length)];
  }
  
  /// Get a random pattern element
  PatternElement _getRandomElement() {
    final values = PatternElement.values;
    return values[_random.nextInt(values.length)];
  }
}
