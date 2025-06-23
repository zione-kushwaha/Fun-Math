import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/brain_boost/feature/pattern_master/presentation/provider/pattern_master_providers.dart';
import 'package:iconsax/iconsax.dart';

class PatternControlPanel extends ConsumerWidget {
  final DifficultyType difficulty;

  const PatternControlPanel({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(patternMasterControllerProvider(difficulty));
    final controller = ref.read(patternMasterControllerProvider(difficulty).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            context,
            icon: Icons.refresh,
            label: 'Skip',
            onPressed: state.hasGameStarted ? controller.skipPattern : null,
            isDark: isDark,
            accentColor: Colors.orange,
          ),
          _buildControlButton(
            context,
            icon: Icons.lightbulb_outline,
            label: 'Hint',
            onPressed: state.hasGameStarted ? controller.showHint : null,
            isDark: isDark,
            accentColor: Colors.amber,
          ),
          _buildControlButton(
            context,
            icon: Icons.exit_to_app,
            label: 'Exit',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  title: Text(
                    'Exit Game',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to exit? Your progress will be lost.',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous screen
                      },
                      child: const Text('Exit'),
                    ),
                  ],
                ),
              );
            },
            isDark: isDark,
            accentColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required bool isDark,
    required Color accentColor,
  }) {
    final isDisabled = onPressed == null;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.grey[800]
                : accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isDisabled
                    ? isDark ? Colors.grey : Colors.grey[400]
                    : accentColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDisabled
                      ? isDark ? Colors.grey : Colors.grey[400]
                      : isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
