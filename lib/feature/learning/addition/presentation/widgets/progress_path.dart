import 'package:flutter/material.dart';

class ProgressPath extends StatelessWidget {
  const ProgressPath({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      height: 100,
      child: CustomPaint(
        painter: PathPainter(
          isDarkMode: isDarkMode,
          primaryColor: colorScheme.primary,
          progress: 0.65, // 65% progress along the path
        ),
        child: Stack(
          children: [
            // Start point
            Positioned(
              left: 0,
              top: 40,
              child: _buildMilestone(
                context,
                label: "Start",
                isCompleted: true,
                color: Colors.green,
              ),
            ),
            
            // Milestone 1
            Positioned(
              left: 100,
              top: 20,
              child: _buildMilestone(
                context,
                label: "Basics",
                isCompleted: true,
                color: Colors.blue,
              ),
            ),
            
            // Milestone 2
            Positioned(
              left: 200,
              top: 60,
              child: _buildMilestone(
                context,
                label: "Practice",
                isCompleted: true,
                color: Colors.orange,
              ),
            ),
            
            // Milestone 3
            Positioned(
              left: 300,
              top: 30,
              child: _buildMilestone(
                context,
                label: "Master",
                isCompleted: false,
                color: Colors.purple,
              ),
            ),
            
            // Current position marker (animated)
            Positioned(
              left: 220, // Position along the path
              top: 55,
              child: _buildCurrentPositionMarker(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMilestone(
    BuildContext context, {
    required String label,
    required bool isCompleted,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.grey.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isCompleted ? color : Colors.grey,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCurrentPositionMarker() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final bool isDarkMode;
  final Color primaryColor;
  final double progress;
  
  PathPainter({
    required this.isDarkMode,
    required this.primaryColor,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    final progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    
    // Create a wavy path
    final path = Path();
    path.moveTo(0, size.height / 2);
    
    // Wavy pattern
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.5,
    );
    
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width,
      size.height * 0.5,
    );
    
    // Draw the background path
    canvas.drawPath(path, paint);
    
    // Draw the progress path
    final progressPath = Path();
    progressPath.moveTo(0, size.height / 2);
    
    progressPath.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.5 * progress * 2,
      size.height * 0.5 - (0.5 - progress) * size.height * 0.5,
    );
    
    canvas.drawPath(progressPath, progressPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
