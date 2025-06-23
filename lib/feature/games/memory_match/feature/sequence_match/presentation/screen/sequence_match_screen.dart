import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/memory_match/core/presentation/widgets/memory_match_result_dialog.dart';
import '../provider/sequence_match_providers.dart';

class SequenceMatchScreen extends ConsumerStatefulWidget {
  final DifficultyType difficulty;
  final Color primaryColor;
  final Color secondaryColor;

  const SequenceMatchScreen({
    super.key,
    required this.difficulty,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  ConsumerState<SequenceMatchScreen> createState() => _SequenceMatchScreenState();
}

class _SequenceMatchScreenState extends ConsumerState<SequenceMatchScreen> {
  @override
  void initState() {
    super.initState();
    
    // Initialize game after the UI is built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(sequenceMatchControllerProvider.notifier);
      controller.initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {    final state = ref.watch(sequenceMatchControllerProvider);
    final controller = ref.read(sequenceMatchControllerProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(        title: Text('Sequence Match'),
        backgroundColor: widget.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
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
        decoration: BoxDecoration(          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.primaryColor.withOpacity(0.3),
              widget.primaryColor.withOpacity(0.1),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Matched: ${state.matchesFound}/${state.totalPairs}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Time: ${state.timeInSeconds}s',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Moves: ${state.moveCount}',
                style: TextStyle(fontSize: 14),
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
    } else if (state.isCompleted) {      // Show result dialog
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
        children: [
          Text(
            'Sequence Match',            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: widget.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Remember the sequence pattern and select the next numbers.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 32),
          Text(
            'Difficulty: ${widget.difficulty.name.toUpperCase()}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => controller.startGame(),            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
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
          Text(
            'Get Ready!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Text(
            '${state.countdown}',
            style: TextStyle(              fontSize: 72,
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
          _buildSequenceDisplay(state),
          SizedBox(height: 24),
          Expanded(
            child: _buildInputArea(state, controller),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSequenceDisplay(state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Sequence:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: state.isInputPhase ? 
            Center(
              child: Text(
                state.sequence.map((num) => num.toString()).join(' → ') + ' → ?',
                style: TextStyle(                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
            ) : 
            Center(
              child: Text(
                'Watch the sequence carefully!',                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
            ),
        ),
        SizedBox(height: 16),
        if (state.isInputPhase)
          Center(
            child: Text(
              'Select the next numbers in the sequence',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildInputArea(state, controller) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.optionCards.length,
      itemBuilder: (context, index) {
        final card = state.optionCards[index];
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: state.showInputPhase ? 1.0 : 0.5,
          child: InkWell(
            onTap: state.showInputPhase ? 
              () => controller.handleCardTap(index) : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(                color: card.isSelected ? 
                  widget.secondaryColor : 
                  Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),              child: Center(
                child: Text(
                  card.value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: card.isSelected ? 
                      Colors.white : 
                      Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
