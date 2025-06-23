import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/math_race/feature/race/presentation/provider/math_race_providers.dart';
import 'package:fun_math/feature/games/math_race/feature/race/presentation/widgets/math_problem_panel.dart';
import 'package:go_router/go_router.dart';

class RaceScreen extends ConsumerWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final DifficultyType difficulty;
  
  const RaceScreen({
    Key? key, 
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.lightBlue,
    this.difficulty = DifficultyType.easy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mathRaceState = ref.watch(mathRaceControllerProvider(difficulty));
    final mathRaceController = ref.read(mathRaceControllerProvider(difficulty).notifier);

    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Math Race'),
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
                'Score: ${mathRaceState.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Race track visualization
              Container(
                height: 100,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    // Finish line
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 10,
                        color: Colors.black,
                        height: double.infinity,
                      ),
                    ),
                    // Player position
                    Positioned(
                      left: (MediaQuery.of(context).size.width - 32) * 
                          (mathRaceState.raceProgress.position / 100),
                      top: 20,
                      child: Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.directions_run,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Opponent position
                    Positioned(
                      left: (MediaQuery.of(context).size.width - 32) * 
                          (mathRaceState.raceProgress.opponentPosition / 100),
                      bottom: 20,
                      child: Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.directions_run,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Current problem
              if (mathRaceState.currentProblem != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryColor),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: MathProblemPanel(
                    difficulty: difficulty,
                  ),
                ),

              const SizedBox(height: 24),
              
              // Answer options
              if (mathRaceState.currentProblem != null)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: mathRaceState.currentProblem!.options.map((option) {
                    return ElevatedButton(                      onPressed: () {
                        // Find the index of the option in the options array
                        final optionIndex = mathRaceState.currentProblem!.options.indexOf(option);
                        mathRaceController.selectAnswer(optionIndex);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        option.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const Spacer(),
              
              // Game status
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your progress:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${mathRaceState.raceProgress.position}%'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Opponent progress:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${mathRaceState.raceProgress.opponentPosition}%'),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Back button
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/math_race'); // Use GoRouter for navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Back to Menu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
