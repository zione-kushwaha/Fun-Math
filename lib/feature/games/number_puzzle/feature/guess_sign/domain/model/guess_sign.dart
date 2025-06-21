class GuessSign {
  final int num1;
  final int num2;
  final int result;
  final String correctSign;
  final List<String> options;

  GuessSign({
    required this.num1,
    required this.num2,
    required this.result,
    required this.correctSign,
    required this.options,
  });

  @override
  String toString() {
    return 'GuessSign{num1: $num1, num2: $num2, result: $result, correctSign: $correctSign}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuessSign &&
          runtimeType == other.runtimeType &&
          num1 == other.num1 &&
          num2 == other.num2 &&
          result == other.result;

  @override
  int get hashCode => Object.hash(num1, num2, result);
}
