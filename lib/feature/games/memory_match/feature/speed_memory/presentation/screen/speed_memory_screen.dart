import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_match_result_dialog.dart';
import 'package:fun_math/feature/games/memory_match/feature/speed_memory/presentation/provider/speed_memory_providers.dart';
import 'package:fun_math/feature/games/memory_match/feature/speed_memory/presentation/state/speed_memory_state.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedMemoryScreen extends ConsumerStatefulWidget {
  final DifficultyType difficulty;
  final Color primaryColor;
  final Color secondaryColor;
  
  const SpeedMemoryScreen({
    Key? key, 
    required this.difficulty,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  ConsumerState<SpeedMemoryScreen> createState() => _SpeedMemoryScreenState();
}

class _SpeedMemoryScreenState extends ConsumerState<SpeedMemoryScreen> with TickerProviderStateMixin {
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
      final notifier = ref.read(speedMemoryControllerProvider(widget.difficulty).notifier);
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
    final state = ref.watch(speedMemoryControllerProvider(widget.difficulty));
    
    // Show result dialog when game is completed
    if (state.status == SpeedMemoryStatus.completed && state.result != null) {
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
              ref.read(speedMemoryControllerProvider(widget.difficulty).notifier).resetGame();
              ref.read(speedMemoryControllerProvider(widget.difficulty).notifier).startGame();
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
          'Speed Memory',
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
          // Level indicator
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
                  'Level: ${state.level}',
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
                    const Icon(Icons.memory, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Completed: ${state.matchesFound}/${state.totalPairs}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Countdown overlay
          if (state.status == SpeedMemoryStatus.ready)
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
            
          // Game content
          if (state.status != SpeedMemoryStatus.ready)
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Sequence display area
                      Container(
                        height: 120,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: state.isShowingSequence
                              ? _buildSequenceDisplay(state)
                              : (state.isInputPhase
                                  ? _buildPlayerSequenceDisplay(state)
                                  : const Text(
                                      'Get Ready!',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                        ),
                      ),
                      
                      // Status message
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          state.isShowingSequence
                              ? 'Memorize the sequence!'
                              : (state.isInputPhase
                                  ? 'Repeat the sequence'
                                  : 'Prepare for the next sequence'),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.primaryColor,
                          ),
                        ),
                      ),
                      
                      // Input grid (only shown during input phase)
                      if (state.isInputPhase)
                        Expanded(
                          child: _buildInputGrid(state),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // Game controls
          if (state.status != SpeedMemoryStatus.ready)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restart'),
                    onPressed: () {
                      ref.read(speedMemoryControllerProvider(widget.difficulty).notifier).resetGame();
                      ref.read(speedMemoryControllerProvider(widget.difficulty).notifier).startGame();
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
  
  Widget _buildSequenceDisplay(SpeedMemoryState state) {
    if (state.currentIndexShowing >= 0 && state.currentIndexShowing < state.sequence.length) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: widget.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            state.sequence[state.currentIndexShowing],
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
  
  Widget _buildPlayerSequenceDisplay(SpeedMemoryState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(state.sequence.length, (index) {
          bool entered = index < state.playerSequence.length;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: entered ? widget.primaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: entered
                ? Center(
                    child: Text(
                      state.playerSequence[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          );
        }),
      ],
    );
  }
  
  Widget _buildInputGrid(SpeedMemoryState state) {
    // Calculate grid layout based on number of cards
    final int crossAxisCount = widget.difficulty == DifficultyType.easy ? 3 : 4;
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: state.cards.length,
      itemBuilder: (context, index) {
        final card = state.cards[index];
        return GestureDetector(
          onTap: () {
            if (state.isInputPhase) {
              ref.read(speedMemoryControllerProvider(widget.difficulty).notifier).handleCardTap(index);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: card.isSelected ? widget.primaryColor.withOpacity(0.7) : widget.secondaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                card.value,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
