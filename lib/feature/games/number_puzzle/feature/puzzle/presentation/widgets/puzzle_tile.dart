import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PuzzleTile extends StatelessWidget {
  final int number;
  final bool isMovable;
  final VoidCallback onTap;
  final bool isCorrectPosition;
  final bool isEmpty;
  final bool animated;

  const PuzzleTile({
    Key? key,
    required this.number,
    required this.isMovable,
    required this.onTap,
    required this.isCorrectPosition,
    required this.isEmpty,
    this.animated = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (isEmpty) {
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
      );
    }

    return AnimatedContainer(
      duration: animated ? const Duration(milliseconds: 200) : Duration.zero,
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: isMovable ? onTap : null,
        child: Material(
          elevation: isMovable ? 8 : 4,
          borderRadius: BorderRadius.circular(12),
          color: _getTileColor(isDarkMode, isCorrectPosition, isMovable),
          child: AnimatedContainer(
            duration: animated ? const Duration(milliseconds: 200) : Duration.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isMovable
                    ? (isDarkMode ? Colors.white24 : theme.primaryColor.withOpacity(0.3))
                    : Colors.transparent,
                width: 2,
              ),
              gradient: isMovable
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [
                              theme.primaryColor.withOpacity(0.5),
                              theme.primaryColor.withOpacity(0.2),
                            ]
                          : [
                              theme.primaryColor.withOpacity(0.9),
                              theme.primaryColor.withOpacity(0.7),
                            ],
                    )
                  : null,
              boxShadow: isMovable
                  ? [
                      BoxShadow(
                        color: isDarkMode
                            ? theme.primaryColor.withOpacity(0.3)
                            : theme.primaryColor.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isMovable
                      ? (isDarkMode ? Colors.white : Colors.white)
                      : (isDarkMode ? Colors.white70 : theme.colorScheme.onSurface),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTileColor(bool isDarkMode, bool isCorrectPosition, bool isMovable) {
    if (isMovable) {
      return Colors.transparent; // We're using gradient instead
    } else {
      return isDarkMode
          ? (isCorrectPosition ? Colors.green.withOpacity(0.3) : Colors.grey.shade800)
          : (isCorrectPosition ? Colors.green.withOpacity(0.1) : Colors.grey.shade200);
    }
  }
}
