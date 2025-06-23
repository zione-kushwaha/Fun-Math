import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/domain/model/mental_arithmetic.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/presentation/provider/mental_arithmetic_providers.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/presentation/state/mental_arithmetic_state.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/presentation/widgets/mental_arithmetic_question_view.dart';

class MentalArithmeticScreen extends ConsumerWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const MentalArithmeticScreen({
    Key? key,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.lightBlueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(mentalArithmeticDifficultyProvider);
    final gameState = ref.watch(mentalArithmeticControllerProvider(difficulty));
    final gameController = ref.read(mentalArithmeticControllerProvider(difficulty).notifier);

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mental Arithmetic'),
          backgroundColor: primaryColor,
          actions: [
            // Score indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Score: ${gameState.score}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Timer indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Time: ${gameState.timeInSeconds}s',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          bottom: true,
          child: Container(
            margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Column(
              children: [
                // Question display
                if (gameState.currentProblem != null)
                  MentalArithmeticQuestionView(
                    currentProblem: gameState.currentProblem!,
                  ),
                
                // Results display
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      gameState.result,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Indicators for correct/wrong answers
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoBox("Correct", "${gameState.correctAnswers}", Colors.green),
                    _buildInfoBox("Wrong", "${gameState.incorrectAnswers}", Colors.red),
                  ],
                ),
                
                // Number buttons
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      // Number pad rows
                      Expanded(
                        child: Row(
                          children: [
                            _buildNumberButton("7", () => gameController.onInputNumber("7")),
                            _buildNumberButton("8", () => gameController.onInputNumber("8")),
                            _buildNumberButton("9", () => gameController.onInputNumber("9")),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _buildNumberButton("4", () => gameController.onInputNumber("4")),
                            _buildNumberButton("5", () => gameController.onInputNumber("5")),
                            _buildNumberButton("6", () => gameController.onInputNumber("6")),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _buildNumberButton("1", () => gameController.onInputNumber("1")),
                            _buildNumberButton("2", () => gameController.onInputNumber("2")),
                            _buildNumberButton("3", () => gameController.onInputNumber("3")),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _buildNumberButton("-", () => gameController.onInputNumber("-")),
                            _buildNumberButton("0", () => gameController.onInputNumber("0")),
                            _buildClearButton(() => gameController.onClear()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom action buttons
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: Text(
            number,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton(VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade100,
            foregroundColor: Colors.red.shade900,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: const Icon(Icons.backspace, size: 24),
        ),
      ),
    );
  }
}
