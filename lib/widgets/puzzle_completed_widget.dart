// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:material_ui/material_ui.dart';

/// Pantalla que aparece cuando el jugador completa el crucigrama.
class PuzzleCompletedWidget extends StatelessWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '¡Crucigrama completado!',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
