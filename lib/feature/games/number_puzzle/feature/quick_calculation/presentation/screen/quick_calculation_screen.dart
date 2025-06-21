import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/core/presentation/theme/app_theme.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/presentation/provider/quick_calculation_providers.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/presentation/widgets/quick_calculation_keypad.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/presentation/widgets/quick_calculation_result_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fun_math/feature/home/provider/difficulty_selector_provider.dart';

// Helper function to convert DifficultyType to Difficulty
Difficulty getDifficultyFromType(DifficultyType type) {
  switch (type) {
    case DifficultyType.easy:
      return Difficulty.easy;
    case DifficultyType.medium:
      return Difficulty.medium;
    case DifficultyType.hard:
      return Difficulty.hard;
  }
}

class QuickCalculationScreen extends ConsumerStatefulWidget {
  const QuickCalculationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuickCalculationScreen> createState() => _QuickCalculationScreenState();
}

class _QuickCalculationScreenState extends ConsumerState<QuickCalculationScreen> {
  int _bestScore = 0;
  
  @override
  void initState() {
    super.initState();
    _loadBestScore();
  }
  
  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    final difficulty = ref.read(quickCalculationDifficultyProvider);
    final key = 'quick_calculation_best_score_${difficulty.name}';
    setState(() {
      _bestScore = prefs.getInt(key) ?? 0;
    });
  }

  Future<void> _saveBestScore(int score) async {
    final difficulty = ref.read(quickCalculationDifficultyProvider);
    final key = 'quick_calculation_best_score_${difficulty.name}';
    if (score > _bestScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, score);
      setState(() {
        _bestScore = score;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickCalculationControllerProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    
    // Show result dialog when game is completed
    if (state.isGameOver && !state.isPaused) {
      // Use post-frame callback to avoid build errors
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Save best score
        _saveBestScore(state.score);
        
        // Show result dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => QuickCalculationResultDialog(
            score: state.score,
            questionsAnswered: state.totalQuestionsAnswered,
            bestScore: _bestScore,
            difficulty: getDifficultyFromType(ref.read(quickCalculationDifficultyProvider)),
            onPlayAgain: () {
              Navigator.of(context).pop();
              ref.read(quickCalculationControllerProvider.notifier).resetGame();
            },
            onClose: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        );
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quick Calculation',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color:Colors.white
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(quickCalculationControllerProvider.notifier).resetGame(),
          ),
          IconButton(
            icon: state.isPaused 
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
            onPressed: () {
              state.isPaused
                  ? ref.read(quickCalculationControllerProvider.notifier).resumeGame()
                  : ref.read(quickCalculationControllerProvider.notifier).pauseGame();
            },
          ),
        ],
      ),
      body: Column(
        children: [
        // Timer and score with animated containers
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Animated timer card
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: _buildEnhancedInfoCard(
                        context,
                        'Time Left',
                        state.timeLeft.toString(),
                        Icons.timer,
                        isDarkMode,
                        state.timeLeft < 10 ? Colors.red : Colors.blue,
                        state.timeLeft < 10,
                      ),
                    );
                  },
                ),
                
                // Animated score card
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: _buildEnhancedInfoCard(
                        context,
                        'Score',
                        state.score.toString(),
                        Icons.stars,
                        isDarkMode,
                        Colors.amber,
                        false,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Question count with animated counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800]!.withOpacity(0.7) : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Questions Solved: ',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: state.totalQuestionsAnswered),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Text(
                        '$value',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
            // Question with animation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.95, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode 
                      ? [Colors.grey[850]!, Colors.grey[800]!]
                      : [Colors.white, Colors.grey[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: isDarkMode 
                      ? Colors.grey[700]! 
                      : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    // Question label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Solve this equation:',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Animated question
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuad, 
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 20),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        state.currentQuestion.question,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),                    // Answer display with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: state.isWrong
                            ? Colors.red.withOpacity(0.15)
                            : state.isCorrect
                                ? Colors.green.withOpacity(0.15)
                                : isDarkMode
                                    ? Colors.grey[700]
                                    : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: state.isWrong
                              ? Colors.red.withOpacity(0.5)
                              : state.isCorrect
                                  ? Colors.green.withOpacity(0.5)
                                  : isDarkMode
                                      ? Colors.grey[600]!
                                      : Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (state.isWrong
                                ? Colors.red
                                : state.isCorrect
                                    ? Colors.green
                                    : Colors.grey).withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.isCorrect) 
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          if (state.isWrong)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          Text(
                            state.currentInput.isEmpty ? '?' : state.currentInput,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: state.isWrong
                                  ? Colors.red
                                  : state.isCorrect
                                      ? Colors.green
                                      : isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Keypad with enhanced look
          Expanded(
            child: QuickCalculationKeypad(),
          ),
        ],
      ),
    );
  }
  Widget _buildEnhancedInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    bool isDarkMode,
    Color iconColor,
    bool isPulsing,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.3),
            blurRadius: isPulsing ? 12 : 5,
            spreadRadius: isPulsing ? 2 : 0,
          ),
        ],
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: isPulsing ? 0.9 : 1.0, end: isPulsing ? 1.1 : 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Game over handling is now done by the QuickCalculationResultDialog
}
