// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:characters/characters.dart';

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

  /// Agrega una palabra sin verificar ninguna regla (todavía).
  Crossword addWord({
    required Location location,
    required String word,
    required Direction direction,
  }) {
    return rebuild(
      (b) => b
        ..words.add(
          CrosswordWord.word(
            word: word,
            direction: direction,
            location: location,
          ),
        ),
    );
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

@SerializersFor([
  Location,
  Crossword,
  CrosswordWord,
  CrosswordCharacter,
])
final Serializers serializers = _$serializers;
