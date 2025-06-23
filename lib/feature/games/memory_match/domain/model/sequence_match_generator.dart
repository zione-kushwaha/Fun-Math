import 'dart:math';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import 'package:fun_math/feature/games/memory_match/feature/sequence_match/presentation/state/sequence_match_state.dart';

// Sequence Match Generator
class SequenceMatchGenerator {
  static List<MemoryPair<List<int>, List<int>>> generateSequencePairs(DifficultyType difficulty, int pairCount) {
    final random = Random();
    final List<MemoryPair<List<int>, List<int>>> pairs = [];
    final Set<String> usedSequences = {};
    
    for (int i = 0; i < pairCount; i++) {
      List<int> sequence = [];
      List<int> nextValues = [];
      
      switch (difficulty) {
        case DifficultyType.easy:
          // Arithmetic sequences with common difference
          final start = random.nextInt(5) + 1;
          final difference = random.nextInt(3) + 1;
          sequence = List.generate(3, (i) => start + i * difference);
          nextValues = [start + 3 * difference, start + 4 * difference];
          break;
          
        case DifficultyType.medium:
          // Mix of arithmetic and geometric sequences
          if (random.nextBool()) {
            // Arithmetic
            final start = random.nextInt(10) + 1;
            final difference = random.nextInt(5) + 1;
            sequence = List.generate(4, (i) => start + i * difference);
            nextValues = [start + 4 * difference, start + 5 * difference];
          } else {
            // Geometric
            final start = random.nextInt(5) + 1;
            final ratio = random.nextInt(2) + 2;
            sequence = List.generate(3, (i) => start * pow(ratio, i).toInt());
            nextValues = [
              start * pow(ratio, 3).toInt(),
              start * pow(ratio, 4).toInt()
            ];
          }
          break;
          
        case DifficultyType.hard:
          // Complex patterns
          final patternType = random.nextInt(3);
          
          if (patternType == 0) {
            // Fibonacci-like: a, b, a+b, a+2b, 2a+3b...
            final a = random.nextInt(5) + 1;
            final b = random.nextInt(5) + 1;
            sequence = [a, b, a + b, a + 2*b, 2*a + 3*b];
            nextValues = [3*a + 5*b, 5*a + 8*b];
          } else if (patternType == 1) {
            // Quadratic: an² + bn + c
            final a = random.nextInt(2) + 1;
            final b = random.nextInt(5);
            final c = random.nextInt(5);
            sequence = List.generate(4, (n) => a*n*n + b*n + c);
            nextValues = [a*4*4 + b*4 + c, a*5*5 + b*5 + c];
          } else {
            // Alternating pattern
            final a = random.nextInt(5) + 1;
            final b = random.nextInt(5) + 1;
            sequence = [a, b, a+1, b+1, a+2];
            nextValues = [b+2, a+3];
          }
          break;
      }
      
      // Ensure unique sequence
      final sequenceKey = sequence.join(',');
      if (!usedSequences.contains(sequenceKey)) {
        usedSequences.add(sequenceKey);
        pairs.add(MemoryPair<List<int>, List<int>>(
          question: sequence,
          answer: nextValues,
        ));
      } else {
        // Try again if we generated a duplicate
        i--;
      }
    }
    
    return pairs;
  }
}
