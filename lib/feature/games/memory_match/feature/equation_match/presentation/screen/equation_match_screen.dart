import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_card_widget.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_match_result_dialog.dart';
import 'package:fun_math/feature/games/memory_match/domain/model/memory_match.dart';
import 'package:fun_math/feature/games/memory_match/feature/equation_match/presentation/provider/equation_match_providers.dart';
import 'package:fun_math/feature/games/memory_match/feature/equation_match/presentation/state/equation_match_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EquationMatchScreen extends ConsumerStatefulWidget {
  final DifficultyType difficulty;
  final Color primaryColor;
  final Color secondaryColor;
  
  const EquationMatchScreen({
    Key? key, 
    required this.difficulty,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  ConsumerState<EquationMatchScreen> createState() => _EquationMatchScreenState();
}

class _EquationMatchScreenState extends ConsumerState<EquationMatchScreen> with TickerProviderStateMixin {
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
      final notifier = ref.read(equationMatchControllerProvider(widget.difficulty).notifier);
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
    final state = ref.watch(equationMatchControllerProvider(widget.difficulty));    final theme = Theme.of(context);
    
    // Show result dialog when game is completed
    if (state.status == EquationMatchStatus.completed && state.result != null) {
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
              ref.read(equationMatchControllerProvider(widget.difficulty).notifier).resetGame();
              ref.read(equationMatchControllerProvider(widget.difficulty).notifier).startGame();
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
          'Equation Match',
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
                if (state.difficulty == DifficultyType.easy)
                  const Text('Easy', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                if (state.difficulty == DifficultyType.medium)
                  const Text('Medium', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                if (state.difficulty == DifficultyType.hard)
                  const Text('Hard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ),
          
          // Countdown overlay
          if (state.status == EquationMatchStatus.ready)
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
            
          // Game grid          if (state.status != EquationMatchStatus.ready)
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
                          return MemoryCardWidget<dynamic>(
                            card: card,
                            onTap: () {
                              if (state.isPlaying) {
                                ref.read(equationMatchControllerProvider(widget.difficulty).notifier)
                                  .handleCardTap(index);
                              }
                            },
                            frontColor: widget.primaryColor,
                            backColor: widget.secondaryColor,
                            contentBuilder: (context, value) {
                              if (value is String) {
                                // Equation card
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      value,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else if (value is int) {
                                // Result card
                                return Center(
                                  child: Text(
                                    value.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

          // Game controls          if (state.status != EquationMatchStatus.ready)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    onPressed: () {
                      ref.read(equationMatchControllerProvider(widget.difficulty).notifier).resetGame();
                      ref.read(equationMatchControllerProvider(widget.difficulty).notifier).startGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(state.isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(state.isPaused ? 'Resume' : 'Pause'),
                    onPressed: () {
                      if (state.isPaused) {
                        ref.read(equationMatchControllerProvider(widget.difficulty).notifier).resumeGame();
                      } else {
                        ref.read(equationMatchControllerProvider(widget.difficulty).notifier).pauseGame();
                      }
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
