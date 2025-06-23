import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/domain/model/pattern_master.dart';

enum PatternMasterStatus {
  initial,
  playing,
  paused,
  completed,
  showingFeedback,
}

class PatternMasterState {
  final PatternSequence? currentSequence;
  final List<PatternItem> options;
  final int questionIndex;
  final int totalQuestions;
  final List<bool> questionResults; // True if answered correctly
  final int correctAnswers;
  final int timeInSeconds;
  final PatternMasterStatus status;
  final DifficultyType difficulty;
  final bool soundEnabled;
  final bool animationsEnabled;
  final int? selectedOptionIndex;
  final String? errorMessage;
  final bool showHelp;
  final PatternResult? result;
  final bool hasGameStarted;
  
  const PatternMasterState({
    this.currentSequence,
    this.options = const [],
    this.questionIndex = 0,
    this.totalQuestions = 10,
    this.questionResults = const [],
    this.correctAnswers = 0,
    this.timeInSeconds = 0,
    this.status = PatternMasterStatus.initial,
    this.difficulty = DifficultyType.easy,
    this.soundEnabled = true,
    this.animationsEnabled = true,
    this.selectedOptionIndex,
    this.errorMessage,
    this.showHelp = false,
    this.result,
    this.hasGameStarted = false,
  });
  
  bool get isPlaying => status == PatternMasterStatus.playing;
  bool get isPaused => status == PatternMasterStatus.paused;
  bool get isCompleted => status == PatternMasterStatus.completed;
  bool get isShowingFeedback => status == PatternMasterStatus.showingFeedback;
  bool get hasMoreQuestions => questionIndex < totalQuestions - 1;
  
  // Computed stats for result display
  PatternResult get stats {
    return result ?? PatternResult(
      score: correctAnswers * 10,
      correctAnswers: correctAnswers,
      totalQuestions: questionIndex + 1,
      timeInSeconds: timeInSeconds,
    );
  }
  
  PatternMasterState copyWith({
    PatternSequence? currentSequence,
    List<PatternItem>? options,
    int? questionIndex,
    int? totalQuestions,
    List<bool>? questionResults,
    int? correctAnswers,
    int? timeInSeconds,
    PatternMasterStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    bool? animationsEnabled,
    int? selectedOptionIndex,
    String? errorMessage,
    bool? showHelp,
    PatternResult? result,
    bool? hasGameStarted,
  }) {
    return PatternMasterState(
      currentSequence: currentSequence ?? this.currentSequence,
      options: options ?? this.options,
      questionIndex: questionIndex ?? this.questionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      questionResults: questionResults ?? this.questionResults,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      showHelp: showHelp ?? this.showHelp,
      result: result ?? this.result,
      hasGameStarted: hasGameStarted ?? this.hasGameStarted,
    );
  }
  
  PatternMasterState clearSelection() {
    return copyWith(
      selectedOptionIndex: null,
    );
  }
  
  PatternMasterState clearError() {
    return copyWith(
      errorMessage: null,
    );
  }
  
  PatternMasterState addQuestionResult(bool isCorrect) {
    final newResults = List<bool>.from(questionResults)..add(isCorrect);
    final newCorrectAnswers = isCorrect ? correctAnswers + 1 : correctAnswers;
    
    return copyWith(
      questionResults: newResults,
      correctAnswers: newCorrectAnswers,
    );
  }
}
