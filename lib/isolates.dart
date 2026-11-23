// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import 'model.dart';
import 'utils.dart';

/// Explora soluciones con una cola de trabajo: en vez de probar ubicaciones
/// al azar, prueba las intersecciones abiertas del crucigrama.
Stream<WorkQueue> exploreCrosswordSolutions({
  required Crossword crossword,
  required BuiltSet<String> wordList,
}) async* {
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: wordList,
    startLocation: Location.at(0, 0),
  );

  while (!workQueue.isCompleted) {
    final location = workQueue.locationsToTry.keys.toBuiltSet().randomElement();
    final direction = workQueue.locationsToTry[location]!;

    try {
      final (wordLocation, wordDirection, word) = await compute(
        _generateCandidate,
        (workQueue.crossword, workQueue.candidateWords, location, direction),
      );

      final candidate = word == null
          ? null
          : workQueue.crossword.addWord(
              location: wordLocation,
              word: word,
              direction: wordDirection,
            );

      workQueue = candidate == null
          ? workQueue.remove(location)
          : workQueue.updateFrom(candidate);
      yield workQueue;
    } catch (e) {
      debugPrint('Error ejecutando el isolate: $e');
      workQueue = workQueue.remove(location);
    }
  }
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
