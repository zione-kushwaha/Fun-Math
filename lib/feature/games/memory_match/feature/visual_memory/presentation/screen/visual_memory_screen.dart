import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_card_widget.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_match_result_dialog.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import 'package:fun_math/feature/games/memory_match/feature/visual_memory/presentation/provider/visual_memory_providers.dart';
import 'package:fun_math/feature/games/memory_match/feature/visual_memory/presentation/state/visual_memory_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class VisualMemoryScreen extends ConsumerStatefulWidget {
  final DifficultyType difficulty;
  final Color primaryColor;
  final Color secondaryColor;
  
  const VisualMemoryScreen({
    Key? key, 
    required this.difficulty,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  ConsumerState<VisualMemoryScreen> createState() => _VisualMemoryScreenState();
}

class _VisualMemoryScreenState extends ConsumerState<VisualMemoryScreen> with TickerProviderStateMixin {
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
      final notifier = ref.read(visualMemoryControllerProvider(widget.difficulty).notifier);
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
    final state = ref.watch(visualMemoryControllerProvider(widget.difficulty));
    
    // Show result dialog when game is completed
    if (state.status == VisualMemoryStatus.completed && state.result != null) {
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
              ref.read(visualMemoryControllerProvider(widget.difficulty).notifier).resetGame();
              ref.read(visualMemoryControllerProvider(widget.difficulty).notifier).startGame();
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
          'Visual Memory',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: widget.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/memory_match'),
        ),
        actions: [
          // Score counter
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.secondaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, size: 20),
                const SizedBox(width: 4),
                Text(
                  'Matches: ${state.matchesFound}/${state.totalPairs}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: widget.primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Time: ${state.timeInSeconds}s',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.touch_app, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Moves: ${state.moveCount}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (state.isShowingAll)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Memorize!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Countdown overlay
          if (state.status == VisualMemoryStatus.ready)
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Text(
                      '${state.countdown}',
                      key: ValueKey<int>(state.countdown),
                      style: GoogleFonts.poppins(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
          // Game grid
          if (state.status != VisualMemoryStatus.ready)
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine grid dimensions based on difficulty
                      int crossAxisCount;
                      switch (widget.difficulty) {
                        case DifficultyType.easy:
                          crossAxisCount = 3;
                          break;
                        case DifficultyType.medium:
                          crossAxisCount = 4;
                          break;
                        case DifficultyType.hard:
                          crossAxisCount = 5;
                          break;
                      }
                      
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: state.cards.length,
                        itemBuilder: (context, index) {
                          final card = state.cards[index];
                          return MemoryCardWidget<Color>(
                            card: card,
                            onTap: () {
                              if (state.isPlaying && !state.isShowingAll) {
                                ref.read(visualMemoryControllerProvider(widget.difficulty).notifier)
                                  .handleCardTap(index);
                              }
                            },
                            frontColor: card.value,
                            backColor: widget.secondaryColor,
                            contentBuilder: (context, value) {
                              // For visual memory, we only need to show the color
                              return Container();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          
          // Difficulty indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: widget.difficulty == DifficultyType.easy
                        ? Colors.green
                        : (widget.difficulty == DifficultyType.medium
                            ? Colors.orange
                            : Colors.red),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.difficulty == DifficultyType.easy
                        ? 'Easy: Remember colors'
                        : (widget.difficulty == DifficultyType.medium
                            ? 'Medium: More colors to remember'
                            : 'Hard: Many colors, short reveal time'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.difficulty == DifficultyType.easy
                          ? Colors.green
                          : (widget.difficulty == DifficultyType.medium
                              ? Colors.orange
                              : Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Game controls
          if (state.status != VisualMemoryStatus.ready)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restart'),
                    onPressed: () {
                      ref.read(visualMemoryControllerProvider(widget.difficulty).notifier).resetGame();
                      ref.read(visualMemoryControllerProvider(widget.difficulty).notifier).startGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Menu'),
                    onPressed: () {
                      context.go('/memory_match');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
