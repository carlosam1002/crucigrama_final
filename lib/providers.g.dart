// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Carga la lista de palabras desde assets/words.txt.
/// Solo se quedan palabras en minúscula a-z de más de 2 letras.

@ProviderFor(wordList)
const wordListProvider = WordListProvider._();

/// Carga la lista de palabras desde assets/words.txt.
/// Solo se quedan palabras en minúscula a-z de más de 2 letras.

final class WordListProvider
    extends
        $FunctionalProvider<
          AsyncValue<BuiltSet<String>>,
          BuiltSet<String>,
          FutureOr<BuiltSet<String>>
        >
    with $FutureModifier<BuiltSet<String>>, $FutureProvider<BuiltSet<String>> {
  /// Carga la lista de palabras desde assets/words.txt.
  /// Solo se quedan palabras en minúscula a-z de más de 2 letras.
  const WordListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordListHash();

  @$internal
  @override
  $FutureProviderElement<BuiltSet<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BuiltSet<String>> create(Ref ref) {
    return wordList(ref);
  }
}

String _$wordListHash() => r'07003444d7241448561b638500001e31610b4717';

/// Tamaño elegido en el menú de configuración.

@ProviderFor(Size)
const sizeProvider = SizeProvider._();

/// Tamaño elegido en el menú de configuración.
final class SizeProvider extends $NotifierProvider<Size, CrosswordSize> {
  /// Tamaño elegido en el menú de configuración.
  const SizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sizeHash();

  @$internal
  @override
  Size create() => Size();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrosswordSize value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrosswordSize>(value),
    );
  }
}

String _$sizeHash() => r'eb133b42965790fb371fcf8cd0f69b29b5199947';

/// Tamaño elegido en el menú de configuración.

abstract class _$Size extends $Notifier<CrosswordSize> {
  CrosswordSize build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CrosswordSize, CrosswordSize>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CrosswordSize, CrosswordSize>,
              CrosswordSize,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WorkerCount)
const workerCountProvider = WorkerCountProvider._();

final class WorkerCountProvider
    extends $NotifierProvider<WorkerCount, BackgroundWorkers> {
  const WorkerCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workerCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workerCountHash();

  @$internal
  @override
  WorkerCount create() => WorkerCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackgroundWorkers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackgroundWorkers>(value),
    );
  }
}

String _$workerCountHash() => r'2ad37f8d0910bc9feecb657f3b6286d4ab34ed99';

abstract class _$WorkerCount extends $Notifier<BackgroundWorkers> {
  BackgroundWorkers build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BackgroundWorkers, BackgroundWorkers>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BackgroundWorkers, BackgroundWorkers>,
              BackgroundWorkers,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Momento en que empezó la generación.

@ProviderFor(StartTime)
const startTimeProvider = StartTimeProvider._();

/// Momento en que empezó la generación.
final class StartTimeProvider extends $NotifierProvider<StartTime, DateTime?> {
  /// Momento en que empezó la generación.
  const StartTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startTimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startTimeHash();

  @$internal
  @override
  StartTime create() => StartTime();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$startTimeHash() => r'aced96ef5d2ace2a4e9bee398a0165f3fef010d2';

/// Momento en que empezó la generación.

abstract class _$StartTime extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Momento en que terminó la generación (null mientras sigue).

@ProviderFor(EndTime)
const endTimeProvider = EndTimeProvider._();

/// Momento en que terminó la generación (null mientras sigue).
final class EndTimeProvider extends $NotifierProvider<EndTime, DateTime?> {
  /// Momento en que terminó la generación (null mientras sigue).
  const EndTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endTimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endTimeHash();

  @$internal
  @override
  EndTime create() => EndTime();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$endTimeHash() => r'6c3f78f03f2b97d96ba7068c497afb0158b11543';

/// Momento en que terminó la generación (null mientras sigue).

abstract class _$EndTime extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Mostrar u ocultar el panel de estadísticas.

@ProviderFor(ShowDisplayInfo)
const showDisplayInfoProvider = ShowDisplayInfoProvider._();

/// Mostrar u ocultar el panel de estadísticas.
final class ShowDisplayInfoProvider
    extends $NotifierProvider<ShowDisplayInfo, bool> {
  /// Mostrar u ocultar el panel de estadísticas.
  const ShowDisplayInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showDisplayInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showDisplayInfoHash();

  @$internal
  @override
  ShowDisplayInfo create() => ShowDisplayInfo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showDisplayInfoHash() => r'b2431424d49a736527acd8bbffc93d2abf4935a2';

/// Mostrar u ocultar el panel de estadísticas.

abstract class _$ShowDisplayInfo extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Genera el crucigrama en segundo plano y emite cada paso de la búsqueda.

@ProviderFor(workQueue)
const workQueueProvider = WorkQueueProvider._();

/// Genera el crucigrama en segundo plano y emite cada paso de la búsqueda.

final class WorkQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<model.WorkQueue>,
          model.WorkQueue,
          Stream<model.WorkQueue>
        >
    with $FutureModifier<model.WorkQueue>, $StreamProvider<model.WorkQueue> {
  /// Genera el crucigrama en segundo plano y emite cada paso de la búsqueda.
  const WorkQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workQueueHash();

  @$internal
  @override
  $StreamProviderElement<model.WorkQueue> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<model.WorkQueue> create(Ref ref) {
    return workQueue(ref);
  }
}

String _$workQueueHash() => r'53683a86a88a5a890a1461654c2b0e8bec3ae6c8';

/// Estado del juego. Cuando termina la generación, arma el acertijo en un
/// isolate aparte.

@ProviderFor(Puzzle)
const puzzleProvider = PuzzleProvider._();

/// Estado del juego. Cuando termina la generación, arma el acertijo en un
/// isolate aparte.
final class PuzzleProvider
    extends $NotifierProvider<Puzzle, model.CrosswordPuzzleGame> {
  /// Estado del juego. Cuando termina la generación, arma el acertijo en un
  /// isolate aparte.
  const PuzzleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'puzzleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$puzzleHash();

  @$internal
  @override
  Puzzle create() => Puzzle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(model.CrosswordPuzzleGame value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<model.CrosswordPuzzleGame>(value),
    );
  }
}

String _$puzzleHash() => r'42944d3da64386bba004d1478d68b1b0fac2049d';

/// Estado del juego. Cuando termina la generación, arma el acertijo en un
/// isolate aparte.

abstract class _$Puzzle extends $Notifier<model.CrosswordPuzzleGame> {
  model.CrosswordPuzzleGame build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<model.CrosswordPuzzleGame, model.CrosswordPuzzleGame>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<model.CrosswordPuzzleGame, model.CrosswordPuzzleGame>,
              model.CrosswordPuzzleGame,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
