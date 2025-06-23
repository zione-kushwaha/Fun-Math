import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/provider/number_pyramid_providers.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/state/number_pyramid_state.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/widgets/number_input_panel.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/widgets/pyramid_completion_dialog.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/widgets/pyramid_control_panel.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/widgets/pyramid_grid.dart';
import 'package:fun_math/feature/games/brain_boost/feature/number_pyramid/presentation/widgets/pyramid_stats_panel.dart';
import 'package:iconsax/iconsax.dart';

class NumberPyramidScreen extends ConsumerStatefulWidget {
  const NumberPyramidScreen({super.key});

  @override
  ConsumerState<NumberPyramidScreen> createState() => _NumberPyramidScreenState();
}

class _NumberPyramidScreenState extends ConsumerState<NumberPyramidScreen> {
  DifficultyType _selectedDifficulty = DifficultyType.easy;
  bool _isGameStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the pyramid when the screen loads
      ref.read(numberPyramidControllerProvider(_selectedDifficulty).notifier).initializePyramid();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (_isGameStarted) {
      // Game screen
      final state = ref.watch(numberPyramidControllerProvider(_selectedDifficulty));
      
      // Show completion dialog when game is completed
      if (state.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PyramidCompletionDialog(
              difficulty: _selectedDifficulty,
            ),
          );
        });
      }
      
      return Scaffold(
        appBar: AppBar(
          title: const Text('Number Pyramid'),
          backgroundColor: isDark ? Colors.teal[800] : Colors.teal[600],
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
                  : [Colors.teal[100]!, Colors.teal[50]!],
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
                  PyramidStatsPanel(difficulty: _selectedDifficulty),
                  
                  const SizedBox(height: 16),
                  
                  // Game board - takes most of the space
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: PyramidGrid(
                        difficulty: _selectedDifficulty,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Number input panel
                  Expanded(
                    flex: 2,
                    child: NumberInputPanel(difficulty: _selectedDifficulty),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Game controls
                  PyramidControlPanel(difficulty: _selectedDifficulty),
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
          title: const Text('Number Pyramid'),
          backgroundColor: isDark ? Colors.teal[800] : Colors.teal[600],
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
                  : [Colors.teal[100]!, Colors.teal[50]!],
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
                    'Fill in the missing numbers where each number is the sum of the two numbers below it!',
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
                        child: _buildPyramidPreview(isDark),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Difficulty buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDifficultyButton(
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
        'Number Pyramid',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white 
              : Colors.teal[800],
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
  
  Widget _buildPyramidPreview(bool isDark) {
    return CustomPaint(
      painter: PyramidPreviewPainter(
        isDark: isDark,
        primaryColor: Colors.teal,
      ),
      child: Container(),
    );
  }
  
  Widget _buildDifficultyButton(
    BuildContext context, 
    String label, 
    Color color,
    DifficultyType difficulty,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = difficulty == _selectedDifficulty;
    
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDifficulty = difficulty;
        });
        // Initialize pyramid with new difficulty
        ref.read(numberPyramidControllerProvider(_selectedDifficulty).notifier).initializePyramid();
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
        final controller = ref.read(numberPyramidControllerProvider(_selectedDifficulty).notifier);
        controller.initializePyramid();
        controller.startGame();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
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
              _buildHelpItem(context, 'In a Number Pyramid, each number is the sum of the two numbers directly below it.'),
              _buildHelpItem(context, 'Some numbers are already filled in to help you start.'),
              _buildHelpItem(context, 'Fill in all empty cells to complete the pyramid.'),
              _buildHelpItem(context, 'The difficulty level determines the size of the pyramid and how many numbers are pre-filled.'),
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
          const Icon(Icons.check_circle, color: Colors.teal, size: 20),
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

/// Custom painter for the pyramid preview
class PyramidPreviewPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;
  
  PyramidPreviewPainter({
    required this.isDark,
    required this.primaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? primaryColor.withOpacity(0.5) : primaryColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
      
    final strokePaint = Paint()
      ..color = isDark ? primaryColor : primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final cellSize = Size(60, 60);
    final cellPadding = 5.0;
    final totalWidth = size.width;
    final centerX = totalWidth / 2;
    
    // Draw a 4-row pyramid
    _drawCell(canvas, Offset(centerX - cellSize.width / 2, 20), cellSize, '28', true, isDark);
    
    _drawCell(canvas, Offset(centerX - cellSize.width - cellPadding, 20 + cellSize.height + cellPadding), cellSize, '11', false, isDark);
    _drawCell(canvas, Offset(centerX + cellPadding, 20 + cellSize.height + cellPadding), cellSize, '17', true, isDark);
    
    _drawCell(canvas, Offset(centerX - cellSize.width * 1.5 - cellPadding * 2, 20 + (cellSize.height + cellPadding) * 2), cellSize, '5', true, isDark);
    _drawCell(canvas, Offset(centerX - cellSize.width / 2, 20 + (cellSize.height + cellPadding) * 2), cellSize, '?', false, isDark);
    _drawCell(canvas, Offset(centerX + cellSize.width / 2 + cellPadding, 20 + (cellSize.height + cellPadding) * 2), cellSize, '9', true, isDark);
    
    _drawCell(canvas, Offset(centerX - cellSize.width * 2 - cellPadding * 3, 20 + (cellSize.height + cellPadding) * 3), cellSize, '2', true, isDark);
    _drawCell(canvas, Offset(centerX - cellSize.width - cellPadding, 20 + (cellSize.height + cellPadding) * 3), cellSize, '3', true, isDark);
    _drawCell(canvas, Offset(centerX + cellPadding, 20 + (cellSize.height + cellPadding) * 3), cellSize, '?', false, isDark);
    _drawCell(canvas, Offset(centerX + cellSize.width + cellPadding * 2, 20 + (cellSize.height + cellPadding) * 3), cellSize, '4', true, isDark);
    
    // Draw connector lines
    final linePaint = Paint()
      ..color = isDark ? primaryColor.withOpacity(0.8) : primaryColor.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Draw lines connecting the cells
    _drawConnector(canvas, 
      centerX,  
      20 + cellSize.height, 
      centerX - cellSize.width - cellPadding + cellSize.width / 2, 
      20 + cellSize.height + cellPadding,
      linePaint);
      
    _drawConnector(canvas, 
      centerX,  
      20 + cellSize.height, 
      centerX + cellPadding + cellSize.width / 2, 
      20 + cellSize.height + cellPadding,
      linePaint);
      
    // More connectors from second to third row
    _drawConnector(canvas, 
      centerX - cellSize.width - cellPadding + cellSize.width / 2,  
      20 + cellSize.height * 2 + cellPadding, 
      centerX - cellSize.width * 1.5 - cellPadding * 2 + cellSize.width / 2, 
      20 + (cellSize.height + cellPadding) * 2,
      linePaint);
      
    _drawConnector(canvas, 
      centerX - cellSize.width - cellPadding + cellSize.width / 2,  
      20 + cellSize.height * 2 + cellPadding, 
      centerX - cellSize.width / 2, 
      20 + (cellSize.height + cellPadding) * 2,
      linePaint);
      
    _drawConnector(canvas, 
      centerX + cellPadding + cellSize.width / 2,  
      20 + cellSize.height * 2 + cellPadding, 
      centerX - cellSize.width / 2, 
      20 + (cellSize.height + cellPadding) * 2,
      linePaint);
      
    _drawConnector(canvas, 
      centerX + cellPadding + cellSize.width / 2,  
      20 + cellSize.height * 2 + cellPadding, 
      centerX + cellSize.width / 2 + cellPadding, 
      20 + (cellSize.height + cellPadding) * 2,
      linePaint);
      
    // And connectors from third to bottom row
    // ... (more connectors would be drawn here)
  }
  
  void _drawCell(Canvas canvas, Offset position, Size size, String text, bool filled, bool isDark) {
    final cellPaint = Paint()
      ..color = filled
          ? (isDark ? primaryColor.withOpacity(0.3) : primaryColor.withOpacity(0.1))
          : (isDark ? Colors.grey[800]! : Colors.white)
      ..style = PaintingStyle.fill;
      
    final strokePaint = Paint()
      ..color = isDark ? primaryColor.withOpacity(0.8) : primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final rect = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    
    // Draw cell
    canvas.drawRRect(rrect, cellPaint);
    canvas.drawRRect(rrect, strokePaint);
    
    // Draw text
    final textStyle = TextStyle(
      color: isDark ? Colors.white : Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout();
    
    final textX = position.dx + (size.width / 2) - (textPainter.width / 2);
    final textY = position.dy + (size.height / 2) - (textPainter.height / 2);
    
    textPainter.paint(canvas, Offset(textX, textY));
  }
  
  void _drawConnector(Canvas canvas, double startX, double startY, double endX, double endY, Paint paint) {
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }
  
  @override
  bool shouldRepaint(covariant PyramidPreviewPainter oldDelegate) => 
      oldDelegate.isDark != isDark ||
      oldDelegate.primaryColor != primaryColor;
}
