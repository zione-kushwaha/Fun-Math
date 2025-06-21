import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PuzzleControls extends StatelessWidget {
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onToggleHelp;
  final VoidCallback onToggleSound;
  final bool isPaused;
  final bool isSoundEnabled;
  final bool showHelp;

  const PuzzleControls({
    Key? key,
    required this.onPause,
    required this.onResume,
    required this.onRestart,
    required this.onToggleHelp,
    required this.onToggleSound,
    required this.isPaused,
    required this.isSoundEnabled,
    required this.showHelp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      color: isDarkMode ? Colors.grey[850] : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: isPaused ? Icons.play_arrow : Icons.pause,
              label: isPaused ? 'Resume' : 'Pause',
              onTap: isPaused ? onResume : onPause,
              theme: theme,
              isDarkMode: isDarkMode,
            ),
            _buildControlButton(
              icon: Icons.restart_alt,
              label: 'Restart',
              onTap: onRestart,
              theme: theme,
              isDarkMode: isDarkMode,
            ),
            _buildControlButton(
              icon: showHelp ? Icons.help : Icons.help_outline,
              label: 'Help',
              onTap: onToggleHelp,
              theme: theme,
              isDarkMode: isDarkMode,
              isActive: showHelp,
            ),
            _buildControlButton(
              icon: isSoundEnabled ? Icons.volume_up : Icons.volume_off,
              label: isSoundEnabled ? 'Sound On' : 'Sound Off',
              onTap: onToggleSound,
              theme: theme,
              isDarkMode: isDarkMode,
              isActive: isSoundEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDarkMode,
    bool isActive = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: isActive 
                ? theme.primaryColor 
                : isDarkMode ? Colors.white70 : Colors.grey[700],
            size: 24,
          ),
          tooltip: label,
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: isDarkMode ? Colors.white60 : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
