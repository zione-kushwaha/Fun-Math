import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/domain/model/magic_triangle.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/provider/magic_triangle_providers.dart';
import 'package:fun_math/feature/games/brain_boost/feature/magic_triangle/presentation/state/magic_triangle_state.dart';

class MagicTriangleBoard extends ConsumerWidget {
  final DifficultyType difficulty;
  
  const MagicTriangleBoard({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(magicTriangleControllerProvider(difficulty).notifier);
    final state = ref.watch(magicTriangleControllerProvider(difficulty));
    
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 350,
      ),
      child: CustomPaint(
        size: const Size(300, 300),
        painter: TrianglePainter(
          state.triangle,
          state.selectedPositionIndex,
          state.triangle.isSolved,
          Theme.of(context).brightness == Brightness.dark,
        ),
        child: state.triangle.numbers.isEmpty 
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTapUp: (details) {
                if (!state.isPlaying) return;
                
                // Convert tap to relative position in the triangle
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final position = renderBox.globalToLocal(details.globalPosition);
                
                // Calculate the index based on the position
                final index = _getTriangleIndexFromPosition(
                  position, 
                  renderBox.size, 
                  state.triangle.size
                );
                
                if (index != null) {
                  controller.selectPosition(index);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: List.generate(
                  state.triangle.numbers.length,
                  (index) {
                    // Calculate node position
                    final nodePosition = _getNodePosition(
                      index,
                      state.triangle.size,
                    );
                    
                    final value = state.triangle.numbers[index];
                    
                    return Positioned(
                      left: nodePosition.dx - 20,
                      top: nodePosition.dy - 20,
                      width: 40,
                      height: 40,
                      child: MagicTriangleNode(
                        value: value,
                        isSelected: index == state.selectedPositionIndex,
                        onTap: () => controller.selectPosition(index),
                      ),
                    );
                  },
                ),
              ),
            ),
      ),
    );
  }
  
  int? _getTriangleIndexFromPosition(Offset position, Size size, int triangleSize) {
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final triangleHeight = height * 0.85;
    
    final totalNodes = triangleSize == 3 ? 6 : triangleSize == 4 ? 9 : 12;
    
    for (int i = 0; i < totalNodes; i++) {
      final nodePos = _getNodePosition(i, triangleSize);
      
      // Convert node position from relative to absolute coordinates
      final nodeX = centerX + (nodePos.dx / 300 * width) - width / 2;
      final nodeY = nodePos.dy / 300 * triangleHeight;
      
      // Check if tap is close enough to this node
      final distance = ((position.dx - nodeX) * (position.dx - nodeX) + 
                        (position.dy - nodeY) * (position.dy - nodeY));
                        
      if (distance < 400) { // Threshold distance squared
        return i;
      }
    }
    
    return null;
  }
  
  Offset _getNodePosition(int index, int triangleSize) {
    // Position nodes based on the triangle size
    final double size = 300;
    final double centerX = size / 2;
    final double triangleHeight = size * 0.85;
    
    if (triangleSize == 3) {
      switch (index) {
        case 0: return Offset(centerX, 20); // Top
        case 1: return Offset(centerX - size/3, size/3); // Top-left
        case 2: return Offset(centerX + size/3, size/3); // Top-right
        case 3: return Offset(centerX - size/5, 2*size/3); // Bottom-left
        case 4: return Offset(centerX + size/5, 2*size/3); // Bottom-right
        case 5: return Offset(centerX, triangleHeight); // Bottom
      }
    } else if (triangleSize == 4) {
      // Positions for 4-sized triangle with 9 nodes
      // Implement positions for medium difficulty
      switch (index) {
        case 0: return Offset(centerX, 20); // Top
        case 1: return Offset(centerX - size/6, size/4); // Top-left 
        case 2: return Offset(centerX + size/6, size/4); // Top-right
        case 3: return Offset(centerX - size/3, size/2); // Middle-left
        case 4: return Offset(centerX, size/2); // Middle-center
        case 5: return Offset(centerX + size/3, size/2); // Middle-right
        case 6: return Offset(centerX - size/6, 3*size/4); // Bottom-left
        case 7: return Offset(centerX + size/6, 3*size/4); // Bottom-right
        case 8: return Offset(centerX, triangleHeight); // Bottom
      }
    } else {
      // Positions for 5-sized triangle with 12 nodes
      // Implement positions for hard difficulty
      switch (index) {
        case 0: return Offset(centerX, 20); // Top
        case 1: return Offset(centerX - size/8, size/5); // Top-left
        case 2: return Offset(centerX + size/8, size/5); // Top-right
        case 3: return Offset(centerX - size/4, 2*size/5); // Upper-middle-left
        case 4: return Offset(centerX, 2*size/5); // Upper-middle-center
        case 5: return Offset(centerX + size/4, 2*size/5); // Upper-middle-right
        case 6: return Offset(centerX - 3*size/8, 3*size/5); // Lower-middle-left
        case 7: return Offset(centerX - size/8, 3*size/5); // Lower-middle-left-center
        case 8: return Offset(centerX + size/8, 3*size/5); // Lower-middle-right-center
        case 9: return Offset(centerX + 3*size/8, 3*size/5); // Lower-middle-right
        case 10: return Offset(centerX - size/6, 4*size/5); // Bottom-left
        case 11: return Offset(centerX + size/6, 4*size/5); // Bottom-right
      }
    }
    
    // Default position
    return Offset(centerX, centerX);
  }
}

class MagicTriangleNode extends StatelessWidget {
  final int? value;
  final bool isSelected;
  final VoidCallback onTap;
  
  const MagicTriangleNode({
    Key? key,
    this.value,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getNodeColor(isDark),
          border: Border.all(
            width: isSelected ? 3 : 1,
            color: isSelected
                ? (isDark ? Colors.purpleAccent : Colors.purple)
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? Colors.purpleAccent : Colors.purple.shade300).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: value != null
              ? Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                )
              : null,
        ),
      ),
    );
  }
  
  Color _getNodeColor(bool isDark) {
    if (value == null) {
      return isDark ? Colors.grey[800]! : Colors.grey[200]!;
    } else {
      return isSelected
          ? (isDark ? Colors.purple[700]! : Colors.purple[100]!)
          : (isDark ? Colors.grey[700]! : Colors.white);
    }
  }
}

class TrianglePainter extends CustomPainter {
  final MagicTriangle triangle;
  final int? selectedPosition;
  final bool isSolved;
  final bool isDark;
  
  TrianglePainter(
    this.triangle,
    this.selectedPosition,
    this.isSolved,
    this.isDark,
  );
  
  @override
  void paint(Canvas canvas, Size size) {
    if (triangle.numbers.isEmpty) return;
    
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final triangleHeight = height * 0.85;
    
    final paint = Paint()
      ..color = isSolved 
          ? (isDark ? Colors.greenAccent[700]! : Colors.green[600]!)
          : (isDark ? Colors.purple[700]! : Colors.purple[300]!)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    final linePaint = Paint()
      ..color = isSolved 
          ? (isDark ? Colors.greenAccent[700]! : Colors.green[600]!)
          : (isDark ? Colors.purple[600]! : Colors.purple[400]!)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    
    // Draw the triangle
    final trianglePath = Path();
    
    // Draw triangle based on size
    if (triangle.size == 3) {
      // Top vertex
      final topPoint = Offset(centerX, 20);
      
      // Bottom left vertex
      final bottomLeftPoint = Offset(centerX - width/3, triangleHeight);
      
      // Bottom right vertex
      final bottomRightPoint = Offset(centerX + width/3, triangleHeight);
      
      trianglePath.moveTo(topPoint.dx, topPoint.dy);
      trianglePath.lineTo(bottomRightPoint.dx, bottomRightPoint.dy);
      trianglePath.lineTo(bottomLeftPoint.dx, bottomLeftPoint.dy);
      trianglePath.close();
      
      // Draw triangle
      canvas.drawPath(trianglePath, paint);
      
      // Draw internal lines
      final leftMiddle = Offset(centerX - width/5, height/2);
      final rightMiddle = Offset(centerX + width/5, height/2);
      
      canvas.drawLine(topPoint, leftMiddle, linePaint);
      canvas.drawLine(topPoint, rightMiddle, linePaint);
      canvas.drawLine(leftMiddle, bottomLeftPoint, linePaint);
      canvas.drawLine(rightMiddle, bottomRightPoint, linePaint);
      canvas.drawLine(leftMiddle, rightMiddle, linePaint);
    } else if (triangle.size == 4) {
      // Implement medium difficulty triangle drawing
      // Positions for 4-sized triangle
      final topPoint = Offset(centerX, 20);
      final bottomPoint = Offset(centerX, triangleHeight);
      final leftPoint = Offset(centerX - width/3, triangleHeight);
      final rightPoint = Offset(centerX + width/3, triangleHeight);
      
      trianglePath.moveTo(topPoint.dx, topPoint.dy);
      trianglePath.lineTo(rightPoint.dx, rightPoint.dy);
      trianglePath.lineTo(leftPoint.dx, leftPoint.dy);
      trianglePath.close();
      
      // Draw triangle
      canvas.drawPath(trianglePath, paint);
      
      // Draw internal lines
      final topLeftMiddle = Offset(centerX - width/6, height/4);
      final topRightMiddle = Offset(centerX + width/6, height/4);
      final middleLeft = Offset(centerX - width/3, height/2);
      final middleCenter = Offset(centerX, height/2);
      final middleRight = Offset(centerX + width/3, height/2);
      final bottomLeftMiddle = Offset(centerX - width/6, 3*height/4);
      final bottomRightMiddle = Offset(centerX + width/6, 3*height/4);
      
      // Connect the nodes
      canvas.drawLine(topPoint, topLeftMiddle, linePaint);
      canvas.drawLine(topPoint, topRightMiddle, linePaint);
      canvas.drawLine(topLeftMiddle, middleLeft, linePaint);
      canvas.drawLine(topLeftMiddle, middleCenter, linePaint);
      canvas.drawLine(topRightMiddle, middleCenter, linePaint);
      canvas.drawLine(topRightMiddle, middleRight, linePaint);
      canvas.drawLine(middleLeft, bottomLeftMiddle, linePaint);
      canvas.drawLine(middleCenter, bottomLeftMiddle, linePaint);
      canvas.drawLine(middleCenter, bottomRightMiddle, linePaint);
      canvas.drawLine(middleRight, bottomRightMiddle, linePaint);
      canvas.drawLine(bottomLeftMiddle, bottomPoint, linePaint);
      canvas.drawLine(bottomRightMiddle, bottomPoint, linePaint);
    } else {
      // Implement hard difficulty triangle drawing
      // Positions for 5-sized triangle
      final topPoint = Offset(centerX, 20);
      final bottomLeftPoint = Offset(centerX - width/3, triangleHeight);
      final bottomRightPoint = Offset(centerX + width/3, triangleHeight);
      
      trianglePath.moveTo(topPoint.dx, topPoint.dy);
      trianglePath.lineTo(bottomRightPoint.dx, bottomRightPoint.dy);
      trianglePath.lineTo(bottomLeftPoint.dx, bottomLeftPoint.dy);
      trianglePath.close();
      
      // Draw triangle
      canvas.drawPath(trianglePath, paint);
      
      // Additional nodes and internal lines for 5-sized triangle
      // Add more complex connections for hard difficulty
      // This would require more positions and connections...
    }
    
    // Draw the target sum
    final targetSumText = 'Target Sum: ${triangle.targetSum}';
    final textSpan = TextSpan(
      text: targetSumText,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(centerX - textPainter.width / 2, triangleHeight + 20),
    );
  }
  
  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.triangle != triangle ||
        oldDelegate.selectedPosition != selectedPosition ||
        oldDelegate.isSolved != isSolved ||
        oldDelegate.isDark != isDark;
  }
}
