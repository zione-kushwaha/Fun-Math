import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Add this for WidgetBinding
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/provider/number_puzzle_providers.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/state/number_puzzle_state.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/widgets/puzzle_controls.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/widgets/puzzle_info_card.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/widgets/puzzle_result_dialog.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/widgets/puzzle_tile.dart';

class NumberPuzzleScreen extends ConsumerStatefulWidget {
  const NumberPuzzleScreen({super.key});

  @override
  ConsumerState<NumberPuzzleScreen> createState() => _NumberPuzzleScreenState();
}

class _NumberPuzzleScreenState extends ConsumerState<NumberPuzzleScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.05,
    );
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );    // Start game after UI is built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(numberPuzzleControllerProvider.notifier);
      notifier.startGame();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(numberPuzzleControllerProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final difficulty = ref.watch(numberPuzzleDifficultyProvider);
    
    // Show result dialog when puzzle is completed
    if (state.status == PuzzleStatus.completed && state.result != null) {
      // Use post-frame callback to show dialog after build is complete
      SchedulerBinding.instance.addPostFrameCallback((_) {        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PuzzleResultDialog(
            result: state.result!,
            difficulty: difficulty,
            onPlayAgain: () {
              Navigator.of(context).pop();
              ref.read(numberPuzzleControllerProvider.notifier).resetGame();
              ref.read(numberPuzzleControllerProvider.notifier).startGame();
            },
            onClose: () {
              Navigator.of(context).pop();
            },
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Number Puzzle',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top info cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PuzzleInfoCard(
                    title: 'Moves',
                    value: '${state.moveCount}',
                    icon: Icons.switch_access_shortcut,
                    iconColor: Colors.blue,
                  ),
                  PuzzleInfoCard(
                    title: 'Time',
                    value: _formatTime(state.timeInSeconds),
                    icon: Icons.timer,
                    iconColor: Colors.orange,
                  ),
                  PuzzleInfoCard(
                    title: 'Level',
                    value: _getDifficultyText(difficulty),
                    icon: Icons.trending_up,
                    iconColor: Colors.green,
                  ),
                ],
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PuzzleControls(
                isPaused: state.status == PuzzleStatus.paused,
                isSoundEnabled: state.soundEnabled,
                showHelp: state.showHelp,
                onPause: () => ref.read(numberPuzzleControllerProvider.notifier).pauseGame(),
                onResume: () => ref.read(numberPuzzleControllerProvider.notifier).resumeGame(),
                onRestart: () {
                  ref.read(numberPuzzleControllerProvider.notifier).resetGame();
                  ref.read(numberPuzzleControllerProvider.notifier).startGame();
                },
                onToggleHelp: () => ref.read(numberPuzzleControllerProvider.notifier).toggleHelp(),
                onToggleSound: () => ref.read(numberPuzzleControllerProvider.notifier).toggleSound(),
              ),
            ),

            const SizedBox(height: 24),

            // Puzzle grid
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: _buildPuzzleGrid(context, state),
                ),
              ),
            ),

            // Help text
            if (state.showHelp) _buildHelpText(context, isDarkMode),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleGrid(BuildContext context, NumberPuzzleState state) {
    final size = MediaQuery.of(context).size;
    final gridSize = state.puzzle.gridSize;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Calculate grid size based on screen dimensions
    final gridWidth = size.width * 0.85;
    final gridHeight = gridWidth;
    
    // Show pause overlay if paused
    if (state.status == PuzzleStatus.paused) {
      return Container(
        width: gridWidth,
        height: gridHeight,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800]!.withOpacity(0.8) : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pause_circle,
              size: 80,
              color: theme.primaryColor.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Game Paused',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(numberPuzzleControllerProvider.notifier).resumeGame(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Resume Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: gridWidth,
      height: gridHeight,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
          ),
          itemCount: state.puzzle.numbers.length,
          itemBuilder: (context, index) {
            final number = state.puzzle.numbers[index];
            final isEmpty = number == 0;
            final isCorrectPosition = number == state.puzzle.solution[index];
            final isMovable = state.puzzle.canMove(index);
            
            return GestureDetector(
              onTap: () {
                if (state.status == PuzzleStatus.playing && isMovable) {
                  _bounceController.forward().then((_) => _bounceController.reverse());
                  ref.read(numberPuzzleControllerProvider.notifier).makeMove(index);
                }
              },
              child: ScaleTransition(
                scale: isMovable ? _bounceAnimation : const AlwaysStoppedAnimation(1.0),
                child: PuzzleTile(
                  number: number,
                  isEmpty: isEmpty,
                  isMovable: isMovable && state.status == PuzzleStatus.playing,
                  isCorrectPosition: isCorrectPosition,
                  onTap: () {
                    if (state.status == PuzzleStatus.playing) {
                      _bounceController.forward().then((_) => _bounceController.reverse());
                      ref.read(numberPuzzleControllerProvider.notifier).makeMove(index);
                    }
                  },
                  animated: state.animationEnabled,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHelpText(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.blue.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to Play',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Tap tiles next to the empty space to move them\n'
              '• Arrange the numbers in order from 1 to 15\n'
              '• The empty space should be at the bottom right\n'
              '• Complete the puzzle with the fewest moves and time for a high score',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  String _getDifficultyText(DifficultyType difficulty) {
    if (difficulty == DifficultyType.easy) {
      return 'Easy';
    } else if (difficulty == DifficultyType.medium) {
      return 'Medium';
    } else {
      return 'Hard';
    }
  }
}
