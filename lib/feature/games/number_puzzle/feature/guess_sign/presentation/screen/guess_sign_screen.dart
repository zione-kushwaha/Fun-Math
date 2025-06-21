import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_math/core/presentation/theme/app_theme.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/guess_sign/presentation/provider/guess_sign_providers.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/guess_sign/presentation/widgets/sign_button.dart';

import '../../../../../../../core/data/difficulty_type.dart';

class GuessSignScreen extends ConsumerWidget {
  const GuessSignScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(guessSignControllerProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guess the Sign',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(guessSignControllerProvider.notifier).resetGame(),
          ),
          IconButton(
            icon: state.isPaused 
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
            onPressed: () {
              state.isPaused
                  ? ref.read(guessSignControllerProvider.notifier).resumeGame()
                  : ref.read(guessSignControllerProvider.notifier).pauseGame();
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
                  state.timeLeft < 5 ? Colors.red : Colors.green,
                ),
                minHeight: 10,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Question display
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.currentQuestion.num1}',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: state.selectedSign.isEmpty
                          ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
                          : state.isCorrect
                              ? Colors.green
                              : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        state.selectedSign.isEmpty ? '?' : state.selectedSign,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: state.selectedSign.isEmpty
                              ? (isDarkMode ? Colors.white70 : Colors.black54)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${state.currentQuestion.num2}',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' = ',
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    '${state.currentQuestion.result}',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Sign options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: state.currentQuestion.options.map((sign) {
                return SignButton(
                  sign: sign,
                  isSelected: state.selectedSign == sign,
                  isCorrect: state.isCorrect && state.selectedSign == sign,
                  isWrong: state.isWrong && state.selectedSign == sign,
                  onPressed: () => ref.read(guessSignControllerProvider.notifier).selectSign(sign),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Instructions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Choose the correct sign that makes the equation true.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  int _getMaxTime(WidgetRef ref) {
    final difficulty = ref.watch(guessSignDifficultyProvider);
    switch (difficulty) {
      case DifficultyType.easy:
        return 20;
      case DifficultyType.medium:
        return 15;
      case DifficultyType.hard:
        return 10;
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
