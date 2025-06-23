import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ImageSelector extends StatelessWidget {
  final List<String> imagePaths;
  final String? selectedImagePath;
  final Function(String) onImageSelected;
  
  const ImageSelector({
    super.key,
    required this.imagePaths,
    this.selectedImagePath,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Select an Image',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: imagePaths.length + 1, // +1 for "Use Numbers" option
            itemBuilder: (context, index) {
              // Special case for "Use Numbers" (represented by null image path)
              if (index == 0) {
                final isSelected = selectedImagePath == null;
                
                return _buildImageOption(
                  context: context,
                  isSelected: isSelected,
                  child: const Icon(
                    Iconsax.calculator,
                    size: 32,
                  ),
                  onTap: () => onImageSelected(''),
                );
              }
              
              // Adjust index for actual images (since index 0 is for "Use Numbers")
              final imagePath = imagePaths[index - 1];
              final isSelected = imagePath == selectedImagePath;
              
              return _buildImageOption(
                context: context,
                isSelected: isSelected,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
                onTap: () => onImageSelected(imagePath),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildImageOption({
    required BuildContext context,
    required bool isSelected,
    required Widget child,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? isDark ? Colors.blue[400]! : Colors.blue
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: child,
        ),
      ),
    );
  }
}
