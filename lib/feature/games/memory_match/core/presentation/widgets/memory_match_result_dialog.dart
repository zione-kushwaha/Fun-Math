import 'package:flutter/material.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryMatchResultDialog extends StatelessWidget {
  final MemoryMatchResult result;
  final DifficultyType difficulty;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;
  final Color primaryColor;

  const MemoryMatchResultDialog({
    Key? key,
    required this.result,
    required this.difficulty,
    required this.onPlayAgain,
    required this.onClose,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dialogColor = isDarkMode ? Colors.grey[850] : Colors.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: dialogColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  const SizedBox(height: 40),
                  Text(
                    'Game Completed!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getResultMessage(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  _buildStatItem(
                    context,
                    'Score',
                    result.score.toString(),
                    Icons.military_tech,
                    Colors.amber,
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildStatItem(
                    context,
                    'Time',
                    _formatTime(result.timeInSeconds),
                    Icons.timer,
                    Colors.blue,
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildStatItem(
                    context,
                    'Moves',
                    result.totalMoves.toString(),
                    Icons.touch_app,
                    Colors.orange,
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildStatItem(
                    context,
                    'Accuracy',
                    '${result.accuracyPercentage.toStringAsFixed(1)}%',
                    Icons.check_circle,
                    Colors.green,
                    isDarkMode,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Play Again'),
                        onPressed: onPlayAgain,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        onPressed: onClose,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Trophy Icon at the top
            Positioned(
              top: -30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dialogColor!,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _getResultMessage() {
    // Base message based on accuracy
    if (result.accuracyPercentage > 90) {
      return 'Outstanding! Your memory skills are impressive.';
    } else if (result.accuracyPercentage > 75) {
      return 'Great job! You have a good memory.';
    } else if (result.accuracyPercentage > 50) {
      return 'Good effort! Keep practicing to improve.';
    } else {
      return 'Nice try! Practice makes perfect.';
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
