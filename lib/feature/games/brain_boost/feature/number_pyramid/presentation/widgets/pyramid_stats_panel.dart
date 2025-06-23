import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/provider/number_pyramid_providers.dart';

class PyramidStatsPanel extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const PyramidStatsPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(numberPyramidControllerProvider(difficulty));
    final highScore = ref.watch(numberPyramidHighScoreProvider(difficulty));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Format time as mm:ss
    final minutes = (state.stats.timeInSeconds / 60).floor();
    final seconds = state.stats.timeInSeconds % 60;
    final timeFormatted = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          _buildStatItem(
            icon: Icons.timer,
            label: 'Time',
            value: timeFormatted,
            isDark: isDark,
          ),
          _buildStatItem(
            icon: Icons.swap_vert,
            label: 'Moves',
            value: state.stats.moves.toString(),
            isDark: isDark,
          ),
          _buildStatItem(
            icon: Icons.lightbulb,
            label: 'Hints',
            value: state.stats.hintsUsed.toString(),
            isDark: isDark,
          ),
          _buildStatItem(
            icon: Icons.emoji_events_outlined,
            label: 'Best',
            value: highScore.toString(),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isDark ? Colors.purple[200] : Colors.purple[700],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
