import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignButton extends StatelessWidget {
  final String sign;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onPressed;

  const SignButton({
    Key? key,
    required this.sign,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.black;
    
    if (isSelected) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        textColor = Colors.white;
      } else if (isWrong) {
        backgroundColor = Colors.red;
        textColor = Colors.white;
      } else {
        backgroundColor = Theme.of(context).colorScheme.primary;
        textColor = Colors.white;
      }
    } else {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      backgroundColor = isDark ? Colors.grey[800]! : Colors.white;
      textColor = isDark ? Colors.white : Colors.black;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            sign,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
