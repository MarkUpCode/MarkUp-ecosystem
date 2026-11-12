# Componentes de interfaz

## Sistema visual

`core/theme/` contiene `AppTheme`, colores, espaciado y proveedor de modo claro/oscuro. `MaterialApp.router` aplica `AppTheme.light()` y `AppTheme.dark()` según `themeModeProvider`. Widgets compartidos resuelven controles repetidos y estados vacíos/error/carga.

| Componente | Uso / API visual |
|---|---|
| `AppButton` | Variantes primary/secondary/outlined, estado loading, icono y callback |
| `AppTextField` | Campo reutilizable con label, validación y opciones de icono/obscure |
| `AppCard` | Contenedor/tarjeta con padding y decoración de tema |
| `AppBadge` | Etiqueta con colores parametrizables |
| `AppLoader` | Indicador y texto de carga |
| `AppErrorView` | Error y acción opcional de reintento |
| `AppEmptyState` | Estado sin resultados con acción opcional |
| `AppHeader`, `AppAuthenticatedHeader` | Encabezados público y de zona autenticada |
| `StepProgress` | Progreso de formularios por pasos |
| `CreditRequestCard` | Presentación de resumen de solicitud |
| `CooperativeLogoMarquee` | Recurso visual para logos/partners |

Rutas de fuente: `lib/shared/widgets/`, `lib/features/credit/presentation/widgets/credit_request_card.dart`, `lib/core/widgets/cooperative_logo_marquee.dart`. El feature Welcome también incluye widgets de presentación especializados para identidad, confianza, partners y tarjeta de logo.

## Patrones en páginas

Las páginas consumen `AsyncValue.when(...)`/branches equivalentes para renderizar carga, error y datos; `AppLoader`, `AppErrorView`, `AppEmptyState` aportan estados consistentes. La navegación inferior vive en `AppShell`. Algunas pantallas incorporan internamente diálogos, sheets y tarjetas privadas específicas del flujo, por ejemplo filtros/aceptación en solicitudes.

## Referencias

[`app_theme.dart`](../lib/core/theme/app_theme.dart), [`theme_provider.dart`](../lib/core/theme/theme_provider.dart), [`app_button.dart`](../lib/shared/widgets/app_button.dart), [`app_text_field.dart`](../lib/shared/widgets/app_text_field.dart), [`app_error_view.dart`](../lib/shared/widgets/app_error_view.dart).
