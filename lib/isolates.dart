// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import 'model.dart';
import 'utils.dart';

/// Explora soluciones del crucigrama en segundo plano y emite cada
/// estado intermedio de la cola de trabajo.
Stream<WorkQueue> exploreCrosswordSolutions({
  required Crossword crossword,
  required BuiltSet<String> wordList,
  required int maxWorkerCount,
}) async* {
  final start = DateTime.now();
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: wordList,
    startLocation: Location.at(0, 0),
  );
  while (!workQueue.isCompleted) {
    try {
      workQueue = await compute(_generate, (workQueue, maxWorkerCount));
      yield workQueue;
    } catch (e) {
      debugPrint('Error ejecutando el isolate: $e');
    }
  }

  debugPrint(
    'Crucigrama de ${workQueue.crossword.width} x '
    '${workQueue.crossword.height} generado en '
    '${DateTime.now().difference(start).formatted} '
    'con $maxWorkerCount workers.',
  );
}

/// Un paso de la búsqueda: lanza hasta [maxWorkerCount] isolates en paralelo,
/// cada uno probando una ubicación distinta.
Future<WorkQueue> _generate((WorkQueue, int) workMessage) async {
  var (workQueue, maxWorkerCount) = workMessage;
  final candidateGeneratorFutures = <Future<(Location, Direction, String?)>>[];
  final locations = workQueue.locationsToTry.keys.toBuiltList().rebuild(
    (b) => b
      ..shuffle()
      ..take(maxWorkerCount),
  );

  for (final location in locations) {
    final direction = workQueue.locationsToTry[location]!;
    candidateGeneratorFutures.add(
      compute(_generateCandidate, (
        workQueue.crossword,
        workQueue.candidateWords,
        location,
        direction,
      )),
    );
  }

  try {
    final results = await candidateGeneratorFutures.wait;
    var crossword = workQueue.crossword;
    for (final (location, direction, word) in results) {
      if (word != null) {
        final candidate = crossword.addWord(
          location: location,
          word: word,
          direction: direction,
        );
        if (candidate != null) {
          crossword = candidate;
        }
      } else {
        workQueue = workQueue.remove(location);
      }
    }
    workQueue = workQueue.updateFrom(crossword);
  } catch (e) {
    debugPrint('$e');
  }

  return workQueue;
}

/// Busca una palabra que encaje en [location] en la dirección indicada.
/// Devuelve `null` como palabra si no encuentra ninguna a tiempo.
(Location, Direction, String?) _generateCandidate(
  (Crossword, BuiltSet<String>, Location, Direction) searchDetailMessage,
) {
  final (crossword, candidateWords, location, direction) = searchDetailMessage;

  final target = crossword.characters[location];
  if (target == null) {
    return (location, direction, candidateWords.randomElement());
  }

  // Solo palabras que contienen la letra de esta casilla.
  final words = candidateWords.toBuiltList().rebuild(
    (b) => b
      ..where((b) => b.characters.contains(target.character))
      ..shuffle(),
  );

  int tryCount = 0;
  final start = DateTime.now();
  for (final word in words) {
    tryCount++;
    for (final (index, character) in word.characters.indexed) {
      if (character != target.character) continue;

      final wordLocation = switch (direction) {
        Direction.across => location.leftOffset(index),
        Direction.down => location.upOffset(index),
      };

      final candidate = crossword.addWord(
        location: wordLocation,
        word: word,
        direction: direction,
      );
      if (candidate != null) {
        return (wordLocation, direction, word);
      }

      final deltaTime = DateTime.now().difference(start);
      if (tryCount >= 1000 || deltaTime > const Duration(seconds: 10)) {
        return (location, direction, null);
      }
    }
  }

  return (location, direction, null);
}
