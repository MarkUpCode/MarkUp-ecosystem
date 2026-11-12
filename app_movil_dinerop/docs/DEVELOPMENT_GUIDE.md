# Guía de desarrollo

## Requisitos y arranque

El proyecto declara Flutter SDK y Dart `^3.9.2` en `pubspec.yaml`. Dependencias se administran con Flutter/Dart. Desde la raíz de este repositorio:

```powershell
flutter pub get
flutter run --dart-define DINEROP_API_BASE_URL=https://<host-backend>
```

Para escoger el valor de API, `DINEROP_API_BASE_URL` tiene prioridad sobre `DINEROP_HOST_IP`; en ausencia de ambos `ApiConfig` resuelve al host por defecto incluido en fuente. No pongas tokens/contraseñas en argumentos ni en documentación. `DINEROP_HOST_IP` se normaliza como base URL igual que la variable anterior; define un esquema (`http://` o `https://`) al usarla.

## Orientación del código

1. Arranque: `lib/main.dart` → `lib/app/app.dart`.
2. Agregar/entender una página: `lib/features/<feature>/presentation/` y ruta en `lib/app/router/app_router.dart`.
3. Datos remotos: reutilizar `ApiClient`; mantener rutas y parsing en data source/repositorio del feature, modelos en `data/models/`.
4. Composición: providers actuales en `lib/app/providers.dart` o junto al controlador de auth.
5. UI común: revisar `lib/shared/widgets/` y tema antes de replicar controles.
6. Backend: contrastar contrato con `../dinerop-backend/src/main/java/com/markup/dinerop/**` y su `API_DOCUMENTATION.md`; ante discrepancia, dejarla explícita y determinar contrato real con controlador/DTO.

## Convenciones comprobables

- `ApiClient.request<T>` recibe método, autenticación, query, body, parser y response type.
- Las rutas autenticadas usan bearer automático por defecto; las públicas deben optar por `authenticated: false`.
- Los DTO implementan `fromJson` o `toJson`; fechas de persona onboarding se envían como fecha ISO sin tiempo.
- Manejo de errores centralizado en `AppException`/`ApiClient`; UI decide cómo presentar error/reintento.
- Mantener rutas del router y lista de rutas públicas coherentes para que redirect de auth no bloquee enlaces legítimos.
- Mantener documentación de endpoint alineada entre llamada móvil, controlador backend y DTO.

## Verificación disponible

`test/widget_test.dart` es el test presente en este checkout. No se ejecutaron comandos de prueba/análisis para producir esta documentación. Al cambiar código, los comandos usuales del repo son `flutter analyze` y `flutter test`; revisa sus resultados en el entorno de desarrollo.

## Configuración sensible

No copiar tokens, claves de Firebase, URLs internas con credenciales ni valores secretos a `docs/`. Firebase init falla de forma tolerante con log; revisa configuración nativa Android/iOS cuando se modifique push. El cliente no implementa refresh JWT. Revisa builds y logs si activas trazas HTTP.

## Mapa

[`pubspec.yaml`](../pubspec.yaml), [`api_config.dart`](../lib/core/config/api_config.dart), [`di.dart`](../lib/core/di.dart), [`analysis_options.yaml`](../analysis_options.yaml), [`test/widget_test.dart`](../test/widget_test.dart).
