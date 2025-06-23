import 'package:flutter/material.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/state/picture_puzzle_state.dart';
import 'package:iconsax/iconsax.dart';

class GameControlPanel extends StatelessWidget {
  final PuzzleStats stats;
  final PuzzleLevel currentLevel;
  final PicturePuzzleStatus status;
  final VoidCallback onStartGame;
  final VoidCallback onPauseGame;
  final VoidCallback onResumeGame;
  final VoidCallback onRestartGame;
  final VoidCallback onShowHelp;
  final Function(PuzzleLevel) onLevelChanged;
  
  const GameControlPanel({
    super.key,
    required this.stats,
    required this.currentLevel,
    required this.status,
    required this.onStartGame,
    required this.onPauseGame,
    required this.onResumeGame,
    required this.onRestartGame,
    required this.onShowHelp,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Game stats display
        _buildStatsRow(context),
        
        const SizedBox(height: 20),
        
        // Game action buttons
        _buildActionButtons(context),
        
        const SizedBox(height: 16),
        
        // Difficulty level selection
        _buildDifficultySelector(context),
      ],
    );
  }
  
  Widget _buildStatsRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Moves counter
        _buildStatCard(
          context: context,
          label: 'Moves',
          value: stats.moves.toString(),
          icon: Iconsax.arrow_swap_horizontal,
          color: isDark ? Colors.purple : Colors.purple[300]!,
        ),
        
        // Time counter
        _buildStatCard(
          context: context,
          label: 'Time',
          value: _formatTime(stats.timeInSeconds),
          icon: Iconsax.timer_1,
          color: isDark ? Colors.orange : Colors.orange[300]!,
        ),
        
        // Score display
        _buildStatCard(
          context: context,
          label: 'Score',
          value: stats.score.toString(),
          icon: Iconsax.award,
          color: isDark ? Colors.amber : Colors.amber[300]!,
        ),
      ],
    );
  }
  
  Widget _buildStatCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (status == PicturePuzzleStatus.initial) 
          _buildActionButton(
            context: context,
            label: 'Start',
            icon: Iconsax.play,
            color: Colors.green,
            onPressed: onStartGame,
          )
        else if (status == PicturePuzzleStatus.playing)
          _buildActionButton(
            context: context,
            label: 'Pause',
            icon: Iconsax.pause,
            color: isDark ? Colors.amber[700]! : Colors.amber,
            onPressed: onPauseGame,
          )
        else if (status == PicturePuzzleStatus.paused)
          _buildActionButton(
            context: context,
            label: 'Resume',
            icon: Iconsax.play,
            color: Colors.green,
            onPressed: onResumeGame,
          ),
        
        const SizedBox(width: 16),
        
        _buildActionButton(
          context: context,
          label: 'Restart',
          icon: Iconsax.refresh,
          color: isDark ? Colors.blue[700]! : Colors.blue,
          onPressed: onRestartGame,
        ),
        
        const SizedBox(width: 16),
        
        _buildActionButton(
          context: context,
          label: 'Help',
          icon: Iconsax.info_circle,
          color: isDark ? Colors.purple[700]! : Colors.purple,
          onPressed: onShowHelp,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isDark ? 4 : 2,
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
  
  Widget _buildDifficultySelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDifficultyButton(context, PuzzleLevel.easy),
        const SizedBox(width: 12),
        _buildDifficultyButton(context, PuzzleLevel.medium),
        const SizedBox(width: 12),
        _buildDifficultyButton(context, PuzzleLevel.hard),
      ],
    );
  }
  
  Widget _buildDifficultyButton(BuildContext context, PuzzleLevel level) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = currentLevel == level;
    
    String levelText;
    Color baseColor;
    
    switch (level) {
      case PuzzleLevel.easy:
        levelText = '3×3';
        baseColor = Colors.green;
        break;
      case PuzzleLevel.medium:
        levelText = '4×4';
        baseColor = Colors.orange;
        break;
      case PuzzleLevel.hard:
        levelText = '5×5';
        baseColor = Colors.red;
        break;
    }
    
    // Disable level change when game is in progress
    final isDisabled = status == PicturePuzzleStatus.playing || status == PicturePuzzleStatus.paused;
    
    return ElevatedButton(
      onPressed: isDisabled ? null : () => onLevelChanged(level),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
            ? baseColor
            : isDark ? Colors.grey[800] : Colors.grey[200],
        foregroundColor: isSelected 
            ? Colors.white 
            : isDark ? Colors.white70 : Colors.black87,
        disabledBackgroundColor: isSelected 
            ? baseColor.withOpacity(0.6)
            : isDark ? Colors.grey[700] : Colors.grey[300],
        disabledForegroundColor: isSelected 
            ? Colors.white70 
            : isDark ? Colors.white38 : Colors.black45,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: isSelected ? 4 : 1,
      ),
      child: Text(levelText),
    );
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
