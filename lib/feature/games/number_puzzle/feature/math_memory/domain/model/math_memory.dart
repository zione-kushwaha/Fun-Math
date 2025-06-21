class MathMemoryCard {
  final int id;
  final String value;
  final bool isFlipped;
  final bool isMatched;
  final bool isQuestion; // True if it's a question, false if it's an answer

  const MathMemoryCard({
    required this.id,
    required this.value,
    this.isFlipped = false,
    this.isMatched = false,
    required this.isQuestion,
  });

  MathMemoryCard copyWith({
    int? id,
    String? value,
    bool? isFlipped,
    bool? isMatched,
    bool? isQuestion,
  }) {
    return MathMemoryCard(
      id: id ?? this.id,
      value: value ?? this.value,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
      isQuestion: isQuestion ?? this.isQuestion,
    );
  }
}

class MathPair {
  final String question;
  final String answer;

  const MathPair({
    required this.question,
    required this.answer,
  });
}

class MathMemoryResult {
  final int score;
  final int timeInSeconds;
  final int matchesFound;
  final int totalMoves;

  const MathMemoryResult({
    required this.score,
    required this.timeInSeconds,
    required this.matchesFound,
    required this.totalMoves,
  });
}
