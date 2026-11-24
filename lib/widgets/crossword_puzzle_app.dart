// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../providers.dart';
import 'crossword_generator_widget.dart';
import 'crossword_puzzle_widget.dart';
import 'puzzle_completed_widget.dart';

class CrosswordPuzzleApp extends StatelessWidget {
  const CrosswordPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          actions: const [_CrosswordPuzzleAppMenu()],
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          title: const Text('Crossword Puzzle'),
        ),
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final workQueueAsync = ref.watch(workQueueProvider);
              final puzzleSolved = ref.watch(
                puzzleProvider.select((puzzle) => puzzle.solved),
              );

              return workQueueAsync.when(
                data: (workQueue) {
                  if (puzzleSolved) {
                    return const PuzzleCompletedWidget();
                  }
                  if (workQueue.isCompleted &&
                      workQueue.crossword.characters.isNotEmpty) {
                    return const CrosswordPuzzleWidget();
                  }
                  return const CrosswordGeneratorWidget();
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('$error')),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Empieza a cargar la lista de palabras apenas abre la app.
class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}

/// Menú de configuración: tamaño, cantidad de workers y estadísticas.
class _CrosswordPuzzleAppMenu extends ConsumerWidget {
  const _CrosswordPuzzleAppMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MenuAnchor(
    menuChildren: [
      for (final entry in CrosswordSize.values)
        MenuItemButton(
          onPressed: () => ref.read(sizeProvider.notifier).setSize(entry),
          leadingIcon: entry == ref.watch(sizeProvider)
              ? const Icon(Icons.radio_button_checked_outlined)
              : const Icon(Icons.radio_button_unchecked_outlined),
          child: Text(entry.label),
        ),
      SubmenuButton(
        menuChildren: [
          for (final count in BackgroundWorkers.values)
            MenuItemButton(
              onPressed: () =>
                  ref.read(workerCountProvider.notifier).setCount(count),
              leadingIcon: count == ref.watch(workerCountProvider)
                  ? const Icon(Icons.radio_button_checked_outlined)
                  : const Icon(Icons.radio_button_unchecked_outlined),
              child: Text(count.label),
            ),
        ],
        child: const Text('Workers en segundo plano'),
      ),
      MenuItemButton(
        onPressed: () => ref.read(showDisplayInfoProvider.notifier).toggle(),
        leadingIcon: ref.watch(showDisplayInfoProvider)
            ? const Icon(Icons.check_box_outlined)
            : const Icon(Icons.check_box_outline_blank_outlined),
        child: const Text('Mostrar estadísticas'),
      ),
    ],
    builder: (context, controller, child) => IconButton(
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
      icon: const Icon(Icons.settings),
    ),
  );
}
