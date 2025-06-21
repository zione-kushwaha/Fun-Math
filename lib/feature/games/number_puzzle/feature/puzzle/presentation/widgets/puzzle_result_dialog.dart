import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/domain/model/number_puzzle.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/provider/number_puzzle_providers.dart';

class PuzzleResultDialog extends ConsumerStatefulWidget {
  final PuzzleResult result;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;
  final DifficultyType difficulty;

  const PuzzleResultDialog({
    Key? key,
    required this.result,
    required this.onPlayAgain,
    required this.onClose,
    required this.difficulty,
  }) : super(key: key);

  @override
  ConsumerState<PuzzleResultDialog> createState() => _PuzzleResultDialogState();
}

class _PuzzleResultDialogState extends ConsumerState<PuzzleResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    _controller.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Confetti animation
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -3.14 / 2, // Bottom to top
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 50,
            minBlastForce: 20,
            shouldLoop: false,
            colors: const [
              Colors.blue,
              Colors.green,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        
        // Dialog content
        ScaleTransition(
          scale: _scaleAnimation,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 20,
            backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy icon
                  const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.amber,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Congratulations text
                  Text(
                    'Puzzle Solved!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  
                  Text(
                    'Congratulations!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: theme.primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                    // Results
                  _buildResultItem(
                    context, 
                    'Score',
                    '${widget.result.score}',
                    Icons.stars,
                    Colors.amber,
                    isDarkMode,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Best score (from provider)
                  _buildBestScore(context, isDarkMode),
                  
                  const SizedBox(height: 8),
                  
                  _buildResultItem(
                    context, 
                    'Moves',
                    '${widget.result.moves} moves',
                    Icons.switch_access_shortcut,
                    Colors.blue,
                    isDarkMode,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _buildResultItem(
                    context, 
                    'Time',
                    _formatTime(widget.result.timeInSeconds),
                    Icons.timer,
                    Colors.green,
                    isDarkMode,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          side: BorderSide(
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      
                      ElevatedButton.icon(
                        onPressed: widget.onPlayAgain,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Play Again'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildBestScore(BuildContext context, bool isDarkMode) {
    final bestScore = ref.watch(bestScoreProvider(widget.difficulty));
    
    return bestScore.when(
      data: (score) {
        if (score == null) {
          // No previous best score
          return _buildResultItem(
            context,
            'Best Score',
            'New Record!',
            Icons.emoji_events,
            Colors.purple,
            isDarkMode,
          );
        } else {
          // Show previous best score
          final isNewBest = widget.result.score > score;
          return _buildResultItem(
            context,
            'Best Score',
            isNewBest ? 'New! (was $score)' : '$score',
            Icons.emoji_events,
            isNewBest ? Colors.purple : Colors.grey,
            isDarkMode,
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _buildResultItem(
        context,
        'Best Score',
        'Unknown',
        Icons.emoji_events,
        Colors.grey,
        isDarkMode,
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
