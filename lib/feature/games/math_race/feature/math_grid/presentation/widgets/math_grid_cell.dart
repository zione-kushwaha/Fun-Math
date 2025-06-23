import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/domain/model/math_grid.dart';
import 'package:fun_math/feature/games/math_race/feature/math_grid/presentation/provider/math_grid_providers.dart';

class MathGridCell extends ConsumerWidget {
  final MathGridCellModel cell;
  final int index;
  final Color primaryColor;

  const MathGridCell({
    Key? key,
    required this.cell,
    required this.index,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 0.5),
        color: _getCellColor(context),
      ),
      child: Visibility(
        visible: !cell.isRemoved,
        child: InkWell(
          onTap: () => ref.read(mathGridControllerProvider.notifier).toggleCell(index),
          child: Center(
            child: Text(
              cell.value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: cell.isActive ? primaryColor : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getCellColor(BuildContext context) {
    if (cell.isRemoved) {
      return Theme.of(context).scaffoldBackgroundColor;
    }
    return cell.isActive 
        ? Colors.white
        : Colors.transparent;
  }
}
