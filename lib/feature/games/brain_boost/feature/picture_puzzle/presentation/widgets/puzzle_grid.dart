import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/domain/model/picture_puzzle.dart';
import 'package:fun_math/feature/games/brain_boost/feature/picture_puzzle/presentation/widgets/puzzle_tile.dart';

class PuzzleGrid extends StatelessWidget {
  final List<PicturePuzzleTile> tiles;
  final int gridSize;
  final String? imagePath;
  final int emptyTileIndex;
  final Function(int) onTileTapped;
  final int? lastMovedTileIndex;
  
  const PuzzleGrid({
    super.key,
    required this.tiles,
    required this.gridSize,
    this.imagePath,
    required this.emptyTileIndex,
    required this.onTileTapped,
    this.lastMovedTileIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: tiles.length,
          itemBuilder: (context, currentIndex) {
            final tile = tiles[currentIndex];
            
            // Skip the empty tile
            if (currentIndex == emptyTileIndex) {
              return Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
              );
            }
            
            final isLastMoved = currentIndex == lastMovedTileIndex;
            
            return PuzzleTile(
              key: ValueKey(tile.id),
              tile: tile,
              gridSize: gridSize,
              isLastMoved: isLastMoved,
              imagePath: imagePath,
              onTap: () => onTileTapped(currentIndex),
            );
          },
        ),
      ),
    );
  }
}
