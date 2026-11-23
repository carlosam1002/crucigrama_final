// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../model.dart';
import '../providers.dart';

/// Muestra la grilla del crucigrama con un TableView de dos dimensiones.
class CrosswordWidget extends ConsumerWidget {
  const CrosswordWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(sizeProvider);
    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: _buildCell,
      columnCount: size.width,
      columnBuilder: (index) => _buildSpan(context, index),
      rowCount: size.height,
      rowBuilder: (index) => _buildSpan(context, index),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final location = Location.at(vicinity.column, vicinity.row);

    return TableViewCell(
      child: Consumer(
        builder: (context, ref, _) {
          final character = ref.watch(
            crosswordProvider.select(
              (crossword) => crossword.value?.characters[location],
            ),
          );
          const explorationCell = false;
          final colors = Theme.of(context).colorScheme;

          if (character != null) {
            return AnimatedContainer(
              duration: Durations.extralong1,
              curve: Curves.easeInOut,
              color: explorationCell ? colors.primary : colors.onPrimary,
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: Durations.extralong1,
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 24,
                    color: explorationCell ? colors.onPrimary : colors.primary,
                  ),
                  child: Text(character.character),
                ),
              ),
            );
          }

          return ColoredBox(color: colors.primaryContainer);
        },
      ),
    );
  }

  TableSpan _buildSpan(BuildContext context, int index) {
    final borderColor = Theme.of(context).colorScheme.onPrimaryContainer;
    return TableSpan(
      extent: const FixedTableSpanExtent(32),
      foregroundDecoration: TableSpanDecoration(
        border: TableSpanBorder(
          leading: BorderSide(color: borderColor),
          trailing: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
