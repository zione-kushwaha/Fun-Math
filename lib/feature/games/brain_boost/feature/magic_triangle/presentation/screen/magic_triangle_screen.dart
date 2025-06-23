import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/provider/magic_triangle_providers.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/widgets/available_numbers_panel.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/widgets/game_completion_dialog.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/widgets/game_control_panel.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/widgets/game_stats_panel.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/widgets/magic_triangle_board.dart';
import 'package:iconsax/iconsax.dart';

class MagicTriangleScreen extends ConsumerStatefulWidget {
  const MagicTriangleScreen({super.key});

  @override
  ConsumerState<MagicTriangleScreen> createState() => _MagicTriangleScreenState();
}

class _MagicTriangleScreenState extends ConsumerState<MagicTriangleScreen> {
  DifficultyType _selectedDifficulty = DifficultyType.easy;
  bool _isGameStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the triangle when the screen loads
      ref.read(magicTriangleControllerProvider(_selectedDifficulty).notifier).initializeTriangle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (_isGameStarted) {
      // Game screen
      final state = ref.watch(magicTriangleControllerProvider(_selectedDifficulty));
      
      // Show completion dialog when game is completed
      if (state.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => GameCompletionDialog(
              difficulty: _selectedDifficulty,
            ),
          );
        });
      }
      
      return Scaffold(
        appBar: AppBar(
          title: const Text('Magic Triangle'),
          backgroundColor: isDark ? Colors.purple[800] : Colors.purple[600],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Iconsax.info_circle),
              onPressed: () {
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
                  : [Colors.purple[100]!, Colors.purple[50]!],
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
                  // Game stats
                  GameStatsPanel(difficulty: _selectedDifficulty),
                  
                  const SizedBox(height: 16),
                  
                  // Game board
                  Expanded(
                    child: Center(
                      child: MagicTriangleBoard(
                        difficulty: _selectedDifficulty,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Available numbers
                  AvailableNumbersPanel(difficulty: _selectedDifficulty),
                  
                  const SizedBox(height: 16),
                  
                  // Game controls
                  GameControlPanel(difficulty: _selectedDifficulty),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Welcome/difficulty selection screen
      return Scaffold(
        appBar: AppBar(
          title: const Text('Magic Triangle'),
          backgroundColor: isDark ? Colors.purple[800] : Colors.purple[600],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Iconsax.info_circle),
              onPressed: () {
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
                  : [Colors.purple[100]!, Colors.purple[50]!],
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
                  
                  const SizedBox(height: 24),
                  
                  // Game instructions
                  Text(
                    'Arrange numbers to make each side of the triangle equal!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Game preview/placeholder
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                          maxHeight: 350,
                        ),
                        child: _buildTrianglePreview(isDark),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Difficulty buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [                      _buildDifficultyButton(
                        context, 
                        'Easy', 
                        Colors.green,
                        DifficultyType.easy,
                      ),
                      const SizedBox(width: 12),
                      _buildDifficultyButton(
                        context, 
                        'Medium', 
                        Colors.orange,
                        DifficultyType.medium,
                      ),
                      const SizedBox(width: 12),
                      _buildDifficultyButton(
                        context, 
                        'Hard', 
                        Colors.red,
                        DifficultyType.hard,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Start button
                  _buildStartButton(context),
                  
                  const SizedBox(height: 20),
                ],
              ),
          ),
        ),
      ),
    );
  }
  
  }
 
  Widget _buildAnimatedTitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Text(
        'Magic Triangle',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white 
              : Colors.purple[800],
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
  
  Widget _buildTrianglePreview(bool isDark) {
    return CustomPaint(
      painter: TrianglePreviewPainter(
        isDark: isDark,
        primaryColor: Colors.purple,
      ),
      child: Container(),
    );
  }
    Widget _buildDifficultyButton(BuildContext context, String label, Color color, DifficultyType difficulty) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = difficulty == _selectedDifficulty;
    
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDifficulty = difficulty;
        });
        // Initialize triangle with new difficulty
        ref.read(magicTriangleControllerProvider(_selectedDifficulty).notifier).initializeTriangle();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
            ? color
            : isDark ? Colors.grey[800] : Colors.grey[200],
        foregroundColor: isSelected 
            ? Colors.white 
            : isDark ? Colors.white70 : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: isSelected ? 4 : 1,
      ),
      child: Text(label),
    );
  }
    Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Start the game with selected difficulty
        setState(() {
          _isGameStarted = true;
        });
        // Initialize and start the game
        final controller = ref.read(magicTriangleControllerProvider(_selectedDifficulty).notifier);
        controller.initializeTriangle();
        controller.startGame();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.play_circle),
          SizedBox(width: 8),
          Text(
            'Start Game',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
              _buildHelpItem(context, 'Place numbers 1-9 into the circles of the triangle.'),
              _buildHelpItem(context, 'Each side of the triangle must sum to the same value.'),
              _buildHelpItem(context, 'Each number can only be used once.'),
              _buildHelpItem(context, 'The difficulty level determines the size and complexity of the triangle.'),
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

/// Custom painter for the triangle preview
class TrianglePreviewPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;
  
  TrianglePreviewPainter({
    required this.isDark,
    required this.primaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.purple.shade700 : Colors.purple.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
      
    final circlePaint = Paint()
      ..color = isDark ? Colors.grey[700]! : Colors.white
      ..style = PaintingStyle.fill;
      
    final circleStrokePaint = Paint()
      ..color = isDark ? Colors.purple.shade600 : Colors.purple.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    // Draw the triangle
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Draw circles at each corner
    _drawCircleWithNumber(canvas, size.width / 2, 0, '1', circlePaint, circleStrokePaint, textPainter);
    _drawCircleWithNumber(canvas, size.width, size.height, '6', circlePaint, circleStrokePaint, textPainter);
    _drawCircleWithNumber(canvas, 0, size.height, '5', circlePaint, circleStrokePaint, textPainter);
    
    // Draw circles in the middle of each side
    _drawCircleWithNumber(canvas, size.width * 0.75, size.height / 2, '3', circlePaint, circleStrokePaint, textPainter);
    _drawCircleWithNumber(canvas, size.width * 0.25, size.height / 2, '4', circlePaint, circleStrokePaint, textPainter);
    _drawCircleWithNumber(canvas, size.width * 0.5, size.height * 0.66, '2', circlePaint, circleStrokePaint, textPainter);
    
    // Draw the target sum
    final sumStyle = TextStyle(
      color: isDark ? Colors.white : Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    
    textPainter.text = TextSpan(
      text: 'Target sum: 9',
      style: sumStyle,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(
      size.width / 2 - textPainter.width / 2,
      size.height * 0.35 - textPainter.height / 2,
    ));
  }
  
  void _drawCircleWithNumber(
    Canvas canvas, 
    double x, 
    double y, 
    String number, 
    Paint circlePaint, 
    Paint strokePaint, 
    TextPainter textPainter,
  ) {
    final radius = 25.0;
    
    // Draw the circle
    canvas.drawCircle(Offset(x, y), radius, circlePaint);
    canvas.drawCircle(Offset(x, y), radius, strokePaint);
    
    // Draw the number
    final textStyle = TextStyle(
      color: isDark ? Colors.white : Colors.black87,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    
    textPainter.text = TextSpan(
      text: number,
      style: textStyle,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(
      x - textPainter.width / 2,
      y - textPainter.height / 2,
    ));
  }
  
  @override
  bool shouldRepaint(covariant TrianglePreviewPainter oldDelegate) => 
      oldDelegate.isDark != isDark ||
      oldDelegate.primaryColor != primaryColor;
}
