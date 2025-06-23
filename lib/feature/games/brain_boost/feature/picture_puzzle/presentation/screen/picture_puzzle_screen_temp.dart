import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/provider/picture_puzzle_providers.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/state/picture_puzzle_state.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/widgets/game_completion_dialog.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/widgets/game_control_panel.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/widgets/image_selector.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/widgets/puzzle_grid.dart';
import 'package:iconsax/iconsax.dart';

class PicturePuzzleScreen extends ConsumerStatefulWidget {
  const PicturePuzzleScreen({super.key});

  @override
  ConsumerState<PicturePuzzleScreen> createState() => _PicturePuzzleScreenState();
}

class _PicturePuzzleScreenState extends ConsumerState<PicturePuzzleScreen> with TickerProviderStateMixin {
  late final AnimationController _titleAnimationController;
  
  // Available images for puzzles
  final List<String> _availableImages = [
    'assets/images/app_icon.png',
    'assets/images/img.png',
    'assets/images/img_1.png',
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Initialize title animation
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    
    // Initialize the game on first load with a small delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final level = ref.read(picturePuzzleLevelProvider);
      final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
      
      // Initialize puzzle with no image (default to numbers)
      controller.initializePuzzle(null);
    });
  }
  
  @override
  void dispose() {
    _titleAnimationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Get the current level
    final currentLevel = ref.watch(picturePuzzleLevelProvider);
    
    // Watch the puzzle state
    final puzzleState = ref.watch(picturePuzzleControllerProvider(currentLevel));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Puzzle'),
        backgroundColor: isDark ? Colors.grey[800] : Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.info_circle),
            onPressed: () {
              // Show help dialog
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.blue[100]!, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Game title with animation
                _buildAnimatedTitle(),
                
                const SizedBox(height: 16),
                
                // Game controls and stats
                GameControlPanel(
                  stats: puzzleState.stats,
                  currentLevel: currentLevel,
                  status: puzzleState.status,
                  onStartGame: () {
                    _startGame();
                  },
                  onPauseGame: () {
                    _pauseGame();
                  },
                  onResumeGame: () {
                    _resumeGame();
                  },
                  onRestartGame: () {
                    _resetGame();
                  },
                  onShowHelp: () {
                    _showHelpDialog(context);
                  },
                  onLevelChanged: (level) {
                    _changeLevel(level);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Puzzle grid
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: puzzleState.tiles.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : PuzzleGrid(
                              tiles: puzzleState.tiles,
                              gridSize: puzzleState.gridSize,
                              imagePath: puzzleState.imagePath,
                              emptyTileIndex: puzzleState.emptyTileIndex,
                              lastMovedTileIndex: puzzleState.lastMovedTileIndex,
                              onTileTapped: (index) {
                                _onTileTapped(index);
                              },
                            ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Image selector
                if (puzzleState.status != PicturePuzzleStatus.playing)
                  ImageSelector(
                    imagePaths: _availableImages,
                    selectedImagePath: puzzleState.imagePath,
                    onImageSelected: (path) {
                      _selectImage(path.isEmpty ? null : path);
                    },
                  ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _titleAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _titleAnimationController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _titleAnimationController.value)),
            child: child,
          ),
        );
      },
      child: Text(
        'Picture Puzzle',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white 
              : Colors.blue[800],
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
  
  // Game control methods
  void _startGame() {
    final level = ref.read(picturePuzzleLevelProvider);
    final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
    controller.startGame();
  }
  
  void _pauseGame() {
    final level = ref.read(picturePuzzleLevelProvider);
    final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
    controller.pauseGame();
  }
  
  void _resumeGame() {
    final level = ref.read(picturePuzzleLevelProvider);
    final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
    controller.resumeGame();
  }
  
  void _resetGame() {
    final level = ref.read(picturePuzzleLevelProvider);
    final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
    controller.resetGame();
  }
  
  void _changeLevel(PuzzleLevel level) {
    // Update the current level
    ref.read(picturePuzzleLevelProvider.notifier).state = level;
    
    // Get the controller for the new level
    final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
    
    // Get the current image path
    final currentImagePath = ref.read(picturePuzzleControllerProvider(level)).imagePath;
    
    // Initialize puzzle with the selected image (if any)
    controller.setLevel(level);
    controller.initializePuzzle(currentImagePath);
  }
  
  void _selectImage(String? imagePath) {
    final level = ref.read(picturePuzzleLevelProvider);
    final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
    controller.selectImage(imagePath ?? '');
  }
  
  void _onTileTapped(int index) {
    final level = ref.read(picturePuzzleLevelProvider);
    final controller = ref.read(picturePuzzleControllerProvider(level).notifier);
    controller.tapTile(index);
    
    // Check if the game is completed after this move
    final state = ref.read(picturePuzzleControllerProvider(level));
    if (state.isCompleted) {
      // Show completion dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog(context);
      });
    }
  }
  
  void _showCompletionDialog(BuildContext context) {
    final level = ref.read(picturePuzzleLevelProvider);
    final puzzleState = ref.read(picturePuzzleControllerProvider(level));
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GameCompletionDialog(
          stats: puzzleState.stats,
          onPlayAgain: () {
            Navigator.of(context).pop();
            _resetGame();
            _startGame();
          },
          onBackToMenu: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop(); // Go back to the brain boost menu
          },
        );
      },
    );
  }
  
  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'How to Play',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(context, 'Tap on tiles adjacent to the empty space to move them.'),
              _buildHelpItem(context, 'Rearrange all tiles to recreate the original image.'),
              _buildHelpItem(context, 'Complete the puzzle in the fewest moves and time for a high score.'),
              _buildHelpItem(context, 'Choose different difficulty levels for more challenge.'),
              _buildHelpItem(context, 'Select from different images or use numbered tiles.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
