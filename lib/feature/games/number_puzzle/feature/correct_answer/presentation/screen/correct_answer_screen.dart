import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_math/core/presentation/theme/app_theme.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/presentation/provider/correct_answer_providers.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/correct_answer/presentation/widgets/option_button.dart';

import '../../../../../../../core/data/difficulty_type.dart';

class CorrectAnswerScreen extends ConsumerWidget {
  const CorrectAnswerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(correctAnswerControllerProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Correct Answer',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(correctAnswerControllerProvider.notifier).resetGame(),
          ),
          IconButton(
            icon: state.isPaused 
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
            onPressed: () {
              state.isPaused
                  ? ref.read(correctAnswerControllerProvider.notifier).resumeGame()
                  : ref.read(correctAnswerControllerProvider.notifier).pauseGame();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${state.questionNumber}/${state.totalQuestions}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildInfoCard(
                  context, 
                  'Score', 
                  state.score.toString(), 
                  Icons.stars,
                  isDarkMode,
                ),
              ],
            ),
          ),
          
          // Timer bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: state.timeLeft / _getMaxTime(ref),
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  state.timeLeft < 10 ? Colors.red : Colors.green,
                ),
                minHeight: 10,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Question
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                state.currentQuestion.question,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Answer options
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2.0,
                ),
                itemCount: state.currentQuestion.options.length,
                itemBuilder: (context, index) {
                  final option = state.currentQuestion.options[index];
                  final isSelected = index == state.selectedOption;
                  final isCorrect = option == state.currentQuestion.correctAnswer;
                  
                  return OptionButton(
                    option: option.toString(),
                    isSelected: isSelected,
                    isCorrect: isCorrect && isSelected,
                    isWrong: isSelected && !isCorrect,
                    onPressed: () => ref.read(correctAnswerControllerProvider.notifier)
                      .selectOption(index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  int _getMaxTime(WidgetRef ref) {
    final difficulty = ref.watch(correctAnswerDifficultyProvider);
    switch (difficulty) {
      case DifficultyType.easy:
        return 30;
      case DifficultyType.medium:
        return 25;
      case DifficultyType.hard:
        return 20;
      default:
        return 30;
    }
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDarkMode ? Colors.amber : Colors.amber[700],
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
