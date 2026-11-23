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

/// Agrega palabras al azar en ubicaciones al azar, sin respetar todavía
/// las reglas del crucigrama.

@ProviderFor(crossword)
const crosswordProvider = CrosswordProvider._();

/// Agrega palabras al azar en ubicaciones al azar, sin respetar todavía
/// las reglas del crucigrama.

final class CrosswordProvider
    extends
        $FunctionalProvider<
          AsyncValue<model.Crossword>,
          model.Crossword,
          Stream<model.Crossword>
        >
    with $FutureModifier<model.Crossword>, $StreamProvider<model.Crossword> {
  /// Agrega palabras al azar en ubicaciones al azar, sin respetar todavía
  /// las reglas del crucigrama.
  const CrosswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crosswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crosswordHash();

  @$internal
  @override
  $StreamProviderElement<model.Crossword> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<model.Crossword> create(Ref ref) {
    return crossword(ref);
  }
}

String _$crosswordHash() => r'56e9fa797923bbce2879ea0045675c5f3f67dea4';
