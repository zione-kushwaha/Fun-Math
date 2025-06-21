import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/presentation/provider/math_memory_providers.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/presentation/state/math_memory_state.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/presentation/widgets/memory_card_widget.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/math_memory/presentation/widgets/memory_result_dialog.dart';

class MathMemoryScreen extends ConsumerStatefulWidget {
  const MathMemoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MathMemoryScreen> createState() => _MathMemoryScreenState();
}

class _MathMemoryScreenState extends ConsumerState<MathMemoryScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start game after UI is built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(mathMemoryControllerProvider.notifier);
      notifier.startGame();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mathMemoryControllerProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final difficulty = ref.watch(mathMemoryDifficultyProvider);
    
    // Show result dialog when game is completed
    if (state.status == MathMemoryStatus.completed && state.result != null) {
      // Use post-frame callback to show dialog after build is complete
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MemoryResultDialog(
            result: state.result!,
            difficulty: difficulty,
            onPlayAgain: () {
              Navigator.of(context).pop();
              ref.read(mathMemoryControllerProvider.notifier).resetGame();
              ref.read(mathMemoryControllerProvider.notifier).startGame();
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
          'Math Memory',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Help button
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => ref.read(mathMemoryControllerProvider.notifier).toggleHelp(),
          ),
          // Sound toggle
          IconButton(
            icon: Icon(state.soundEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: () => ref.read(mathMemoryControllerProvider.notifier).toggleSound(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard(
                    context,
                    'Moves',
                    '${state.moveCount}',
                    Icons.touch_app,
                    Colors.orange,
                    isDarkMode,
                  ),
                  _buildInfoCard(
                    context,
                    'Time',
                    _formatTime(state.timeInSeconds),
                    Icons.timer,
                    Colors.blue,
                    isDarkMode,
                  ),
                  _buildInfoCard(
                    context,
                    'Matches',
                    '${state.matchesFound}/${state.totalPairs}',
                    Icons.grid_view,
                    Colors.green,
                    isDarkMode,
                  ),
                ],
              ),
            ),
            
            // Control buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pause/Resume Button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (state.isPaused) {
                        ref.read(mathMemoryControllerProvider.notifier).resumeGame();
                      } else {
                        ref.read(mathMemoryControllerProvider.notifier).pauseGame();
                      }
                    },
                    icon: Icon(state.isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(state.isPaused ? 'Resume' : 'Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Restart Button
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(mathMemoryControllerProvider.notifier).resetGame();
                      ref.read(mathMemoryControllerProvider.notifier).startGame();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Restart'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Help text
            if (state.showHelp) _buildHelpText(context, isDarkMode),
            
            // Memory Cards Grid
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: state.isPaused
                    ? _buildPausedOverlay(context, isDarkMode)
                    : _buildCardsGrid(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCardsGrid(BuildContext context, MathMemoryState state) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    
    // Calculate grid dimensions
    final gridDimensions = ref.read(mathMemoryRepositoryProvider)
        .getGridDimensions(ref.read(mathMemoryDifficultyProvider));
    final rows = gridDimensions[0];
    final cols = gridDimensions[1];
    
    // Calculate grid size
    final gridWidth = size.width * 0.9;
    final cardWidth = gridWidth / cols;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: 1,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.cards.length,
          itemBuilder: (context, index) {
            final card = state.cards[index];
            return MemoryCardWidget(
              value: card.value,
              isFlipped: card.isFlipped,
              isMatched: card.isMatched,
              isQuestion: card.isQuestion,
              animated: state.animationEnabled,
              onTap: () {
                if (state.isPlaying && !state.isChecking) {
                  ref.read(mathMemoryControllerProvider.notifier).selectCard(index);
                }
              },
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPausedOverlay(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850]!.withOpacity(0.9) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pause_circle_filled,
            size: 80,
            color: theme.primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Game Paused',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => ref.read(mathMemoryControllerProvider.notifier).resumeGame(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Resume Game'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? color.withOpacity(0.2) 
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildHelpText(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode 
              ? Colors.blue.withOpacity(0.1) 
              : Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue.withOpacity(0.3),
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
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Find pairs of matching math problems and answers\n'
              '• Tap cards to flip them over\n'
              '• Remember the locations to match them quickly\n'
              '• Find all pairs to complete the game',
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
}
