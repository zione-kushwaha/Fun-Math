import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/difficulty_selector_provider.dart';

class DifficultySelector extends ConsumerWidget {
  const DifficultySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDifficulty = ref.watch(difficultyProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'Select Difficulty',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 112, // Slightly increased height to prevent overflow
          decoration: BoxDecoration(
            color: isDarkMode 
                ? theme.colorScheme.surfaceVariant.withOpacity(0.4)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDarkMode 
                  ? theme.colorScheme.outline.withOpacity(0.1)
                  : theme.colorScheme.outline.withOpacity(0.05),
            ),
            boxShadow: [
              if (!isDarkMode)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                _buildDifficultyOption(
                  context: context,
                  ref: ref,
                  difficulty: Difficulty.easy,
                  label: 'Easy',
                  icon: Icons.sentiment_very_satisfied,
                  color: Colors.green,
                  isSelected: currentDifficulty == Difficulty.easy,
                  isDarkMode: isDarkMode,
                ),
                _buildDivider(isDarkMode),
                _buildDifficultyOption(
                  context: context,
                  ref: ref,
                  difficulty: Difficulty.medium,
                  label: 'Medium',
                  icon: Icons.sentiment_satisfied,
                  color: Colors.orange,
                  isSelected: currentDifficulty == Difficulty.medium,
                  isDarkMode: isDarkMode,
                ),
                _buildDivider(isDarkMode),
                _buildDifficultyOption(
                  context: context,
                  ref: ref,
                  difficulty: Difficulty.hard,
                  label: 'Hard',
                  icon: Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                  isSelected: currentDifficulty == Difficulty.hard,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Container(
      width: 1,
      height: 40,
      color: isDarkMode 
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05),
    );
  }

  Widget _buildDifficultyOption({
    required BuildContext context,
    required WidgetRef ref,
    required Difficulty difficulty,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref.read(difficultyProvider.notifier).setDifficulty(difficulty),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? color.withOpacity(isDarkMode ? 0.2 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected 
                    ? color 
                    : isDarkMode 
                        ? theme.colorScheme.onSurface.withOpacity(0.7)
                        : theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected 
                      ? color 
                      : isDarkMode 
                          ? theme.colorScheme.onSurface.withOpacity(0.8)
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                Container(
                  width: 24,
                  height: 2,
                  color: color,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}