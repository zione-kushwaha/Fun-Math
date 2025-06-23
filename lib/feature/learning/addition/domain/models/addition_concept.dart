class AdditionConcept {
  final String title;
  final String description;
  final String imagePath;
  final List<String> examples;
  final String tip;
  final String funFact;
  final int level;

  AdditionConcept({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.examples,
    required this.tip,
    required this.funFact,
    required this.level,
  });
}

class AdditionConceptsList {
  static List<AdditionConcept> concepts = [
    AdditionConcept(
      title: 'Count Together',
      description: 'Addition is about combining groups of objects and counting them all together!',
      imagePath: 'assets/learning/addition/count_together.png',
      examples: ['1 apple + 2 apples = 3 apples', '2 stars + 3 stars = 5 stars'],
      tip: 'Use your fingers to help count when adding small numbers!',
      funFact: 'Did you know? The plus sign (+) we use today was first used in 1489!',
      level: 1,
    ),
    AdditionConcept(
      title: 'Number Line Jumps',
      description: 'Think of addition as jumping forward on a number line!',
      imagePath: 'assets/learning/addition/number_line.png',
      examples: [
        'Start at 3, jump 2 more spaces to get 5',
        'Start at 5, jump 4 more spaces to get 9'
      ],
      tip: 'Draw a number line to help visualize addition problems!',
      funFact: 'Hopscotch is like playing with a number line on the ground!',
      level: 1,
    ),
    AdditionConcept(
      title: 'Making 10',
      description: 'Learning combinations that make 10 helps us add bigger numbers later!',
      imagePath: 'assets/learning/addition/making_ten.png',
      examples: ['7 + 3 = 10', '6 + 4 = 10', '5 + 5 = 10'],
      tip: 'Try to memorize all the pairs of numbers that make 10!',
      funFact: 'Many counting systems around the world are based on 10 because we have 10 fingers!',
      level: 2,
    ),
    AdditionConcept(
      title: 'Doubles',
      description: 'Doubles are when you add the same number to itself!',
      imagePath: 'assets/learning/addition/doubles.png',
      examples: ['2 + 2 = 4', '5 + 5 = 10', '7 + 7 = 14'],
      tip: 'If you learn your doubles, you can use them to solve other problems!',
      funFact: 'Knowing double facts can help you learn multiplication later!',
      level: 2,
    ),
    AdditionConcept(
      title: 'Adding Zero',
      description: 'When you add zero to any number, the number stays the same!',
      imagePath: 'assets/learning/addition/adding_zero.png',
      examples: ['8 + 0 = 8', '12 + 0 = 12', '0 + 5 = 5'],
      tip: 'Zero means "none" or "nothing", so adding zero doesn\'t change anything!',
      funFact: 'Zero was invented in India over 1,500 years ago!',
      level: 1,
    ),
    AdditionConcept(
      title: 'Regrouping',
      description: 'When adding and the sum is 10 or more, we need to regroup or "carry" a digit!',
      imagePath: 'assets/learning/addition/regrouping.png',
      examples: ['8 + 5 = 13', '26 + 7 = 33'],
      tip: 'Think of carrying as making a new group of ten!',
      funFact: 'Our number system is called "base-10" because we group numbers by tens!',
      level: 3,
    ),
    AdditionConcept(
      title: 'Real-World Addition',
      description: 'Addition is everywhere in our daily lives!',
      imagePath: 'assets/learning/addition/real_world.png',
      examples: [
        'If you have 4 toy cars and get 3 more, you have 7 toy cars',
        'If you read 5 pages today and 6 pages tomorrow, you read 11 pages total'
      ],
      tip: 'Practice addition while shopping, cooking, or playing games!',
      funFact: 'Many board games use addition when counting spaces or adding up scores!',
      level: 2,
    ),
  ];

  static List<AdditionConcept> getConceptsByLevel(int level) {
    return concepts.where((concept) => concept.level <= level).toList();
  }
}
