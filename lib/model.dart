// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

part 'model.g.dart';

/// Una ubicación (x, y) dentro del crucigrama, base 0.
abstract class Location implements Built<Location, LocationBuilder> {
  static Serializer<Location> get serializer => _$locationSerializer;

  int get x;
  int get y;

  Location get left => rebuild((b) => b.x = x - 1);
  Location get right => rebuild((b) => b.x = x + 1);
  Location get up => rebuild((b) => b.y = y - 1);
  Location get down => rebuild((b) => b.y = y + 1);

  Location leftOffset(int offset) => rebuild((b) => b.x = x - offset);
  Location rightOffset(int offset) => rebuild((b) => b.x = x + offset);
  Location upOffset(int offset) => rebuild((b) => b.y = y - offset);
  Location downOffset(int offset) => rebuild((b) => b.y = y + offset);

  String prettyPrint() => '($x,$y)';

  factory Location([void Function(LocationBuilder)? updates]) = _$Location;
  Location._();

  factory Location.at(int x, int y) => Location(
    (b) => b
      ..x = x
      ..y = y,
  );
}

/// Dirección de una palabra: horizontal (across) o vertical (down).
enum Direction {
  across,
  down;

  @override
  String toString() => name;
}

/// Una palabra ubicada en el crucigrama.
abstract class CrosswordWord
    implements Built<CrosswordWord, CrosswordWordBuilder> {
  static Serializer<CrosswordWord> get serializer => _$crosswordWordSerializer;

  String get word;
  Location get location;
  Direction get direction;

  /// Compara por columna y luego por fila.
  static int locationComparator(CrosswordWord a, CrosswordWord b) {
    final compareRows = a.location.y.compareTo(b.location.y);
    final compareColumns = a.location.x.compareTo(b.location.x);
    return switch (compareColumns) {
      0 => compareRows,
      _ => compareColumns,
    };
  }

  factory CrosswordWord.word({
    required String word,
    required Location location,
    required Direction direction,
  }) {
    return CrosswordWord(
      (b) => b
        ..word = word
        ..direction = direction
        ..location.replace(location),
    );
  }

  factory CrosswordWord([void Function(CrosswordWordBuilder)? updates]) =
      _$CrosswordWord;
  CrosswordWord._();
}

/// Una letra del crucigrama. Pertenece a una palabra horizontal, a una
/// vertical o a ambas.
abstract class CrosswordCharacter
    implements Built<CrosswordCharacter, CrosswordCharacterBuilder> {
  static Serializer<CrosswordCharacter> get serializer =>
      _$crosswordCharacterSerializer;

  String get character;
  CrosswordWord? get acrossWord;
  CrosswordWord? get downWord;

  factory CrosswordCharacter.character({
    required String character,
    CrosswordWord? acrossWord,
    CrosswordWord? downWord,
  }) {
    return CrosswordCharacter((b) {
      b.character = character;
      if (acrossWord != null) {
        b.acrossWord.replace(acrossWord);
      }
      if (downWord != null) {
        b.downWord.replace(downWord);
      }
    });
  }

  factory CrosswordCharacter([
    void Function(CrosswordCharacterBuilder)? updates,
  ]) = _$CrosswordCharacter;
  CrosswordCharacter._();
}

/// El crucigrama: una grilla con palabras colocadas siguiendo las reglas del
/// crucigrama tradicional en inglés.
abstract class Crossword implements Built<Crossword, CrosswordBuilder> {
  static Serializer<Crossword> get serializer => _$crosswordSerializer;

  int get width;
  int get height;
  BuiltList<CrosswordWord> get words;

  /// Letras por ubicación (se calcula automáticamente a partir de [words]).
  BuiltMap<Location, CrosswordCharacter> get characters;

  /// Verifica que el crucigrama cumpla todas las restricciones.
  bool get valid {
    // Sin palabras repetidas.
    final wordSet = words.map((word) => word.word).toBuiltSet();
    if (wordSet.length != words.length) {
      return false;
    }

    for (final MapEntry(key: location, value: character)
        in characters.entries) {
      // Toda letra debe pertenecer a alguna palabra.
      if (character.acrossWord == null && character.downWord == null) {
        return false;
      }

      // Toda letra debe estar dentro de la grilla.
      if (location.x < 0 ||
          location.y < 0 ||
          location.x >= width ||
          location.y >= height) {
        return false;
      }

      // Letras arriba y abajo deben estar unidas por la misma palabra vertical.
      if (characters[location.up] case final up?) {
        if (character.downWord == null) return false;
        if (up.downWord != character.downWord) return false;
      }
      if (characters[location.down] case final down?) {
        if (character.downWord == null) return false;
        if (down.downWord != character.downWord) return false;
      }

      // Letras a izquierda y derecha deben estar unidas por la misma
      // palabra horizontal.
      if (characters[location.left] case final left?) {
        if (character.acrossWord == null) return false;
        if (left.acrossWord != character.acrossWord) return false;
      }
      if (characters[location.right] case final right?) {
        if (character.acrossWord == null) return false;
        if (right.acrossWord != character.acrossWord) return false;
      }
    }

    return true;
  }

  /// Intenta agregar una palabra. Devuelve el nuevo crucigrama o `null` si
  /// la palabra no se puede colocar.
  Crossword? addWord({
    required Location location,
    required String word,
    required Direction direction,
    bool requireOverlap = true,
  }) {
    if (words.map((crosswordWord) => crosswordWord.word).contains(word)) {
      return null;
    }

    final wordCharacters = word.characters;
    bool overlap = false;

    for (final (index, character) in wordCharacters.indexed) {
      final characterLocation = switch (direction) {
        Direction.across => location.rightOffset(index),
        Direction.down => location.downOffset(index),
      };

      final target = characters[characterLocation];
      if (target != null) {
        overlap = true;
        if (target.character != character) {
          return null;
        }
        if (direction == Direction.across && target.acrossWord != null ||
            direction == Direction.down && target.downWord != null) {
          return null;
        }
      }
    }

    // Exigir cruce con otra palabra (salvo que la grilla esté vacía).
    if (words.isNotEmpty && !overlap && requireOverlap) {
      return null;
    }

    final candidate = rebuild(
      (b) => b
        ..words.add(
          CrosswordWord.word(
            word: word,
            direction: direction,
            location: location,
          ),
        ),
    );

    return candidate.valid ? candidate : null;
  }

  /// Hook de built_value: completa el mapa [characters] después de cada build.
  @BuiltValueHook(finalizeBuilder: true)
  static void _fillCharacters(CrosswordBuilder b) {
    b.characters.clear();

    for (final word in b.words.build()) {
      for (final (idx, character) in word.word.characters.indexed) {
        switch (word.direction) {
          case Direction.across:
            b.characters.updateValue(
              word.location.rightOffset(idx),
              (b) => b.rebuild((bInner) => bInner.acrossWord.replace(word)),
              ifAbsent: () => CrosswordCharacter.character(
                acrossWord: word,
                character: character,
              ),
            );
          case Direction.down:
            b.characters.updateValue(
              word.location.downOffset(idx),
              (b) => b.rebuild((bInner) => bInner.downWord.replace(word)),
              ifAbsent: () => CrosswordCharacter.character(
                downWord: word,
                character: character,
              ),
            );
        }
      }
    }
  }

  /// Representación en texto (útil para depurar).
  String prettyPrintCrossword() {
    final buffer = StringBuffer();
    final grid = List.generate(height, (_) => List.generate(width, (_) => '░'));

    for (final MapEntry(key: Location(:x, :y), value: character)
        in characters.entries) {
      grid[y][x] = character.character;
    }
    for (final row in grid) {
      buffer.writeln(row.join());
    }

    buffer
      ..writeln()
      ..writeln('Across:');
    for (final word
        in words.where((w) => w.direction == Direction.across).toList()
          ..sort(CrosswordWord.locationComparator)) {
      buffer.writeln('${word.location.prettyPrint()}: ${word.word}');
    }

    buffer
      ..writeln()
      ..writeln('Down:');
    for (final word
        in words.where((w) => w.direction == Direction.down).toList()
          ..sort(CrosswordWord.locationComparator)) {
      buffer.writeln('${word.location.prettyPrint()}: ${word.word}');
    }

    return buffer.toString();
  }

  factory Crossword.crossword({
    required int width,
    required int height,
    Iterable<CrosswordWord>? words,
  }) {
    return Crossword((b) {
      b
        ..width = width
        ..height = height;
      if (words != null) {
        b.words.addAll(words);
      }
    });
  }

  factory Crossword([void Function(CrosswordBuilder)? updates]) = _$Crossword;
  Crossword._();
}

/// Cola de trabajo: el crucigrama actual, las ubicaciones por probar, las
/// ubicaciones descartadas y las palabras candidatas que quedan.
abstract class WorkQueue implements Built<WorkQueue, WorkQueueBuilder> {
  static Serializer<WorkQueue> get serializer => _$workQueueSerializer;

  Crossword get crossword;
  BuiltMap<Location, Direction> get locationsToTry;
  BuiltSet<Location> get badLocations;
  BuiltSet<String> get candidateWords;

  bool get isCompleted => locationsToTry.isEmpty || candidateWords.isEmpty;

  static WorkQueue from({
    required Crossword crossword,
    required Iterable<String> candidateWords,
    required Location startLocation,
  }) => WorkQueue((b) {
    if (crossword.words.isEmpty) {
      // Descartar palabras más largas que el ancho de la grilla.
      b.candidateWords.addAll(
        candidateWords.where(
          (word) => word.characters.length <= crossword.width,
        ),
      );
      b.crossword.replace(crossword);
      b.locationsToTry.addAll({startLocation: Direction.across});
    } else {
      b.candidateWords.addAll(
        candidateWords.toBuiltSet().rebuild(
          (b) => b.removeAll(crossword.words.map((word) => word.word)),
        ),
      );
      b.crossword.replace(crossword);

      // Ubicaciones abiertas: letras que todavía pueden recibir una palabra
      // cruzada.
      crossword.characters
          .rebuild(
            (b) => b.removeWhere((location, character) {
              if (character.acrossWord != null && character.downWord != null) {
                return true;
              }
              final left = crossword.characters[location.left];
              if (left != null && left.downWord != null) return true;
              final right = crossword.characters[location.right];
              if (right != null && right.downWord != null) return true;
              final up = crossword.characters[location.up];
              if (up != null && up.acrossWord != null) return true;
              final down = crossword.characters[location.down];
              if (down != null && down.acrossWord != null) return true;
              return false;
            }),
          )
          .forEach((location, character) {
            b.locationsToTry.addAll({
              location: switch ((character.acrossWord, character.downWord)) {
                (null, null) => throw StateError(
                  'La letra no pertenece a ninguna palabra',
                ),
                (null, _) => Direction.across,
                (_, null) => Direction.down,
                (_, _) => throw StateError(
                  'La letra pertenece a dos palabras',
                ),
              },
            });
          });
    }
  });

  WorkQueue remove(Location location) => rebuild(
    (b) => b
      ..locationsToTry.remove(location)
      ..badLocations.add(location),
  );

  WorkQueue updateFrom(Crossword crossword) =>
      WorkQueue.from(
        crossword: crossword,
        candidateWords: candidateWords,
        startLocation: locationsToTry.isNotEmpty
            ? locationsToTry.keys.first
            : Location.at(0, 0),
      ).rebuild(
        (b) => b
          ..badLocations.addAll(badLocations)
          ..locationsToTry.removeWhere(
            (location, _) => badLocations.contains(location),
          ),
      );

  factory WorkQueue([void Function(WorkQueueBuilder)? updates]) = _$WorkQueue;
  WorkQueue._();
}

/// Datos que se muestran en el panel de estadísticas.
abstract class DisplayInfo implements Built<DisplayInfo, DisplayInfoBuilder> {
  static Serializer<DisplayInfo> get serializer => _$displayInfoSerializer;

  String get wordsInGridCount;
  String get candidateWordsCount;
  String get locationsToExploreCount;
  String get knownBadLocationsCount;
  String get gridFilledPercentage;

  factory DisplayInfo.from({required WorkQueue workQueue}) {
    final gridFilled =
        workQueue.crossword.characters.length /
        (workQueue.crossword.width * workQueue.crossword.height);
    final fmt = NumberFormat.decimalPattern();

    return DisplayInfo(
      (b) => b
        ..wordsInGridCount = fmt.format(workQueue.crossword.words.length)
        ..candidateWordsCount = fmt.format(workQueue.candidateWords.length)
        ..locationsToExploreCount = fmt.format(workQueue.locationsToTry.length)
        ..knownBadLocationsCount = fmt.format(workQueue.badLocations.length)
        ..gridFilledPercentage = '${(gridFilled * 100).toStringAsFixed(2)}%',
    );
  }

  static DisplayInfo get empty => DisplayInfo(
    (b) => b
      ..wordsInGridCount = '0'
      ..candidateWordsCount = '0'
      ..locationsToExploreCount = '0'
      ..knownBadLocationsCount = '0'
      ..gridFilledPercentage = '0%',
  );

  factory DisplayInfo([void Function(DisplayInfoBuilder)? updates]) =
      _$DisplayInfo;
  DisplayInfo._();
}

/// El juego: crucigrama oculto, palabras alternativas por pista y las
/// palabras que eligió el jugador.
abstract class CrosswordPuzzleGame
    implements Built<CrosswordPuzzleGame, CrosswordPuzzleGameBuilder> {
  static Serializer<CrosswordPuzzleGame> get serializer =>
      _$crosswordPuzzleGameSerializer;

  Crossword get crossword;
  BuiltMap<Location, BuiltMap<Direction, BuiltList<String>>> get alternateWords;
  BuiltList<CrosswordWord> get selectedWords;

  /// Quita la palabra elegida previamente en la misma posición y dirección.
  CrosswordPuzzleGame _withoutSelectionAt(
    Location location,
    Direction direction,
  ) {
    if (selectedWords.any(
      (w) => w.direction == direction && w.location == location,
    )) {
      return rebuild(
        (b) => b
          ..selectedWords.removeWhere(
            (w) => w.location == location && w.direction == direction,
          ),
      );
    }
    return this;
  }

  bool canSelectWord({
    required Location location,
    required String word,
    required Direction direction,
  }) {
    final crosswordWord = CrosswordWord.word(
      word: word,
      location: location,
      direction: direction,
    );
    if (selectedWords.contains(crosswordWord)) {
      return true;
    }

    final puzzle = _withoutSelectionAt(location, direction);
    return null !=
        puzzle.crosswordFromSelectedWords.addWord(
          location: location,
          word: word,
          direction: direction,
          requireOverlap: false,
        );
  }

  CrosswordPuzzleGame? selectWord({
    required Location location,
    required String word,
    required Direction direction,
  }) {
    final crosswordWord = CrosswordWord.word(
      word: word,
      location: location,
      direction: direction,
    );

    // Tocar una palabra ya elegida la deselecciona.
    if (selectedWords.contains(crosswordWord)) {
      return rebuild((b) => b.selectedWords.remove(crosswordWord));
    }

    final puzzle = _withoutSelectionAt(location, direction);

    // No se exige cruce, así el jugador puede completar en cualquier orden.
    final updated = puzzle.crosswordFromSelectedWords.addWord(
      location: location,
      word: word,
      direction: direction,
      requireOverlap: false,
    );

    if (updated != null &&
        (puzzle.crossword.words.contains(crosswordWord) ||
            puzzle.alternateWords[location]?[direction]?.contains(word) ==
                true)) {
      return puzzle.rebuild((b) => b..selectedWords.add(crosswordWord));
    }
    return null;
  }

  Crossword get crosswordFromSelectedWords => Crossword.crossword(
    width: crossword.width,
    height: crossword.height,
    words: selectedWords,
  );

  /// Resuelto: grilla válida y misma cantidad de palabras que la solución
  /// (admite soluciones alternativas).
  bool get solved =>
      crosswordFromSelectedWords.valid &&
      crosswordFromSelectedWords.words.length == crossword.words.length &&
      crossword.words.isNotEmpty;

  factory CrosswordPuzzleGame.from({
    required Crossword crossword,
    required BuiltSet<String> candidateWords,
  }) {
    candidateWords = candidateWords.rebuild(
      (b) => b.removeAll(crossword.words.map((w) => w.word)),
    );

    var alternates =
        BuiltMap<Location, BuiltMap<Direction, BuiltList<String>>>();

    // Hasta 4 palabras alternativas del mismo largo para cada pista.
    for (final crosswordWord in crossword.words) {
      final alternateWords = candidateWords.toBuiltList().rebuild(
        (b) => b
          ..where((w) => w.length == crosswordWord.word.length)
          ..shuffle()
          ..take(4)
          ..sort(),
      );

      candidateWords = candidateWords.rebuild(
        (b) => b.removeAll(alternateWords),
      );

      alternates = alternates.rebuild(
        (b) => b.updateValue(
          crosswordWord.location,
          (m) => m.rebuild(
            (mb) => mb[crosswordWord.direction] = alternateWords,
          ),
          ifAbsent: () => {crosswordWord.direction: alternateWords}.build(),
        ),
      );
    }

    return CrosswordPuzzleGame(
      (b) => b
        ..crossword.replace(crossword)
        ..alternateWords.replace(alternates),
    );
  }

  factory CrosswordPuzzleGame([
    void Function(CrosswordPuzzleGameBuilder)? updates,
  ]) = _$CrosswordPuzzleGame;
  CrosswordPuzzleGame._();
}

@SerializersFor([
  Location,
  Crossword,
  CrosswordWord,
  CrosswordCharacter,
  WorkQueue,
  DisplayInfo,
  CrosswordPuzzleGame,
])
final Serializers serializers = _$serializers;
