// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../providers.dart';
import 'crossword_info_widget.dart';
import 'crossword_widget.dart';

class CrosswordGeneratorApp extends StatelessWidget {
  const CrosswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          actions: const [_CrosswordGeneratorMenu()],
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          title: const Text('Crossword Generator'),
        ),
        body: SafeArea(
          child: Stack(
          children: const [
            Positioned.fill(child: CrosswordWidget()),
            CrosswordInfoWidget(),
          ],
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

class _CrosswordGeneratorMenu extends ConsumerWidget {
  const _CrosswordGeneratorMenu();

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
