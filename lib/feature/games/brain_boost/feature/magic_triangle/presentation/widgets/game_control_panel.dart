import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/provider/magic_triangle_providers.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/state/magic_triangle_state.dart';

class GameControlPanel extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const GameControlPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(magicTriangleControllerProvider(difficulty));
    final controller = ref.read(magicTriangleControllerProvider(difficulty).notifier);
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
            icon: Icons.help_outline,
            label: 'Help',
            color: Colors.purple,
            onTap: () {
              controller.toggleHelp();
              _showHelpDialog(context);
            },
          ),
          _buildControlButton(
            icon: state.soundEnabled ? Icons.volume_up : Icons.volume_off,
            label: state.soundEnabled ? 'Sound On' : 'Sound Off',
            color: state.soundEnabled ? Colors.green : Colors.grey,
            onTap: () {
              controller.toggleSound();
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
                'Magic Triangle Rules:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.purpleAccent : Colors.purple,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '1. Place numbers in the triangle so that each side adds up to the target sum.',
              ),
              const SizedBox(height: 8),
              const Text(
                '2. Select a number from the available numbers panel and then tap a position in the triangle to place it.',
              ),
              const SizedBox(height: 8),
              const Text(
                '3. Alternatively, you can first select a position in the triangle, then select a number to place.',
              ),
              const SizedBox(height: 8),
              const Text(
                '4. To remove a number, tap on it in the triangle.',
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
                '• Easy: 3 numbers per side (6 positions total)',
              ),
              const SizedBox(height: 4),
              const Text(
                '• Medium: 4 numbers per side (9 positions total)',
              ),
              const SizedBox(height: 4),
              const Text(
                '• Hard: 5 numbers per side (12 positions total)',
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
