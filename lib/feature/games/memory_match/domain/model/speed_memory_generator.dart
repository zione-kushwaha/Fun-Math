import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/feature/speed_memory/presentation/state/speed_memory_state.dart';

// Speed Memory Generator
class SpeedMemoryGenerator {
  static List<String> generateRandomSequence(DifficultyType difficulty, int length) {
    final random = Random();
    List<String> sequence = [];
    
    // Define possible values based on difficulty
    List<String> possibleValues = [];
    
    switch (difficulty) {
      case DifficultyType.easy:
        // Numbers 0-9
        possibleValues = List.generate(10, (i) => i.toString());
        break;
      case DifficultyType.medium:
        // Numbers and basic symbols
        possibleValues = [
          ...List.generate(10, (i) => i.toString()),
          '+', '-', '*', '/', '=',
        ];
        break;
      case DifficultyType.hard:
        // Numbers, symbols, and letters
        possibleValues = [
          ...List.generate(10, (i) => i.toString()),
          '+', '-', '*', '/', '=', '<', '>', 
          'A', 'B', 'C', 'D', 'E', 'F',
        ];
        break;
    }
    
    // Generate random sequence
    for (int i = 0; i < length; i++) {
      sequence.add(possibleValues[random.nextInt(possibleValues.length)]);
    }
    
    return sequence;
  }
  
  static List<SpeedMemoryCard> generateInputCards(DifficultyType difficulty) {
    final random = Random();
    List<SpeedMemoryCard> cards = [];
    
    // Define possible values based on difficulty
    List<String> possibleValues = [];
    
    switch (difficulty) {
      case DifficultyType.easy:
        // Numbers 0-9
        possibleValues = List.generate(10, (i) => i.toString());
        break;
      case DifficultyType.medium:
        // Numbers and basic symbols
        possibleValues = [
          ...List.generate(10, (i) => i.toString()),
          '+', '-', '*', '/', '=',
        ];
        break;
      case DifficultyType.hard:
        // Numbers, symbols, and letters
        possibleValues = [
          ...List.generate(10, (i) => i.toString()),
          '+', '-', '*', '/', '=', '<', '>', 
          'A', 'B', 'C', 'D', 'E', 'F',
        ];
        break;
    }
    
    // Generate cards for all possible inputs
    for (int i = 0; i < possibleValues.length; i++) {
      cards.add(SpeedMemoryCard(
        id: i,
        value: possibleValues[i],
      ));
    }
    
    return cards;
  }
}
