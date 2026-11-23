// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'dart:math';

import 'package:built_collection/built_collection.dart';

final _random = Random();

/// Devuelve un elemento aleatorio de un [BuiltSet].
extension RandomElements<E> on BuiltSet<E> {
  E randomElement() => elementAt(_random.nextInt(length));
}
