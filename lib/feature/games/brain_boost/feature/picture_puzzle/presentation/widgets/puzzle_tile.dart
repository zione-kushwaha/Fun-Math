import 'package:flutter/material.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';

class PuzzleTile extends StatelessWidget {
  final PicturePuzzleTile tile;
  final int gridSize;
  final bool isLastMoved;
  final String? imagePath;
  final VoidCallback onTap;
  
  const PuzzleTile({
    super.key,
    required this.tile,
    required this.gridSize,
    this.isLastMoved = false,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCorrectPosition = tile.isInCorrectPosition;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isDark
              ? (isCorrectPosition ? Colors.green[900] : Colors.blue[800])
              : (isCorrectPosition ? Colors.green[300] : Colors.blue[400]),
          border: Border.all(
            color: isDark ? Colors.black26 : Colors.white30,
            width: 1,
          ),
          boxShadow: isLastMoved
              ? [
                  BoxShadow(
                    color: (isDark ? Colors.cyan : Colors.blue).withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: _buildTileContent(context),
      ),
    );
  }

  Widget _buildTileContent(BuildContext context) {
    if (imagePath != null) {
      // If we have an image path, display a section of the image for this tile
      return _buildImageTile();
    } else {
      // Otherwise, display a numbered tile
      return _buildNumberedTile(context);
    }
  }

  Widget _buildImageTile() {
    // Calculate the position of this tile in the original image
    final tileSize = 1.0 / gridSize;
    final row = tile.correctPosition ~/ gridSize;
    final col = tile.correctPosition % gridSize;
    
    return ClipRect(
      child: FractionalTranslation(
        translation: Offset(col * -tileSize, row * -tileSize),
        child: Transform.scale(
          scale: gridSize.toDouble(),
          child: Image.asset(
            imagePath!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberedTile(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Text(
        '${tile.id + 1}',
        style: TextStyle(
          fontSize: 24 - (gridSize * 2), // Adjust font size based on grid size
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}
