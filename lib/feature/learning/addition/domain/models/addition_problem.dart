class AdditionProblem {
  final int firstNumber;
  final int secondNumber;
  final List<int>? options;
  final String? context;
  final String? visualAid;

  AdditionProblem({
    required this.firstNumber,
    required this.secondNumber,
    this.options,
    this.context,
    this.visualAid,
  });

  int get solution => firstNumber + secondNumber;

  String get equation => '$firstNumber + $secondNumber = ?';

  String get equationWithSolution => '$firstNumber + $secondNumber = $solution';
}

class AdditionProblemGenerator {
  static AdditionProblem generateSimpleProblem(int maxSum) {
    // Generate random addition problem where sum doesn't exceed maxSum
    final solution = 1 + (DateTime.now().millisecondsSinceEpoch % maxSum);
    final firstNumber = solution > 1 ? (DateTime.now().microsecondsSinceEpoch % solution) : 0;
    final secondNumber = solution - firstNumber;

    return AdditionProblem(
      firstNumber: firstNumber,
      secondNumber: secondNumber,
    );
  }

  static AdditionProblem generateProblemWithOptions(int maxSum, {int numberOfOptions = 4}) {
    final problem = generateSimpleProblem(maxSum);

    // Generate multiple-choice options including the correct answer
    final List<int> options = [problem.solution];

    while (options.length < numberOfOptions) {
      // Generate a random incorrect answer that's reasonably close to the right answer
      final randomOffset = (DateTime.now().microsecondsSinceEpoch % 5) + 1;
      final randomFactor = DateTime.now().millisecondsSinceEpoch % 2 == 0 ? 1 : -1; 
      final wrongAnswer = problem.solution + (randomOffset * randomFactor);
      
      // Only add positive numbers and avoid duplicates
      if (wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }

    // Shuffle options
    options.shuffle();

    return AdditionProblem(
      firstNumber: problem.firstNumber,
      secondNumber: problem.secondNumber,
      options: options,
    );
  }

  static AdditionProblem generateContextProblem(int maxSum) {
    final problem = generateSimpleProblem(maxSum);
    
    // List of kid-friendly contexts for addition problems
    final contexts = [
      'If you have ${problem.firstNumber} apples and get ${problem.secondNumber} more, how many apples do you have now?',
      'You see ${problem.firstNumber} birds on a tree. Then ${problem.secondNumber} more birds join them. How many birds are there now?',
      'You have ${problem.firstNumber} toy cars. Your friend gives you ${problem.secondNumber} more toy cars. How many toy cars do you have now?',
      'There are ${problem.firstNumber} children playing. Then ${problem.secondNumber} more children join. How many children are playing now?',
      'You collect ${problem.firstNumber} stickers on Monday and ${problem.secondNumber} more stickers on Tuesday. How many stickers did you collect in total?',
      'There are ${problem.firstNumber} fish in a pond. ${problem.secondNumber} more fish swim into the pond. How many fish are in the pond now?',
      'You read ${problem.firstNumber} pages of a book before lunch and ${problem.secondNumber} pages after lunch. How many pages did you read in total?',
    ];

    final randomIndex = DateTime.now().millisecondsSinceEpoch % contexts.length;
    final context = contexts[randomIndex];

    return AdditionProblem(
      firstNumber: problem.firstNumber,
      secondNumber: problem.secondNumber,
      context: context,
    );
  }

  static List<AdditionProblem> generateProblemSet(int count, int maxSum, {bool withContext = false}) {
    final List<AdditionProblem> problems = [];
    
    for (int i = 0; i < count; i++) {
      if (withContext) {
        problems.add(generateContextProblem(maxSum));
      } else {
        problems.add(generateProblemWithOptions(maxSum));
      }
    }
    
    return problems;
  }
}
