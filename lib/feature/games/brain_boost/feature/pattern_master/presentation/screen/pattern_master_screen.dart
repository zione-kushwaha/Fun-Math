import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/provider/pattern_master_providers.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/widgets/pattern_completion_dialog.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/widgets/pattern_control_panel.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/widgets/pattern_grid.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/widgets/pattern_stats_panel.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/pattern_options_panel.dart';

class PatternMasterScreen extends ConsumerStatefulWidget {
  const PatternMasterScreen({super.key});

  @override
  ConsumerState<PatternMasterScreen> createState() => _PatternMasterScreenState();
}

class _PatternMasterScreenState extends ConsumerState<PatternMasterScreen> {
  DifficultyType _selectedDifficulty = DifficultyType.easy;
  bool _isGameStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the game when the screen loads
      ref.read(patternMasterControllerProvider(_selectedDifficulty).notifier).initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (_isGameStarted) {
      // Game screen
      final state = ref.watch(patternMasterControllerProvider(_selectedDifficulty));
      
      // Show completion dialog when game is completed
      if (state.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PatternCompletionDialog(
              difficulty: _selectedDifficulty,
            ),
          );
        });
      }
      
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pattern Master'),
          backgroundColor: isDark ? Colors.indigo[800] : Colors.indigo[600],
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
                  : [Colors.indigo[100]!, Colors.indigo[50]!],
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
                  PatternStatsPanel(difficulty: _selectedDifficulty),
                  
                  const SizedBox(height: 16),
                  
                  // Pattern grid
                  Expanded(
                    flex: 3,
                    child: PatternGrid(
                      difficulty: _selectedDifficulty,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Pattern options
                  PatternOptionsPanel(difficulty: _selectedDifficulty),
                  
                  const SizedBox(height: 16),
                  
                  // Game controls
                  PatternControlPanel(difficulty: _selectedDifficulty),
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
          title: const Text('Pattern Master'),
          backgroundColor: isDark ? Colors.indigo[800] : Colors.indigo[600],
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
                  : [Colors.indigo[100]!, Colors.indigo[50]!],
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
                    'Find the missing pattern in the sequence!',
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
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _buildPatternPreview(),
                        ),
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
        'Pattern Master',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.white 
              : Colors.indigo[800],
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
  
  Widget _buildPatternPreview() {
    return CustomPaint(
      painter: PatternPreviewPainter(
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
      size: const Size(350, 200),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedButton(
      onPressed: () {
        // Start the game with selected difficulty
        final controller = ref.read(patternMasterControllerProvider(_selectedDifficulty).notifier);
        controller.initializeGame();
        controller.startGame();
        
        setState(() {
          _isGameStarted = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
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
              _buildHelpItem(context, 'Look at the patterns in the sequence and identify what\'s missing.'),
              _buildHelpItem(context, 'Patterns can be based on shape, color, size, or position.'),
              _buildHelpItem(context, 'Select the correct pattern from the options below.'),
              _buildHelpItem(context, 'The difficulty level determines the complexity and length of the patterns.'),
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

/// Custom painter for the pattern preview
class PatternPreviewPainter extends CustomPainter {
  final bool isDark;
  
  PatternPreviewPainter({
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Draw the pattern sequence background
    final bgPaint = Paint()
      ..color = isDark ? Colors.grey[700]! : Colors.grey[200]!
      ..style = PaintingStyle.fill;
      
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 20, width, height * 0.4),
        const Radius.circular(10),
      ),
      bgPaint,
    );
    
    // Draw the pattern shapes
    final shapeDiameter = width / 8;
    final yCenter = 20 + (height * 0.4 / 2);
    
    // Draw 5 shapes with one missing
    _drawCircle(canvas, width / 6, yCenter, shapeDiameter, Colors.red);
    _drawSquare(canvas, width * 2 / 6, yCenter, shapeDiameter, Colors.blue);
    _drawTriangle(canvas, width * 3 / 6, yCenter, shapeDiameter, Colors.green);
    
    // Draw question mark for missing shape
    final textPainter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: isDark ? Colors.indigo[200] : Colors.indigo[700],
          fontSize: shapeDiameter * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(
        width * 4 / 6 - textPainter.width / 2, 
        yCenter - textPainter.height / 2,
      ),
    );
    
    _drawCircle(canvas, width * 5 / 6, yCenter, shapeDiameter, Colors.purple);
    
    // Draw the options section
    final optionsPaint = Paint()
      ..color = isDark ? Colors.grey[800]! : Colors.white
      ..style = PaintingStyle.fill;
      
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, height * 0.7, width, height * 0.3),
        const Radius.circular(10),
      ),
      optionsPaint,
    );
    
    // Draw options title
    final optionsTextPainter = TextPainter(
      text: TextSpan(
        text: 'Select the correct pattern:',
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    optionsTextPainter.layout();
    optionsTextPainter.paint(
      canvas, 
      Offset(
        width / 2 - optionsTextPainter.width / 2, 
        height * 0.7 + 10,
      ),
    );
    
    // Draw option shapes
    final optionDiameter = shapeDiameter * 0.8;
    final optionY = height * 0.7 + height * 0.15;
    
    _drawCircle(canvas, width / 5, optionY, optionDiameter, Colors.orange);
    _drawSquare(canvas, width * 2 / 5, optionY, optionDiameter, Colors.pink);
    _drawTriangle(canvas, width * 3 / 5, optionY, optionDiameter, Colors.teal);
    _drawStar(canvas, width * 4 / 5, optionY, optionDiameter, Colors.amber);
  }
  
  void _drawCircle(Canvas canvas, double x, double y, double diameter, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(
      Offset(x, y), 
      diameter / 2, 
      paint,
    );
  }
  
  void _drawSquare(Canvas canvas, double x, double y, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(x, y),
        width: size,
        height: size,
      ), 
      paint,
    );
  }
  
  void _drawTriangle(Canvas canvas, double x, double y, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path()
      ..moveTo(x, y - size / 2)
      ..lineTo(x + size / 2, y + size / 2)
      ..lineTo(x - size / 2, y + size / 2)
      ..close();
      
    canvas.drawPath(path, paint);
  }
  
  void _drawStar(Canvas canvas, double x, double y, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path();
    final outerRadius = size / 2;
    final innerRadius = size / 4;
    
    for (var i = 0; i < 10; i++) {
      final angle = i * math.pi / 5;
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final px = x + radius * math.cos(angle - math.pi / 2);
      final py = y + radius * math.sin(angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
