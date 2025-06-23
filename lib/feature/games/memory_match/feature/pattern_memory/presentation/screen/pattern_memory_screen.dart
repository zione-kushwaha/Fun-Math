import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_match_result_dialog.dart';
import '../provider/pattern_memory_providers.dart';

class PatternMemoryScreen extends ConsumerStatefulWidget {
  final DifficultyType difficulty;
  final Color primaryColor;
  final Color secondaryColor;

  const PatternMemoryScreen({
    super.key,
    required this.difficulty,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  ConsumerState<PatternMemoryScreen> createState() => _PatternMemoryScreenState();
}

class _PatternMemoryScreenState extends ConsumerState<PatternMemoryScreen> {
  @override
  void initState() {
    super.initState();
    
    // Initialize game after the UI is built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(patternMemoryControllerProvider.notifier);
      controller.initializeGame();
    });
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patternMemoryControllerProvider);
    final controller = ref.read(patternMemoryControllerProvider.notifier);
    final primaryColor = widget.primaryColor;
    final secondaryColor = widget.secondaryColor;
    final difficulty = widget.difficulty;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pattern Memory'),
        backgroundColor: widget.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.isPlaying || state.isPaused 
                ? () => controller.resetGame()
                : null,
          ),
          IconButton(
            icon: Icon(state.soundEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: () => controller.toggleSound(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.3),
              primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(state, context),
              Expanded(
                child: _buildGameContent(state, controller, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level: ${state.level}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Matched: ${state.matchesFound}/${state.totalPairs}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Time: ${state.timeInSeconds}s',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Moves: ${state.moveCount}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
    Widget _buildGameContent(state, controller, BuildContext context) {
    if (state.isInitial) {
      return _buildStartScreen(controller, context);
    } else if (state.isReady) {
      return _buildCountdownScreen(state);
    } else if (state.isPlaying || state.isPaused) {
      return _buildPlayingScreen(state, controller, context);
    } else if (state.isCompleted) {
      // Show result dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MemoryMatchResultDialog(
            result: state.result!,
            primaryColor: widget.primaryColor,
            difficulty: widget.difficulty,         
            
               onPlayAgain: () {
              Navigator.pop(context);
              controller.resetGame();
              controller.initializeGame();
            },
            onClose: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      });
      
      return _buildPlayingScreen(state, controller, context);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
  
  Widget _buildStartScreen(controller, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [          Text(
            'Pattern Memory',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: widget.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Remember the pattern and identify the similar one.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          Text(
            'Difficulty: ${widget.difficulty.name.toUpperCase()}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => controller.startGame(),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Start Game',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCountdownScreen(state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Get Ready!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            '${state.countdown}',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlayingScreen(state, controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInstructionText(state),
          const SizedBox(height: 24),
          _buildPatternDisplay(state),
          const SizedBox(height: 24),
          if (state.showOptions) _buildPatternOptions(state, controller),
        ],
      ),
    );
  }
  
  Widget _buildInstructionText(state) {
    if (state.showOriginalPattern) {
      return const Text(
        'Remember this pattern',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (state.showOptions) {
      return const Text(
        'Select the pattern that matches',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
  
  Widget _buildPatternDisplay(state) {
    if (!state.showOriginalPattern && !state.showOptions) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (state.showOriginalPattern) {
      final gridSize = _getGridSize(state.originalPattern.length);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemCount: state.originalPattern.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final isActive = state.originalPattern[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive ? widget.primaryColor : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
  
  Widget _buildPatternOptions(state, controller) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.patternOptions.length,
        itemBuilder: (context, index) {
          final pattern = state.patternOptions[index];
          final gridSize = _getGridSize(pattern.length);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () => controller.handleOptionSelection(index),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: state.selectedOptionIndex == index
                      ? Border.all(color: widget.secondaryColor, width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                    ),
                    itemCount: pattern.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, patternIndex) {
                      final isActive = pattern[patternIndex];
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isActive ? widget.primaryColor : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  int _getGridSize(int length) {
    if (length == 9) return 3;
    if (length == 16) return 4;
    return 5; // 25
  }
}
