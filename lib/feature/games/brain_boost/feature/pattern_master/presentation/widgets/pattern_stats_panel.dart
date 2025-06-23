import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/provider/pattern_master_providers.dart';
import 'package:iconsax/iconsax.dart';

class PatternStatsPanel extends ConsumerWidget {
  final DifficultyType difficulty;

  const PatternStatsPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(patternMasterControllerProvider(difficulty));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Format time as mm:ss
    final minutes = (state.stats.timeInSeconds / 60).floor();
    final seconds = state.stats.timeInSeconds % 60;
    final timeFormatted = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.indigo[900]!.withOpacity(0.5) : Colors.indigo[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Iconsax.timer_1,
            label: 'Time',
            value: timeFormatted,
            isDark: isDark,
          ),
          _buildStatItem(
            context,
            icon: Iconsax.chart_success,
            label: 'Score',
            value: state.stats.score.toString(),
            isDark: isDark,
          ),
          _buildStatItem(
            context,
            icon: Iconsax.tick_circle,
            label: 'Correct',
            value: '${state.stats.correctAnswers}/${state.stats.totalQuestions}',
            isDark: isDark,
          ),
          _buildStatItem(
            context,
            icon: Iconsax.level,
            label: 'Level',
            value: _getDifficultyLabel(difficulty),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
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
          color: isDark ? Colors.indigo[200] : Colors.indigo[700],
          size: 18,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }
  
  String _getDifficultyLabel(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return 'Easy';
      case DifficultyType.medium:
        return 'Med';
      case DifficultyType.hard:
        return 'Hard';
    }
  }
}
