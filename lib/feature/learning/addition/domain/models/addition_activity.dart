class AdditionActivity {
  final String title;
  final String description;
  final String imagePath;
  final String routeName;
  final int level;
  final bool isLocked;
  final int? starRating;
  final ActivityType type;

  AdditionActivity({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.routeName,
    required this.level,
    this.isLocked = false,
    this.starRating,
    required this.type,
  });
}

enum ActivityType {
  lesson,
  game,
  quiz,
  challenge
}

class AdditionActivitiesList {
  static List<AdditionActivity> activities = [
    AdditionActivity(
      title: 'Counting Adventure',
      description: 'Learn how addition works by counting objects together!',
      imagePath: 'assets/learning/addition/counting_adventure.png',
      routeName: '/learning/addition/counting_adventure',
      level: 1,
      isLocked: false,
      type: ActivityType.lesson,
    ),
    AdditionActivity(
      title: 'Number Friends',
      description: 'Find pairs of numbers that are friends! Learn which numbers add up together.',
      imagePath: 'assets/learning/addition/number_friends.png',
      routeName: '/learning/addition/number_friends',
      level: 1,
      isLocked: false,
      type: ActivityType.game,
    ),
    AdditionActivity(
      title: 'Addition Machine',
      description: 'Feed numbers to the hungry addition machine and see what comes out!',
      imagePath: 'assets/learning/addition/addition_machine.png',
      routeName: '/learning/addition/addition_machine',
      level: 1,
      isLocked: false,
      type: ActivityType.game,
    ),
    AdditionActivity(
      title: 'Space Addition',
      description: 'Help the astronaut collect stars by solving addition problems!',
      imagePath: 'assets/learning/addition/space_addition.png',
      routeName: '/learning/addition/space_addition',
      level: 2,
      isLocked: true,
      type: ActivityType.game,
    ),
    AdditionActivity(
      title: 'Ten Frame Fun',
      description: 'Learn how to use ten frames to visualize addition!',
      imagePath: 'assets/learning/addition/ten_frame.png',
      routeName: '/learning/addition/ten_frame',
      level: 2,
      isLocked: true,
      type: ActivityType.lesson,
    ),
    AdditionActivity(
      title: 'Addition Quiz',
      description: 'Test your addition skills with fun questions!',
      imagePath: 'assets/learning/addition/addition_quiz.png',
      routeName: '/learning/addition/quiz',
      level: 2,
      isLocked: true,
      type: ActivityType.quiz,
    ),
    AdditionActivity(
      title: 'Cookie Addition',
      description: 'Help the chef count cookies for a big party!',
      imagePath: 'assets/learning/addition/cookie_addition.png',
      routeName: '/learning/addition/cookie_addition',
      level: 3,
      isLocked: true,
      type: ActivityType.game,
    ),
    AdditionActivity(
      title: 'Addition Master',
      description: 'Take on challenging addition problems and become an Addition Master!',
      imagePath: 'assets/learning/addition/addition_master.png',
      routeName: '/learning/addition/master',
      level: 3,
      isLocked: true,
      type: ActivityType.challenge,
    ),
  ];

  static List<AdditionActivity> getActivitiesByLevel(int level) {
    return activities
        .where((activity) => activity.level <= level)
        .toList();
  }
}
