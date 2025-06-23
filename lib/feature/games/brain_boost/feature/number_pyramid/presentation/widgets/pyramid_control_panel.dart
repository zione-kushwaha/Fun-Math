import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/provider/number_pyramid_providers.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/state/number_pyramid_state.dart';

class PyramidControlPanel extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const PyramidControlPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(numberPyramidControllerProvider(difficulty));
    final controller = ref.read(numberPyramidControllerProvider(difficulty).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: state.isPlaying ? Icons.pause : Icons.play_arrow,
            label: state.isPlaying ? 'Pause' : 'Start',
            color: state.isPlaying ? Colors.orange : Colors.green,
            onTap: () {
              if (state.isPlaying) {
                controller.pauseGame();
              } else if (state.isPaused) {
                controller.resumeGame();
              } else {
                controller.startGame();
              }
            },
          ),
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            color: Colors.blue,
            onTap: () {
              controller.resetGame();
            },
          ),
          _buildControlButton(
            icon: Icons.lightbulb_outline,
            label: 'Hint',
            color: Colors.amber,
            onTap: () {
              controller.useHint();
            },
          ),
          _buildControlButton(
            icon: Icons.help_outline,
            label: 'Help',
            color: Colors.purple,
            onTap: () {
              controller.toggleHelp();
              _showHelpDialog(context);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showHelpDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Number Pyramid Rules:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.purpleAccent : Colors.purple,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '1. Each number in the pyramid must equal the sum of the two numbers directly below it.',
              ),
              const SizedBox(height: 8),
              const Text(
                '2. Some numbers are already filled in for you. Fill in the rest!',
              ),
              const SizedBox(height: 8),
              const Text(
                '3. Tap a cell to select it, then tap a number to place it there.',
              ),
              const SizedBox(height: 8),
              const Text(
                '4. You can also tap a number first, then tap a cell to place it.',
              ),
              const SizedBox(height: 8),
              const Text(
                '5. Long press on a cell you\'ve filled to clear it.',
              ),
              const SizedBox(height: 16),
              Text(
                'Difficulty Levels:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.purpleAccent : Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Easy: 4-row pyramid with 50% of cells pre-filled',
              ),
              const SizedBox(height: 4),
              const Text(
                '• Medium: 5-row pyramid with 35% of cells pre-filled',
              ),
              const SizedBox(height: 4),
              const Text(
                '• Hard: 6-row pyramid with 25% of cells pre-filled',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
