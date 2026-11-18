# Integraciones API entre repositorios

Estado: rutas consumidas verificadas contra mappings en Java. Los nombres de DTO y la autorización se deben revisar en implementación. Base URL web: `VITE_API_BASE_URL`; móvil: `DINEROP_API_BASE_URL`/`DINEROP_HOST_IP` o fallback Railway.

## Auth y registro

| Método y ruta | Consumidor comprobado | Backend | Nota |
|---|---|---|---|
| `POST /api/auth/login` | Móvil `AuthRemoteDataSource`; web `auth.api.ts` | `AuthController.login` | Sin Bearer; respuesta incluye token/usuario. |
| `POST /api/auth/registration/start` | Móvil y web `auth.api` | `AuthController.registration/start` | Registro por OTP; no equivale a solicitud pública de crédito. |
| `POST /api/auth/registration/verify-code` | Móvil y web | `AuthController` | Verificación OTP. |
| `POST /api/auth/registration/resend-code` | Móvil y web | `AuthController` | Reenvío OTP. |
| `POST /api/auth/registration/change-email` | Móvil y web | `AuthController` | Cambio de email durante registro. |
| `POST /api/auth/registration/set-password` | Móvil y web | `AuthController` | Completa contraseña. |
| `GET /api/auth/activate?token=…`, `POST /api/auth/complete-registration` | Móvil y web | `AuthController` | Flujos de activación/registro legado también presentes. |
| `POST /api/auth/password/forgot`, `/password/reset` | Móvil y web | `AuthController` | Recuperación de contraseña. |

## Funciones de negocio

| Método y ruta | Móvil | Web | Backend |
|---|---|---|---|
| `GET /api/cooperatives` | Sí | Sí | `CooperativeController` público. |
| `POST /api/credits/public-request` | Sí (registro móvil) | Sí (modal público) | `CreditController`; público. |
| `GET, POST /api/credits/me` | Sí | Sí | `CreditController`; cliente autenticado en POST; GET protegido por regla global de seguridad en código actual. |
| `GET /api/credits/me/{id}/pre-approved` | Sí | Sí | `CreditController`. |
| `PUT /api/credits/me/{id}/cooperatives/{coopId}/accept` | Sí | Sí | `CreditController`. |
| `GET /api/credits/me/{id}/cooperatives/{coopId}/referral.pdf` | Sí | No identificado | `CreditController`; PDF. |
| `GET /api/credits/cooperative/me/requests` | No identificado | Sí | `CreditController`. |
| `PUT .../{id}/decision`, `.../solicitar-garante`, `.../garante-decision` | No identificado | Sí | `CreditController`. |
| `GET .../{id}/offer-defaults`, `.../{id}/timeline` | No identificado | Sí | `CreditController`. |
| `GET /api/onboarding/cliente/formulario-status`, `/pre-registration` | Sí | Sí | `OnboardingClienteController`. |
| `POST /api/onboarding/cliente/solicitante`, `/garante/completar` | Sí | Sí | `OnboardingClienteController`. |
| `GET /api/onboarding/cooperativa/{id}` | No identificado | Sí | `OnboardingCooperativaController`. |
| `GET, POST /api/visits` | No identificado | Sí | `VisitController`, público según `SecurityConfig`. |
| `POST /api/notifications/devices/token` | Sí | No identificado | `PushNotificationController`; comprobar autorización/registro en Java. |

`...` en la tabla refiere a `/api/credits/cooperative/me/requests`. Las tablas detalladas de los clientes (`app_movil_dinerop/docs/API_INTEGRATION.md`, `dinerup-app/docs/API_INTEGRATION.md`) y el listado completo por módulo (`dinerop-backend/API_DOCUMENTATION.md`) contienen más contexto.

## Contratos backend sin consumidor identificado

Controladores incluyen endpoints internos `/internal/credits/**`, `/internal/cooperatives/**`, `/api/internal/auth/**`, administrativos `/api/admin/**`, test `/api/test/email`, y CRUD público de cooperativas. No se halló consumidor desde estos dos clientes en búsquedas de rutas. Eso no demuestra que no existan consumidores externos, jobs o integraciones no incluidos aquí.

## Discrepancias que requieren cuidado

- El documento backend dice `/api/auth` como cinco operaciones principales; el `AuthController` actual también expone registro OTP, y los dos clientes las usan.
- El documento backend representa `GET /api/credits/me` como público en su tabla de seguridad; `SecurityConfig` sólo permite `/api/auth/**`, `/api/cooperatives/**`, `/api/visits/**`, test y documentación, y hace autenticado lo demás. Los clientes actuales adjuntan token por defecto para esa ruta.
- Backend docs omiten rutas reales usadas por clientes: onboarding `pre-registration` (y web además `mi-ubicacion`), parámetros de ofertas/timeline, PDF de referencia, notificaciones de dispositivo y visitas.
- Web `onboarding.api.ts` solicita `GET /api/onboarding/cliente/mi-ubicacion`, pero no aparece mapping equivalente en `OnboardingClienteController` inspeccionado. Contrato no verificado: posible endpoint en otra ruta/configuración o código web desfasado.
- `POST /api/cooperatives` aparece como regla pública en el `httpClient` web, pero el controlador existe y el endpoint se declara público por patrón `/api/cooperatives/**`; ninguno de los dos clientes crea cooperativas en uso visible.

Referencias primarias: `dinerop-backend/src/main/java/com/markup/dinerop/*Controller.java`, `auth/config/SecurityConfig.java`, `app_movil_dinerop/lib/features/*/data/`, `app_movil_dinerop/lib/core/notifications/push_notification_service.dart`, `dinerup-app/src/api/`.

## Módulo de inversiones (noviembre de 2026)

Los clientes móvil y DinerUp usan los nuevos endpoints definidos en `dinerop-backend/cooperative/infrastructure/web/InvestmentController` y `CooperativeInvestmentController`:

- `GET /api/investments/availability` y `GET /api/investments/offers` son públicos y no reciben PII.
- `POST /api/investments/public-requests` es público y dedicado al registro de inversión: recibe identidad, ubicación, oferta seleccionada y consentimiento; guarda en `investment_requests` y luego inicia OTP. No pasa por `POST /api/credits/public-request`.
- `POST /api/investments/requests` y `GET /api/investments/requests/me` requieren rol `CLIENT`.
- `/api/credits/cooperative/me/investment-products*` y `/investment-requests*` requieren `COOPERATIVE`; el backend toma el ID cooperativo de la cuenta autenticada.
- La selección requiere consentimiento explícito, guarda snapshot de tasa/condiciones y comparte datos de contacto solo con la cooperativa seleccionada. Los plazos implementados son meses porque las condiciones existentes modelan `minimumTermMonths`/`maximumTermMonths`.
- `/api/credits/cooperative/me/investment-requests/{id}/acceptance` registra la respuesta de aceptación, requisitos y ubicación de agencia, restringida a la cooperativa propietaria y protegida ante doble aceptación concurrente. `CONDITIONS_CONFIRMED` significa aceptación pendiente de formalización en la cooperativa, no depósito constituido.
- Las experiencias web y móvil conservan un borrador de simulación por hasta 30 minutos durante el acceso/registro y vuelven a consultar ofertas vigentes al regresar; el cliente debe revisar las condiciones actualizadas antes de consentir y enviar.
- Graphify local actualizado en los tres proyectos. Verifica controladores y servicios Java antes de interpretar los enlaces del grafo como llamadas entre repositorios.

## Crédito público y catálogo de productos (noviembre de 2026)

- `GET /api/credits/public-offers?creditCategory={CONSUMO|MICROCREDITO}&amount={USD}&termMonths={meses}` entrega productos de crédito activos que cubren el monto/plazo y tienen una tasa vigente. No recibe PII ni calcula cuota estimada; la oferta no representa aprobación.
- `financial_products.credit_category` distingue categorías de crédito sin ampliar `FinancialProductType`, que sigue permitiendo solamente `CREDIT` e `INVESTMENT`. La API exige categoría nueva para productos `CREDIT`; productos existentes pueden quedar sin clasificar hasta ser editados por el administrador. `INVESTMENT` corresponde al depósito a plazo fijo en las interfaces actuales.
- Administración de productos vacíos vive en `markup-admin`; su lista distingue array vacío, error HTTP y respuestas de datos inválidas, y muestra datos de la cooperativa seleccionada antes de ofrecer acciones para crear productos.
