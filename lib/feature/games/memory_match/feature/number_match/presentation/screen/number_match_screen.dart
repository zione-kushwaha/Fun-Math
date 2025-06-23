import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_card_widget.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_match_result_dialog.dart';
import 'package:fun_math/feature/games/memory_match/feature/number_match/presentation/provider/number_match_providers.dart';
import 'package:fun_math/feature/games/memory_match/feature/number_match/presentation/state/number_match_state.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberMatchScreen extends ConsumerStatefulWidget {
  final DifficultyType difficulty;
  final Color primaryColor;
  final Color secondaryColor;
  
  const NumberMatchScreen({
    Key? key, 
    required this.difficulty,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  ConsumerState<NumberMatchScreen> createState() => _NumberMatchScreenState();
}

class _NumberMatchScreenState extends ConsumerState<NumberMatchScreen> with TickerProviderStateMixin {
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
      final notifier = ref.read(numberMatchControllerProvider(widget.difficulty).notifier);
      notifier.initializeGame();
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
    final state = ref.watch(numberMatchControllerProvider(widget.difficulty));
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Show result dialog when game is completed
    if (state.status == NumberMatchStatus.completed && state.result != null) {
      // Use post-frame callback to show dialog after build is complete
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MemoryMatchResultDialog(
            result: state.result!,
            difficulty: widget.difficulty,
            onPlayAgain: () {
              Navigator.of(context).pop();
              ref.read(numberMatchControllerProvider(widget.difficulty).notifier).resetGame();
              ref.read(numberMatchControllerProvider(widget.difficulty).notifier).startGame();
            },
            onClose: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            primaryColor: widget.primaryColor,
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Number Match',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Help button
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => ref.read(numberMatchControllerProvider(widget.difficulty).notifier).toggleHelp(),
          ),
          // Sound toggle
          IconButton(
            icon: Icon(state.soundEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: () => ref.read(numberMatchControllerProvider(widget.difficulty).notifier).toggleSound(),
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
                        ref.read(numberMatchControllerProvider(widget.difficulty).notifier).resumeGame();
                      } else {
                        ref.read(numberMatchControllerProvider(widget.difficulty).notifier).pauseGame();
                      }
                    },
                    icon: Icon(state.isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(state.isPaused ? 'Resume' : 'Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
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
                      ref.read(numberMatchControllerProvider(widget.difficulty).notifier).resetGame();
                      ref.read(numberMatchControllerProvider(widget.difficulty).notifier).startGame();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restart'),
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

  Widget _buildCardsGrid(BuildContext context, NumberMatchState state) {
    final gridColumns = state.difficulty == DifficultyType.easy 
        ? 4 
        : (state.difficulty == DifficultyType.medium ? 5 : 6);
    
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridColumns,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: state.cards.length,
        itemBuilder: (context, index) {
          final card = state.cards[index];
          
          return MemoryCardWidget<int>(
            card: card,
            frontColor: widget.primaryColor,
            backColor: widget.secondaryColor,
            onTap: () => ref.read(numberMatchControllerProvider(widget.difficulty).notifier)
                .handleCardTap(index),
            contentBuilder: (context, value) => Text(
              value.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: card.value > 99 ? 20 : 24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPausedOverlay(BuildContext context, bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.black54 : Colors.white70,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pause_circle_filled,
              size: 80,
              color: widget.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Game Paused',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(numberMatchControllerProvider(widget.difficulty).notifier).resumeGame(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Resume Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpText(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help,
                color: widget.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'How to Play',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Tap on cards to reveal the numbers',
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            '2. Find matching pairs of numbers',
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            '3. Complete all matches in the fewest moves',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
