class QuickCalculation {
  final String question;
  final int answer;
  final int timeInSeconds;

  QuickCalculation({
    required this.question,
    required this.answer,
    required this.timeInSeconds,
  });

  @override
  String toString() {
    return 'QuickCalculation{question: $question, answer: $answer, timeInSeconds: $timeInSeconds}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickCalculation &&
          runtimeType == other.runtimeType &&
          question == other.question;

  @override
  int get hashCode => question.hashCode;
}
