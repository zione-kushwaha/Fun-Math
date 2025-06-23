import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/addition_concept.dart';
import '../../domain/models/addition_activity.dart';

class AdditionLearningState {
  final int currentLevel;
  final int totalStars;
  final List<AdditionConcept> unlockedConcepts;
  final List<AdditionActivity> unlockedActivities;
  final Map<String, int> activityStars; // routeName -> stars (1-3)
  final Map<String, bool> completedLessons; // title -> completed

  AdditionLearningState({
    required this.currentLevel,
    required this.totalStars,
    required this.unlockedConcepts,
    required this.unlockedActivities,
    required this.activityStars,
    required this.completedLessons,
  });

  AdditionLearningState.initial()
      : currentLevel = 1,
        totalStars = 0,
        unlockedConcepts = AdditionConceptsList.getConceptsByLevel(1),
        unlockedActivities = AdditionActivitiesList.getActivitiesByLevel(1),
        activityStars = {},
        completedLessons = {};

  AdditionLearningState copyWith({
    int? currentLevel,
    int? totalStars,
    List<AdditionConcept>? unlockedConcepts,
    List<AdditionActivity>? unlockedActivities,
    Map<String, int>? activityStars,
    Map<String, bool>? completedLessons,
  }) {
    return AdditionLearningState(
      currentLevel: currentLevel ?? this.currentLevel,
      totalStars: totalStars ?? this.totalStars,
      unlockedConcepts: unlockedConcepts ?? this.unlockedConcepts,
      unlockedActivities: unlockedActivities ?? this.unlockedActivities,
      activityStars: activityStars ?? this.activityStars,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }
}

class AdditionLearningNotifier extends StateNotifier<AdditionLearningState> {
  AdditionLearningNotifier() : super(AdditionLearningState.initial());

  void completeLesson(String lessonTitle) {
    final updatedCompletedLessons = Map<String, bool>.from(state.completedLessons);
    updatedCompletedLessons[lessonTitle] = true;
    
    state = state.copyWith(
      completedLessons: updatedCompletedLessons,
    );
    
    _checkForLevelUp();
  }

  void completeActivity(String routeName, int stars) {
    if (stars < 1 || stars > 3) return; // Validate stars range
    
    final updatedActivityStars = Map<String, int>.from(state.activityStars);
    // Only update if achieving higher stars than before
    if (updatedActivityStars[routeName] == null || stars > updatedActivityStars[routeName]!) {
      updatedActivityStars[routeName] = stars;
      
      // Calculate new total stars
      final newTotalStars = updatedActivityStars.values.fold<int>(0, (sum, stars) => sum + stars);
      
      state = state.copyWith(
        activityStars: updatedActivityStars,
        totalStars: newTotalStars,
      );
      
      _checkForLevelUp();
    }
  }

  void _checkForLevelUp() {
    // Check if player has earned enough stars/completed enough to level up
    final int nextLevel = state.currentLevel + 1;
    
    // Simplified level-up logic: every 5 stars earns a level
    if (state.totalStars >= nextLevel * 5) {
      _levelUp();
    }
  }

  void _levelUp() {
    final newLevel = state.currentLevel + 1;
    
    state = state.copyWith(
      currentLevel: newLevel,
      unlockedConcepts: AdditionConceptsList.getConceptsByLevel(newLevel),
      unlockedActivities: AdditionActivitiesList.getActivitiesByLevel(newLevel),
    );
  }

  void resetProgress() {
    state = AdditionLearningState.initial();
  }
}

final additionLearningProvider = StateNotifierProvider<AdditionLearningNotifier, AdditionLearningState>(
  (ref) => AdditionLearningNotifier(),
);
