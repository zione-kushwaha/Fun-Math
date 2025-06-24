import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/square_root/presentation/provider/square_root_providers.dart';

class SquareRootScreen extends ConsumerWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const SquareRootScreen({
    Key? key,
    this.primaryColor = Colors.purple,
    this.secondaryColor = Colors.purpleAccent, required DifficultyType difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(squareRootDifficultyProvider);
    final gameState = ref.watch(squareRootControllerProvider(difficulty));
    final gameController = ref.read(squareRootControllerProvider(difficulty).notifier);

    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Square Root'),
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
                style: const TextStyle(
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Stats display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoBox("Correct", "${gameState.correctAnswers}", Colors.green),
                    _buildInfoBox("Wrong", "${gameState.incorrectAnswers}", Colors.red),
                  ],
                ),

                const SizedBox(height: 24),
                
                // Question display
                if (gameState.currentProblem != null)
                  Container(
                    padding: const EdgeInsets.all(24.0),
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
                    child: Column(
                      children: [
                        Text(
                          'Find the square root:',
                          style: TextStyle(
                            fontSize: 18, 
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          gameState.currentProblem!.question,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),
                
                // Answer options
                if (gameState.currentProblem != null)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildAnswerOption(
                          context, 
                          gameState.currentProblem!.firstAns, 
                          1,
                          gameState.selectedAnswerIndex == 1,
                          () => gameController.selectAnswer(1),
                        ),
                        _buildAnswerOption(
                          context,
                          gameState.currentProblem!.secondAns,
                          2,
                          gameState.selectedAnswerIndex == 2,
                          () => gameController.selectAnswer(2),
                        ),
                        _buildAnswerOption(
                          context,
                          gameState.currentProblem!.thirdAns,
                          3,
                          gameState.selectedAnswerIndex == 3,
                          () => gameController.selectAnswer(3),
                        ),
                        _buildAnswerOption(
                          context,
                          gameState.currentProblem!.fourthAns,
                          4,
                          gameState.selectedAnswerIndex == 4,
                          () => gameController.selectAnswer(4),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Back button
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

  Widget _buildAnswerOption(
    BuildContext context,
    String answer,
    int index,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
