import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/presentation/provider/math_grid_providers.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/presentation/state/math_grid_state.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/presentation/widgets/math_grid_cell.dart';

class MathGridScreen extends ConsumerWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const MathGridScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mathGridControllerProvider);
    
    // Check game state and show dialogs
    _checkGameState(context, ref, state);

    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Math Grid'),
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
                      'Find numbers that add up to ${state.mathGrid?.currentAnswer ?? 0}',
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
              
              // Target number display
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Target: ${state.mathGrid?.currentAnswer ?? 0}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              
              // Grid area
              Expanded(
                child: state.mathGrid != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 9,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.mathGrid!.listForSquare.length,
                              itemBuilder: (context, index) {
                                return MathGridCell(
                                  cell: state.mathGrid!.listForSquare[index],
                                  index: index,
                                  primaryColor: primaryColor,
                                );
                              },
                            ),
                          ),
                        ),
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

  void _checkGameState(BuildContext context, WidgetRef ref, MathGridState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Game over state
      if (state.status == MathGridStatus.gameOver) {
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
                  ref.read(mathGridControllerProvider.notifier).restartGame();
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
      else if (state.status == MathGridStatus.paused) {
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
                  ref.read(mathGridControllerProvider.notifier).resumeGame();
                },
                child: const Text('Resume'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(mathGridControllerProvider.notifier).restartGame();
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
    ref.read(mathGridControllerProvider.notifier).pauseGame();
    
    // Exit dialog will be shown automatically when paused state is detected
  }
}
