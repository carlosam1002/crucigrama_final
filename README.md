# Crossword Puzzle (codelab "Crea un acertijo de palabras con Flutter")

Versión final del codelab: genera un crucigrama en segundo plano con isolates
y después lo convierte en un juego donde elegís la palabra correcta para cada
casilla entre varias opciones.

## Estructura

```
generate_crossword/
├── assets/words.txt          (lo descargás en el paso 3)
├── analysis_options.yaml
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── model.dart            Modelos built_value (Location, Crossword, WorkQueue, CrosswordPuzzleGame...)
    ├── providers.dart        Providers Riverpod (lista de palabras, tamaño, workers, tiempos, juego)
    ├── isolates.dart         Búsqueda en paralelo con compute()
    ├── utils.dart            Extensiones (elemento aleatorio, formato de duración)
    └── widgets/
        ├── crossword_puzzle_app.dart
        ├── crossword_generator_widget.dart
        ├── crossword_info_widget.dart
        ├── crossword_puzzle_widget.dart
        ├── puzzle_completed_widget.dart
        └── ticker_builder.dart
```

## Cómo ponerlo en marcha

1. Crear el proyecto (esto genera las carpetas android/, ios/, windows/, etc.):

   ```bash
   flutter create generate_crossword --empty
   cd generate_crossword
   ```

2. Copiar encima los archivos de este zip: `pubspec.yaml`,
   `analysis_options.yaml` y toda la carpeta `lib/` (reemplazando lo que haya).

3. Descargar la lista de palabras (SOWPODS) en `assets/words.txt`:

   macOS / Linux:
   ```bash
   mkdir -p assets
   curl -o assets/words.txt https://raw.githubusercontent.com/jesstess/Scrabble/master/scrabble/sowpods.txt
   ```

   Windows (PowerShell):
   ```powershell
   mkdir assets
   Invoke-WebRequest -Uri https://raw.githubusercontent.com/jesstess/Scrabble/master/scrabble/sowpods.txt -OutFile assets/words.txt
   ```

4. Instalar dependencias y generar el código (`model.g.dart` y `providers.g.dart`):

   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

   Mientras desarrollás podés dejar `dart run build_runner watch -d` corriendo.

5. Ejecutar (de preferencia en escritorio, porque la grilla es grande):

   ```bash
   flutter run -d windows   # o macos / linux / chrome / un emulador
   ```

## Uso

- Al abrir, se ve cómo se genera el crucigrama (las casillas resaltadas son
  las que los isolates están explorando) y el panel de estadísticas abajo a la
  derecha.
- Cuando termina, aparece el juego: tocá una casilla y elegí la palabra
  horizontal o vertical. Las opciones que no encajan con lo que ya elegiste
  aparecen deshabilitadas.
- El ícono ⚙️ permite cambiar el tamaño de la grilla, la cantidad de workers
  y mostrar/ocultar las estadísticas.

## Si algo no compila

- **`material_ui` no se encuentra o choca con tu versión de Flutter:** el
  codelab usa el paquete `material_ui` (Material separado del framework). Si tu
  Flutter es más viejo, quitá `material_ui` del `pubspec.yaml` y reemplazá en
  todos los archivos `package:material_ui/material_ui.dart` por
  `package:flutter/material.dart`.
- **Errores con `Ref` o `ref.mounted`:** el código usa Riverpod 3. Verificá que
  `flutter_riverpod`, `riverpod`, `riverpod_annotation` y `riverpod_generator`
  estén todos en 3.x (`flutter pub upgrade --major-versions`).
- **Faltan `_$...`:** volvé a correr `build_runner` (paso 4).
