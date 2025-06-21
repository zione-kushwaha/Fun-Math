import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_math/core/presentation/theme/app_theme.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/presentation/provider/calculator_providers.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/presentation/widgets/calculator_keypad.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorControllerProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(calculatorControllerProvider.notifier).resetGame(),
          ),
          IconButton(
            icon: state.isPaused 
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
            onPressed: () {
              state.isPaused
                  ? ref.read(calculatorControllerProvider.notifier).resumeGame()
                  : ref.read(calculatorControllerProvider.notifier).pauseGame();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Score and timer
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(
                  context,
                  'Score',
                  state.score.toString(),
                  Icons.stars,
                  isDarkMode,
                ),
                _buildInfoCard(
                  context,
                  'Time Left',
                  state.timeLeft.toString(),
                  Icons.timer,
                  isDarkMode,
                ),
              ],
            ),
          ),

          // Question display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.currentQuestion.question,
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
                  state.currentInput.isEmpty ? '?' : state.currentInput,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: state.isWrong
                        ? Colors.red
                        : state.isCorrect
                            ? Colors.green
                            : isDarkMode
                                ? Colors.white
                                : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Status indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 5,
            width: MediaQuery.of(context).size.width * 0.8,
            color: state.isWrong
                ? Colors.red
                : state.isCorrect
                    ? Colors.green
                    : isDarkMode
                        ? Colors.grey[600]
                        : Colors.grey[300],
            margin: const EdgeInsets.only(bottom: 32),
          ),

          // Keypad
          const Expanded(
            child: CalculatorKeypad(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
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
