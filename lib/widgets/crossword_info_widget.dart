// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model.dart';
import '../providers.dart';
import '../utils.dart';
import 'ticker_builder.dart';

/// Panel flotante (HUD) con las estadísticas de la generación.
class CrosswordInfoWidget extends ConsumerWidget {
  const CrosswordInfoWidget({super.key});

  /// En la práctica la grilla queda llena alrededor de este porcentaje;
  /// se usa para estimar el tiempo restante.
  static const _estimatedTotalCoverage = 0.54;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDisplayInfo = ref.watch(showDisplayInfoProvider);
    if (!showDisplayInfo) {
      return const SizedBox.shrink();
    }

    final size = ref.watch(sizeProvider);
    final workQueue = ref.watch(workQueueProvider).value;
    final displayInfo = workQueue != null
        ? DisplayInfo.from(workQueue: workQueue)
        : DisplayInfo.empty;
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);

    final filled = workQueue == null
        ? 0.0
        : workQueue.crossword.characters.length / (size.width * size.height);

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 32, bottom: 32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(230),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    _row('Palabras en la grilla', displayInfo.wordsInGridCount),
                    _row(
                      'Palabras candidatas',
                      displayInfo.candidateWordsCount,
                    ),
                    _row(
                      'Ubicaciones por explorar',
                      displayInfo.locationsToExploreCount,
                    ),
                    _row(
                      'Ubicaciones descartadas',
                      displayInfo.knownBadLocationsCount,
                    ),
                    _row('Grilla completada', displayInfo.gridFilledPercentage),
                    TableRow(
                      children: [
                        const _Cell('Tiempo transcurrido'),
                        TickerBuilder(
                          builder: (context) => _Cell(
                            startTime == null
                                ? '-'
                                : (endTime ?? DateTime.now())
                                      .difference(startTime)
                                      .formatted,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _Cell('Tiempo restante estimado'),
                        TickerBuilder(
                          builder: (context) => _Cell(
                            _remaining(startTime, endTime, filled),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static TableRow _row(String label, String value) =>
      TableRow(children: [_Cell(label), _Cell(value)]);

  static String _remaining(DateTime? start, DateTime? end, double filled) {
    if (end != null) return '0s';
    if (start == null || filled <= 0) return '-';
    final elapsed = DateTime.now().difference(start);
    final progress = (filled / _estimatedTotalCoverage).clamp(0.0, 1.0);
    if (progress <= 0) return '-';
    final total = elapsed * (1 / progress);
    final remaining = total - elapsed;
    return remaining.isNegative ? '0s' : remaining.formatted;
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    child: Text(text),
  );
}
