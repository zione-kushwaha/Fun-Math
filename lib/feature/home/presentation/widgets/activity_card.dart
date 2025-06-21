import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Card widget for displaying math activities
class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final String? gifPath;
  final VoidCallback onTap;

  const ActivityCard({
    Key? key,
    required this.title,
    required this.description,
    required this.iconPath,
    this.gifPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon area at top
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: iconPath.endsWith('.svg') 
                      ? SvgPicture.asset(
                          iconPath,
                          colorFilter: ColorFilter.mode(
                            isDarkMode ? Colors.white : primaryColor,
                            BlendMode.srcIn,
                          ),
                        )
                      : Image.asset(
                          iconPath, 
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback icon if the image doesn't exist
                            return Icon(
                              Icons.calculate_rounded,
                              size: 40,
                              color: isDarkMode ? Colors.white : primaryColor,
                            );
                          },
                        ),
                  ),
                ),
              ),
            ),
            
            // Text area at bottom
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
