import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/calculator/presentation/provider/calculator_providers.dart';

class CalculatorKeypad extends ConsumerWidget {
  const CalculatorKeypad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(calculatorControllerProvider.notifier);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRow(['1', '2', '3'], controller),
          const SizedBox(height: 16),
          _buildRow(['4', '5', '6'], controller),
          const SizedBox(height: 16),
          _buildRow(['7', '8', '9'], controller),
          const SizedBox(height: 16),
          _buildLastRow(controller),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers, dynamic controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        return _buildKeypadButton(
          text: number,
          onPressed: () => controller.addInput(number),
        );
      }).toList(),
    );
  }

  Widget _buildLastRow(dynamic controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildKeypadButton(
          icon: Icons.backspace_outlined,
          onPressed: () => controller.backspace(),
        ),
        _buildKeypadButton(
          text: '0',
          onPressed: () => controller.addInput('0'),
        ),
        _buildKeypadButton(
          icon: Icons.clear,
          onPressed: () => controller.clearInput(),
        ),
      ],
    );
  }

  Widget _buildKeypadButton({
    String? text,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: text != null
                ? Text(
                    text,
                    style: const TextStyle(
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
