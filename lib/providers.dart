// Basado en el codelab "Crea un acertijo de palabras con Flutter".
// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'isolates.dart';
import 'model.dart' as model;

part 'providers.g.dart';

/// Carga la lista de palabras desde assets/words.txt.
/// Solo se quedan palabras en minúscula a-z de más de 2 letras.
@riverpod
Future<BuiltSet<String>> wordList(Ref ref) async {
  final re = RegExp(r'^[a-z]+$');
  final words = await rootBundle.loadString('assets/words.txt');
  return const LineSplitter()
      .convert(words)
      .toBuiltSet()
      .rebuild(
        (b) => b
          ..map((word) => word.toLowerCase().trim())
          ..where((word) => word.length > 2)
          ..where((word) => re.hasMatch(word)),
      );
}

/// Tamaños de crucigrama disponibles.
enum CrosswordSize {
  small(width: 20, height: 11),
  medium(width: 40, height: 22),
  large(width: 80, height: 44),
  xlarge(width: 160, height: 88),
  xxlarge(width: 500, height: 500);

  const CrosswordSize({required this.width, required this.height});

  final int width;
  final int height;
  String get label => '$width x $height';
}

/// Tamaño elegido en el menú de configuración.
@Riverpod(keepAlive: true)
class Size extends _$Size {
  @override
  CrosswordSize build() => CrosswordSize.medium;

  void setSize(CrosswordSize size) => state = size;
}

/// Cantidad de isolates trabajando en paralelo.
enum BackgroundWorkers {
  one(1),
  two(2),
  four(4),
  eight(8),
  sixteen(16),
  thirtyTwo(32),
  sixtyFour(64),
  oneTwentyEight(128);

  const BackgroundWorkers(this.count);

  final int count;
  String get label => count.toString();
}

@Riverpod(keepAlive: true)
class WorkerCount extends _$WorkerCount {
  @override
  BackgroundWorkers build() => BackgroundWorkers.four;

  void setCount(BackgroundWorkers count) => state = count;
}

/// Momento en que empezó la generación.
@Riverpod(keepAlive: true)
class StartTime extends _$StartTime {
  @override
  DateTime? build() => null;

  void start() => state = DateTime.now();
}

/// Momento en que terminó la generación (null mientras sigue).
@Riverpod(keepAlive: true)
class EndTime extends _$EndTime {
  @override
  DateTime? build() => null;

  void clear() => state = null;
  void end() => state = DateTime.now();
}

/// Mostrar u ocultar el panel de estadísticas.
@Riverpod(keepAlive: true)
class ShowDisplayInfo extends _$ShowDisplayInfo {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

/// Genera el crucigrama en segundo plano y emite cada paso de la búsqueda.
@riverpod
Stream<model.WorkQueue> workQueue(Ref ref) async* {
  final workers = ref.watch(workerCountProvider);
  final size = ref.watch(sizeProvider);
  final wordListAsync = ref.watch(wordListProvider);

  final emptyCrossword = model.Crossword.crossword(
    width: size.width,
    height: size.height,
  );
  final emptyWorkQueue = model.WorkQueue.from(
    crossword: emptyCrossword,
    candidateWords: BuiltSet<String>(),
    startLocation: model.Location.at(0, 0),
  );

  // Esperar un microtask para no modificar otros providers durante el build.
  await Future<void>.value();
  if (!ref.mounted) return;

  ref.read(startTimeProvider.notifier).start();
  ref.read(endTimeProvider.notifier).clear();

  yield* wordListAsync.when(
    data: (wordList) => exploreCrosswordSolutions(
      crossword: emptyCrossword,
      wordList: wordList,
      maxWorkerCount: workers.count,
    ),
    error: (error, stackTrace) async* {
      debugPrint('Error cargando la lista de palabras: $error');
      yield emptyWorkQueue;
    },
    loading: () async* {
      yield emptyWorkQueue;
    },
  );

  if (ref.mounted && wordListAsync.hasValue) {
    ref.read(endTimeProvider.notifier).end();
  }
}
