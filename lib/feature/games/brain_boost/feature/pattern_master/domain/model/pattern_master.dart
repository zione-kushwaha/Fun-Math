import 'dart:ui';

enum PatternElement {
  circle,
  square,
  triangle,
  hexagon,
  diamond,
  star,
  cross,
  heart
}

enum PatternAttribute {
  shape,
  color,
  size,
  position
}

class PatternItem {
  final PatternElement element;
  final Color color;
  final double size;
  final int position; // Position in the sequence

  const PatternItem({
    required this.element,
    required this.color,
    required this.size,
    required this.position,
  });
  
  PatternItem copyWith({
    PatternElement? element,
    Color? color,
    double? size,
    int? position,
  }) {
    return PatternItem(
      element: element ?? this.element,
      color: color ?? this.color,
      size: size ?? this.size,
      position: position ?? this.position,
    );
  }
}

class PatternSequence {
  final List<PatternItem> items;
  final PatternAttribute patternType; // The attribute that follows a pattern
  final int missingIndex; // Index of the missing element
  
  const PatternSequence({
    required this.items,
    required this.patternType,
    required this.missingIndex,
  });
  
  PatternSequence copyWith({
    List<PatternItem>? items,
    PatternAttribute? patternType,
    int? missingIndex,
  }) {
    return PatternSequence(
      items: items ?? this.items,
      patternType: patternType ?? this.patternType,
      missingIndex: missingIndex ?? this.missingIndex,
    );
  }
}

class PatternResult {
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final int timeInSeconds;
  
  const PatternResult({
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeInSeconds,
  });
  
  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
  
  PatternResult copyWith({
    int? score,
    int? correctAnswers,
    int? totalQuestions,
    int? timeInSeconds,
  }) {
    return PatternResult(
      score: score ?? this.score,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
    );
  }
}
