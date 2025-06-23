import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/presentation/provider/math_pairs_providers.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/presentation/state/math_pairs_state.dart';
import 'package:fun_math/feature/games/math_race/feature/math_pairs/presentation/widgets/math_pairs_card.dart';

class MathPairsScreen extends ConsumerWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const MathPairsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mathPairsControllerProvider);
    
    // Check game state and show dialogs
    _checkGameState(context, ref, state);

    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Math Pairs'),
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _showExitDialog(context, ref),
          ),
          actions: [
            // Score indicator
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  'Score: ${state.score}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Info panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Match pairs of equations and their results',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Timer indicator
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Time left: ${state.timeLeft}s',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Game area
              Expanded(
                child: state.mathPairs != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: state.mathPairs!.list.length,
                        itemBuilder: (context, index) {
                          return MathPairsCard(
                            pair: state.mathPairs!.list[index],
                            index: index,
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
                          );
                        },
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkGameState(BuildContext context, WidgetRef ref, MathPairsState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Game over state
      if (state.status == MathPairsStatus.gameOver) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Game Over'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Your score: ${state.score}'),
                Text('High score: ${state.highScore}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  ref.read(mathPairsControllerProvider.notifier).restartGame();
                },
                child: const Text('Play Again'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Return to previous screen
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );
      }
      
      // Paused state
      else if (state.status == MathPairsStatus.paused) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Game Paused'),
            content: const Text('What would you like to do?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(mathPairsControllerProvider.notifier).resumeGame();
                },
                child: const Text('Resume'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(mathPairsControllerProvider.notifier).restartGame();
                },
                child: const Text('Restart'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Return to previous screen
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _showExitDialog(BuildContext context, WidgetRef ref) {
    ref.read(mathPairsControllerProvider.notifier).pauseGame();
    
    // Exit dialog will be shown automatically when paused state is detected
  }
}
