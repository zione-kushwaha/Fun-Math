class CorrectAnswer {
  final String question;
  final List<int> options;
  final int correctAnswer;

  CorrectAnswer({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  @override
  String toString() {
    return 'CorrectAnswer{question: $question, options: $options, correctAnswer: $correctAnswer}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CorrectAnswer &&
          runtimeType == other.runtimeType &&
          question == other.question;

  @override
  int get hashCode => question.hashCode;
}
