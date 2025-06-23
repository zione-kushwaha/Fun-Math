import 'package:flutter/material.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/state/memory_match_state.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';

typedef VisualMemoryStatus = MemoryMatchStatus;

class VisualMemoryState extends MemoryMatchState<MemoryCard<Color>, MemoryMatchResult> {
  final int? firstSelectedIndex;
  final int? secondSelectedIndex;
  final int flashTime; // Time in milliseconds to show all cards at the beginning
  final bool isShowingAll; // Whether all cards are currently shown

  const VisualMemoryState({
    required super.cards,
    super.moveCount = 0,
    super.matchesFound = 0,
    super.totalPairs = 0,
    super.timeInSeconds = 0,
    super.status = MemoryMatchStatus.initial,
    super.difficulty = DifficultyType.easy,
    super.soundEnabled = true,
    super.result,
    super.errorMessage,
    super.showHelp = false,
    super.selectedCardIndex,
    super.countdown = 3,
    this.firstSelectedIndex,
    this.secondSelectedIndex,
    this.flashTime = 2000,
    this.isShowingAll = false,
  });

  VisualMemoryState copyWith({
    List<MemoryCard<Color>>? cards,
    int? moveCount,
    int? matchesFound,
    int? totalPairs,
    int? timeInSeconds,
    MemoryMatchStatus? status,
    DifficultyType? difficulty,
    bool? soundEnabled,
    MemoryMatchResult? result,
    String? errorMessage,
    bool? showHelp,
    int? selectedCardIndex,
    int? countdown,
    int? firstSelectedIndex,
    int? secondSelectedIndex,
    int? flashTime,
    bool? isShowingAll,
    bool clearFirstSelected = false,
    bool clearSecondSelected = false,
  }) {
    return VisualMemoryState(
      cards: cards ?? this.cards,
      moveCount: moveCount ?? this.moveCount,
      matchesFound: matchesFound ?? this.matchesFound,
      totalPairs: totalPairs ?? this.totalPairs,
      timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      showHelp: showHelp ?? this.showHelp,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      countdown: countdown ?? this.countdown,
      firstSelectedIndex: clearFirstSelected ? null : (firstSelectedIndex ?? this.firstSelectedIndex),
      secondSelectedIndex: clearSecondSelected ? null : (secondSelectedIndex ?? this.secondSelectedIndex),
      flashTime: flashTime ?? this.flashTime,
      isShowingAll: isShowingAll ?? this.isShowingAll,
    );
  }
}
