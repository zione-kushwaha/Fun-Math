import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/domain/model/pattern_master.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/provider/pattern_master_providers.dart';
import 'dart:math' as math;

class PatternGrid extends ConsumerWidget {
  final DifficultyType difficulty;

  const PatternGrid({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(patternMasterControllerProvider(difficulty));
    final sequence = state.currentSequence;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sequence == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pattern sequence
          Expanded(
            child: Center(
              child: _buildPatternSequence(context, sequence, isDark),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Question mark for missing item
          Text(
            'What comes next in the pattern?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPatternSequence(BuildContext context, PatternSequence sequence, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / (sequence.items.length);
        final itemHeight = constraints.maxHeight * 0.6;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            sequence.items.length,
            (index) {
              final item = sequence.items[index];
              
              // For missing item, show question mark placeholder
              if (index == sequence.missingIndex) {
                return Container(
                  width: itemWidth,
                  height: itemHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.indigo[400]! : Colors.indigo,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.question_mark,
                    size: 40,
                    color: isDark ? Colors.indigo[300] : Colors.indigo,
                  ),
                );
              }
              
              return Container(
                width: itemWidth,
                height: itemHeight,
                alignment: Alignment.center,
                child: _buildPatternItem(item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPatternItem(PatternItem item) {
    // Skip rendering the missing item
    if (item.size == 0.0) {
      return const SizedBox.shrink();
    }
    
    switch (item.element) {
      case PatternElement.circle:
        return Container(
          width: item.size,
          height: item.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.color,
          ),
        );
        
      case PatternElement.square:
        return Container(
          width: item.size,
          height: item.size,
          decoration: BoxDecoration(
            color: item.color,
          ),
        );
        
      case PatternElement.triangle:
        return CustomPaint(
          size: Size(item.size, item.size),
          painter: TrianglePainter(color: item.color),
        );
        
      case PatternElement.hexagon:
        return CustomPaint(
          size: Size(item.size, item.size),
          painter: HexagonPainter(color: item.color),
        );
        
      case PatternElement.diamond:
        return Transform.rotate(
          angle: 0.785398, // 45 degrees in radians
          child: Container(
            width: item.size * 0.7,
            height: item.size * 0.7,
            decoration: BoxDecoration(
              color: item.color,
            ),
          ),
        );
        
      case PatternElement.star:
        return CustomPaint(
          size: Size(item.size, item.size),
          painter: StarPainter(color: item.color),
        );
        
      case PatternElement.cross:
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: item.size * 0.3,
              height: item.size,
              decoration: BoxDecoration(
                color: item.color,
              ),
            ),
            Container(
              width: item.size,
              height: item.size * 0.3,
              decoration: BoxDecoration(
                color: item.color,
              ),
            ),
          ],
        );
        
      case PatternElement.heart:
        return CustomPaint(
          size: Size(item.size, item.size),
          painter: HeartPainter(color: item.color),
        );
    }
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  
  TrianglePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
      
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonPainter extends CustomPainter {
  final Color color;
  
  HexagonPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;
    
    for (var i = 0; i < 6; i++) {
      final angle = i * 2 * 3.14159 / 6;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  final Color color;
  
  StarPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;
    
    for (var i = 0; i < 10; i++) {
      final angle = i *  3.14159 / 5;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = centerX + radius * math. cos(angle);
      final y = centerY + radius * math. sin(angle);
      // Move to the first point
      
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeartPainter extends CustomPainter {
  final Color color;
  
  HeartPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    path.moveTo(width / 2, height / 5);
    
    // Left curve
    path.cubicTo(
      0, 0,
      0, height / 2,
      width / 2, height
    );
    
    // Right curve
    path.cubicTo(
      width, height / 2,
      width, 0,
      width / 2, height / 5
    );
    
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
