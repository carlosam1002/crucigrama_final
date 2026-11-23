// Copyright 2024 The Flutter Authors. Licencia estilo BSD.

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Reconstruye su contenido en cada frame. Se usa para el reloj del panel
/// de estadísticas.
class TickerBuilder extends StatefulWidget {
  const TickerBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_handleTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _handleTick(Duration elapsed) => setState(() {});

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
