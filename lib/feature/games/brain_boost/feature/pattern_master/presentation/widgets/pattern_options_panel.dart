import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/domain/model/pattern_master.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/provider/pattern_master_providers.dart';

class PatternOptionsPanel extends ConsumerWidget {
  final DifficultyType difficulty;

  const PatternOptionsPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(patternMasterControllerProvider(difficulty));
    final controller = ref.read(patternMasterControllerProvider(difficulty).notifier);
    final sequence = state.currentSequence;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sequence == null) {
      return const SizedBox(height: 120);
    }

    // Generate options based on the pattern type
    final options = controller.generateOptions();

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Select the correct pattern:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: options.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _buildOptionItem(
                  context, 
                  options[index], 
                  isDark,
                  () => controller.checkAnswer(options[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, 
    PatternItem option, 
    bool isDark,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: 1.0,
            child: _buildPatternItem(option),
          ),
        ),
      ),
    );
  }

  Widget _buildPatternItem(PatternItem item) {
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
          angle: math.pi / 4, // 45 degrees in radians
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
    
    // Hexagon coordinates
    final points = [
      Offset(centerX + radius, centerY),                  // Right
      Offset(centerX + radius * 0.5, centerY + radius * 0.866),  // Bottom right
      Offset(centerX - radius * 0.5, centerY + radius * 0.866),  // Bottom left
      Offset(centerX - radius, centerY),                  // Left
      Offset(centerX - radius * 0.5, centerY - radius * 0.866),  // Top left
      Offset(centerX + radius * 0.5, centerY - radius * 0.866),  // Top right
    ];
    
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
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
    
    // Star coordinates
    final points = [
      Offset(centerX, centerY - outerRadius),                        // Top outer
      Offset(centerX + innerRadius * 0.224, centerY - innerRadius * 0.309), // Top right inner
      Offset(centerX + outerRadius * 0.588, centerY - outerRadius * 0.809), // Top right outer
      Offset(centerX + innerRadius * 0.362, centerY + innerRadius * 0.118), // Right inner
      Offset(centerX + outerRadius * 0.951, centerY + outerRadius * 0.309), // Right outer
      Offset(centerX + innerRadius * 0.0, centerY + innerRadius * 0.4),     // Bottom right inner
      Offset(centerX, centerY + outerRadius),                        // Bottom outer
      Offset(centerX - innerRadius * 0.362, centerY + innerRadius * 0.118), // Bottom left inner
      Offset(centerX - outerRadius * 0.951, centerY + outerRadius * 0.309), // Left outer
      Offset(centerX - innerRadius * 0.588, centerY - innerRadius * 0.118), // Left inner
    ];
    
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
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
