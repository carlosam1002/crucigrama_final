// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'model.dart';

/// Se ejecuta dentro de un isolate: intenta agregar una palabra y devuelve
/// el crucigrama nuevo, o null si la palabra no cumple las reglas.
Crossword? tryAddWord(
  (Crossword, String, Direction, Location) message,
) {
  final (crossword, word, direction, location) = message;
  return crossword.addWord(
    location: location,
    word: word,
    direction: direction,
  );
}
