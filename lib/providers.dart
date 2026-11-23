// Basado en el codelab "Crea un acertijo de palabras con Flutter".
// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'dart:convert';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'model.dart' as model;
import 'utils.dart';

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

final _random = Random();

/// Agrega palabras al azar en ubicaciones al azar, sin respetar todavía
/// las reglas del crucigrama.
@riverpod
Stream<model.Crossword> crossword(Ref ref) async* {
  final size = ref.watch(sizeProvider);
  final wordListAsync = ref.watch(wordListProvider);

  var current = model.Crossword.crossword(
    width: size.width,
    height: size.height,
  );

  yield* wordListAsync.when(
    data: (wordList) async* {
      while (current.characters.length < size.width * size.height * 0.8) {
        final word = wordList.randomElement();
        final direction = _random.nextBool()
            ? model.Direction.across
            : model.Direction.down;
        final location = model.Location.at(
          _random.nextInt(size.width),
          _random.nextInt(size.height),
        );

        current = current.addWord(
          word: word,
          direction: direction,
          location: location,
        );
        yield current;
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      yield current;
    },
    error: (error, stackTrace) async* {
      debugPrint('Error cargando la lista de palabras: $error');
      yield current;
    },
    loading: () async* {
      yield current;
    },
  );
}
