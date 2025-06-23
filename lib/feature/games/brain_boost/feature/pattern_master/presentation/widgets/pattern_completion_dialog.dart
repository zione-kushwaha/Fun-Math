import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/provider/pattern_master_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';

class PatternCompletionDialog extends ConsumerStatefulWidget {
  final DifficultyType difficulty;
  
  const PatternCompletionDialog({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  ConsumerState<PatternCompletionDialog> createState() => _PatternCompletionDialogState();
}

class _PatternCompletionDialogState extends ConsumerState<PatternCompletionDialog> {
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    
    // Play confetti animation when dialog shows
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patternMasterControllerProvider(widget.difficulty));
    final controller = ref.read(patternMasterControllerProvider(widget.difficulty).notifier);
    final highScore = ref.watch(patternMasterHighScoreProvider(widget.difficulty));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final isNewHighScore = state.stats.score > highScore;
    
    // Format time as mm:ss
    final minutes = (state.stats.timeInSeconds / 60).floor();
    final seconds = state.stats.timeInSeconds % 60;
    final timeFormatted = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    
    // Calculate accuracy as percentage
    final accuracy = state.stats.totalQuestions > 0 
      ? (state.stats.correctAnswers / state.stats.totalQuestions * 100).toStringAsFixed(1) 
      : '0.0';
    
    return Stack(
      children: [
        Dialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Celebration icon
                Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: isDark ? Colors.amber : Colors.amber[600],
                ),
                
                const SizedBox(height: 16),
                
                // Congratulation title
                Text(
                  'Pattern Master Complete!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                
                if (isNewHighScore) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.amber[900] : Colors.amber[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: isDark ? Colors.amber : Colors.amber[800],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'New High Score!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.amber[100] : Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        label: 'Score',
                        value: state.stats.score.toString(),
                        icon: Icons.star_border,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        label: 'Time',
                        value: timeFormatted,
                        icon: Icons.timer,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        label: 'Accuracy',
                        value: '$accuracy%',
                        icon: Icons.check_circle_outline,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        label: 'Patterns Solved',
                        value: '${state.stats.correctAnswers}/${state.stats.totalQuestions}',
                        icon: Icons.grid_view,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        label: 'Difficulty',
                        value: _getDifficultyLabel(widget.difficulty),
                        icon: Icons.trending_up,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                          foregroundColor: isDark ? Colors.white : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          controller.resetGame();
                          Navigator.pop(context);
                        },
                        child: const Text('Play Again'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.indigo[700] : Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          context.go('/brain_boost');
                        },
                        child: const Text('More Games'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Confetti overlay
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width / 2,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -3.14 / 2, // straight up
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 10,
            gravity: 0.1,
            particleDrag: 0.05,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatRow({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.indigo[200] : Colors.indigo,
        ),
        const SizedBox(width: 8),
        Text(
          label + ':',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const Spacer(),
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
  
  String _getDifficultyLabel(DifficultyType difficulty) {
    switch (difficulty) {
      case DifficultyType.easy:
        return 'Easy';
      case DifficultyType.medium:
        return 'Medium';
      case DifficultyType.hard:
        return 'Hard';
    }
  }
}
