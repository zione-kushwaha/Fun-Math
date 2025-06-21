import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/quick_calculation/presentation/provider/quick_calculation_providers.dart';

class QuickCalculationKeypad extends ConsumerWidget {
  const QuickCalculationKeypad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(quickCalculationControllerProvider.notifier);
    final state = ref.watch(quickCalculationControllerProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Don't allow interaction if the game is paused or over
    if (state.isPaused || state.isGameOver) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildRow(['1', '2', '3'], controller, isDarkMode),
          const SizedBox(height: 16),
          _buildRow(['4', '5', '6'], controller, isDarkMode),
          const SizedBox(height: 16),
          _buildRow(['7', '8', '9'], controller, isDarkMode),
          const SizedBox(height: 16),
          _buildLastRow(controller, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers, dynamic controller, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        return _buildKeypadButton(
          text: number,
          onPressed: () => controller.addInput(number),
          isDarkMode: isDarkMode,
        );
      }).toList(),
    );
  }

  Widget _buildLastRow(dynamic controller, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildKeypadButton(
          icon: Icons.backspace_outlined,
          onPressed: () => controller.backspace(),
          isDarkMode: isDarkMode,
        ),
        _buildKeypadButton(
          text: '0',
          onPressed: () => controller.addInput('0'),
          isDarkMode: isDarkMode,
        ),
        _buildKeypadButton(
          icon: Icons.clear,
          onPressed: () => controller.clearInput(),
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildKeypadButton({
    String? text,
    IconData? icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 70,
          height: 60,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
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
            child: text != null
                ? Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    icon,
                    size: 28,
                  ),
          ),
        ),
      ),
    );
  }
}
