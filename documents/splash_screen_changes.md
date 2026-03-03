# Resumen de Cambios — Splash Screen

## Fecha: 2026-02-27

## Descripción
Se implementó un splash screen profesional de dos capas: splash nativo (Android/iOS) + splash animado (widget Flutter).

## Archivos Modificados
- `pubspec.yaml` — Agregada dependencia `flutter_native_splash: ^2.4.3`
- `lib/main.dart` — Ruta inicial cambiada a `/splash`, ruta `/` para `AuthPage`

## Archivos Nuevos
- `flutter_native_splash.yaml` — Config del splash nativo (fondo negro, logo centrado)
- `lib/features/splash/presentation/pages/splash_page.dart` — Widget animado

## Archivos Generados Automáticamente (por flutter_native_splash)
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/drawable-v21/launch_background.xml`
- `android/app/src/main/res/values-v31/styles.xml`
- `android/app/src/main/res/values-night-v31/styles.xml`
- Imágenes de splash en `android/app/src/main/res/drawable-*/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard` (actualizado)

## Verificación
- `flutter analyze` — Sin errores nuevos
- `flutter test` — 1527 tests pasaron
