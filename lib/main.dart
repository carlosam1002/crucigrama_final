// Basado en el codelab "Crea un acertijo de palabras con Flutter".
// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'providers.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Crossword Builder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        home: Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, ref, _) {
                final wordList = ref.watch(wordListProvider);
                return wordList.when(
                  data: (words) => Text(
                    'Palabras cargadas: ${words.length}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('$error'),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}
