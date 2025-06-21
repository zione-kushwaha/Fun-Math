import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:fun_math/feature/home/provider/difficulty_selector_provider.dart';

class QuickCalculationResultDialog extends StatefulWidget {
  final int score;
  final int questionsAnswered;
  final int bestScore;
  final Difficulty difficulty;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;

  const QuickCalculationResultDialog({
    Key? key,
    required this.score,
    required this.questionsAnswered,
    required this.bestScore,
    required this.difficulty,
    required this.onPlayAgain,
    required this.onClose,
  }) : super(key: key);

  @override
  State<QuickCalculationResultDialog> createState() => _QuickCalculationResultDialogState();
}

class _QuickCalculationResultDialogState extends State<QuickCalculationResultDialog> {
  late ConfettiController _confettiController;
  late bool isNewBestScore;

  @override
  void initState() {
    super.initState();
    isNewBestScore = widget.score > widget.bestScore;
    
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (isNewBestScore) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }  String _getDifficultyLabel() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  Color _getDifficultyColor() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  String _getScoreMessage() {
    if (widget.score == 0) {
      return "Keep practicing!";
    } else if (widget.score < 50) {
      return "Good effort!";
    } else if (widget.score < 100) {
      return "Well done!";
    } else if (widget.score < 200) {
      return "Great job!";
    } else {
      return "Amazing!";
    }
  }

  String _getTimePerQuestion() {
    if (widget.questionsAnswered == 0) return "0";
    // Assuming the game duration is 30 seconds
    const gameDuration = 30;
    final avgTime = gameDuration / widget.questionsAnswered;
    return avgTime.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti effect for new best score
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2, // shoot straight up
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 5,
            gravity: 0.1,
            shouldLoop: false,
            colors: const [
              Colors.green, Colors.blue, Colors.pink,
              Colors.orange, Colors.purple, Colors.yellow,
            ],
          ),
          
          // Dialog content
          Container(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Result header
                Text(
                  'Quick Calculation\nCompleted!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Score display with animated effect
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getDifficultyColor().withOpacity(0.7),
                          _getDifficultyColor(),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your Score',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              color: Colors.amber,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.score}',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (isNewBestScore)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'NEW BEST SCORE!',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Game stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        'Difficulty',
                        _getDifficultyLabel(),
                        Icons.speed_rounded,
                        _getDifficultyColor(),
                        isDarkMode,
                      ),
                      const Divider(height: 16),
                      _buildStatRow(
                        'Questions Solved',
                        '${widget.questionsAnswered}',
                        Icons.help_outline_rounded,
                        Colors.blue,
                        isDarkMode,
                      ),
                      const Divider(height: 16),
                      _buildStatRow(
                        'Avg Time/Question',
                        '${_getTimePerQuestion()}s',
                        Icons.timer_outlined,
                        Colors.orange,
                        isDarkMode,
                      ),
                      const Divider(height: 16),
                      _buildStatRow(
                        'Best Score',
                        '${max(widget.bestScore, widget.score)}',
                        Icons.emoji_events_rounded,
                        Colors.amber,
                        isDarkMode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Encouraging message
                Text(
                  _getScoreMessage(),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      label: 'Close',
                      icon: Icons.close,
                      color: theme.colorScheme.secondary,
                      onPressed: widget.onClose,
                    ),
                    _ActionButton(
                      label: 'Play Again',
                      icon: Icons.refresh_rounded,
                      color: theme.primaryColor,
                      onPressed: widget.onPlayAgain,
                      isPrimary: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Trophy badge on top if it's a new best score
          if (isNewBestScore)
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color iconColor, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isPrimary ? Colors.white : color,
        backgroundColor: isPrimary ? color : Colors.transparent,
        elevation: isPrimary ? 8 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary ? BorderSide.none : BorderSide(color: color),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
