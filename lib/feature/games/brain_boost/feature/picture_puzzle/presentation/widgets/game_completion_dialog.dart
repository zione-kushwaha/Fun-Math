import 'package:flutter/material.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';
import 'package:iconsax/iconsax.dart';

class GameCompletionDialog extends StatelessWidget {
  final PuzzleStats stats;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;
  
  const GameCompletionDialog({
    super.key,
    required this.stats,
    required this.onPlayAgain,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration animation
            _buildCelebrationHeader(context),
            
            const SizedBox(height: 20),
            
            // Game stats
            _buildStatsSection(context),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  context: context,
                  label: 'Play Again',
                  icon: Iconsax.refresh,
                  color: isDark ? Colors.blue[700]! : Colors.blue,
                  onPressed: onPlayAgain,
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  context: context,
                  label: 'Menu',
                  icon: Iconsax.home,
                  color: isDark ? Colors.purple[700]! : Colors.purple,
                  onPressed: onBackToMenu,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCelebrationHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.5, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? Colors.amber[700] : Colors.amber[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.award,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Puzzle Completed!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Great job! You did it!',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatRow(
            context: context,
            label: 'Time',
            value: _formatTime(stats.timeInSeconds),
            icon: Iconsax.timer_1,
          ),
          const Divider(height: 20),
          _buildStatRow(
            context: context,
            label: 'Moves',
            value: stats.moves.toString(),
            icon: Iconsax.arrow_swap_horizontal,
          ),
          const Divider(height: 20),
          _buildStatRow(
            context: context,
            label: 'Score',
            value: stats.score.toString(),
            icon: Iconsax.chart_success,
            isHighlighted: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    bool isHighlighted = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isHighlighted
        ? (isDark ? Colors.amber : Colors.amber[800])
        : (isDark ? Colors.white : Colors.black87);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
