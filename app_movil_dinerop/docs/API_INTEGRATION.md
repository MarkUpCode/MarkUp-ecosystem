# Integración con API

## Cliente HTTP y ambiente

`ApiConfig.resolveBaseUrl()` prioriza `DINEROP_API_BASE_URL`, después `DINEROP_HOST_IP` y finalmente el host Railway configurado en código. `ApiClient` configura Dio con timeouts de 20 s, JSON, interceptor bearer y manejo 401. La autenticación se omite cuando el método recibe `authenticated: false`. El logging HTTP de Dio se crea deshabilitado desde DI; quedan mensajes de depuración con método/ruta/estado/tiempo, sin headers o cuerpos en esos mensajes. No registrar valores de tokens.

Base URL es solo host/base; las rutas abajo incluyen `/api/...`. No se asume que la URL actual corresponda a un entorno particular. Para backend se consultaron controladores Java de `../dinerop-backend/src/main/java/com/markup/dinerop` y `API_DOCUMENTATION.md`.

## Rutas consumidas y correspondencia

| Método | Ruta enviada por app | Autenticada | Consumidor | Correspondencia en backend |
|---|---|---:|---|---|
| POST | `/api/auth/login` | No | `AuthRemoteDataSource.login` | `AuthController.login` |
| POST | `/api/credits/public-request` | No | `register` | `CreditController.public-request` |
| GET | `/api/auth/activate?token=…` | No | `activate` | `AuthController.activate` |
| POST | `/api/auth/complete-registration` | No | `completeRegistration` | `AuthController.complete-registration` |
| POST | `/api/auth/registration/verify-code` | No | `verifyRegistrationCode` | `AuthController.registration/verify-code` |
| POST | `/api/auth/registration/resend-code` | No | `resendRegistrationCode` | `AuthController.registration/resend-code` |
| POST | `/api/auth/registration/change-email` | No | `changeRegistrationEmail` | `AuthController.registration/change-email` |
| POST | `/api/auth/registration/set-password` | No | `setRegistrationPassword` | `AuthController.registration/set-password` |
| POST | `/api/auth/password/forgot` | No | `forgotPassword` | `AuthController.password/forgot` |
| POST | `/api/auth/password/reset` | No | `resetPassword` | `AuthController.password/reset` |
| GET | `/api/onboarding/cliente/formulario-status` | Sí | `loadStatus` | `OnboardingClienteController.formulario-status` |
| GET | `/api/onboarding/cliente/pre-registration` | Sí | `loadPreRegistrationData` | `OnboardingClienteController.pre-registration` |
| POST | `/api/onboarding/cliente/solicitante` | Sí | `submitClientOnboarding` | `OnboardingClienteController.solicitante` |
| POST | `/api/onboarding/cliente/garante/completar` | Sí | `submitGuarantorOnboarding` | `OnboardingClienteController.garante/completar` |
| POST | `/api/credits/me` | Sí | `createCreditRequest` | `CreditController.me` POST |
| GET | `/api/credits/me` | Sí* | `loadMyRequests` | `CreditController.me` GET |
| GET | `/api/credits/me/{id}/pre-approved` | Sí | `loadPreApprovedCooperatives` | `CreditController.me/{solicitudId}/pre-approved` |
| PUT | `/api/credits/me/{id}/cooperatives/{cooperativeId}/accept` | Sí | `acceptCooperative` | `CreditController.../accept` |
| GET | `/api/credits/me/{id}/cooperatives/{cooperativeId}/referral.pdf` | Sí | `downloadReferralPdf` | `CreditController` mapping, PDF |
| GET | `/api/cooperatives` | Default auth behavior† | `CooperativeRepository.loadCooperatives` / `CreditRepository.loadCatalog` | `CooperativeController` root |
| POST | `/api/notifications/devices/token` | Sí | `PushNotificationService` | `PushNotificationController` |

\* `ApiClient` default es autenticado; `GET /api/credits/me` no pasa `authenticated: false`. El backend documentation lista este GET como público, pero la app adjunta bearer si existe.

† La app usa valor por defecto `authenticated: true`; el interceptor añade token si hay. Backend security/`API_DOCUMENTATION.md` considera público `/api/cooperatives/**`, por lo que el bearer es incidental.

## Formatos y DTO

- Login envía `{email,password}` y parsea `{accessToken,user}` (`LoginResponse`, `AppUser`).
- Registro público crea solicitud mediante `PublicRegistrationRequest`; mapea a endpoint de crédito público, no a `POST /api/auth/register`.
- Solicitud de crédito serializa `monto`, `type`, `creditType`, `plazoMeses`, `province`, `city` (`CreditRequestPayload`).
- Onboarding del solicitante serializa objeto contenedor `destinoCredito/solicitante/conyuge`; garante envía persona plana y elimina `email` (`OnboardingRepository`).
- El cliente convierte arrays/mapas a `CooperativeSummary`, `ClientCreditRequestSummary`, `CreditCooperativeStatus` y onboarding DTO. Valores enum desconocidos tienen fallback `unknown`.
- PDF solicita `ResponseType.bytes` y lo convierte a `Uint8List`.

## Errores

`ApiClient` convierte timeout/conexión a mensaje de red; para respuesta backend intenta `message`, luego `error`, luego campos de validación; 401 produce mensaje de sesión si no hay texto del backend. Errores no Dio se normalizan a genérico. En 401 autenticado se invoca `onUnauthorized` (limpia almacenamiento). La app no implementa refresh-token aquí.

## Correspondencia backend y límites

Las rutas listadas sí existen en controladores fuente. Hay diferencias entre backend `API_DOCUMENTATION.md` y el código fuente: la documentación de backend enumera los flujos registro por código incompletamente y no describe `GET /api/onboarding/cliente/pre-registration` ni endpoint push; el controlador actual sí los expone. El documento backend menciona un `GET /api/credits/me` como público aunque el controlador de la app lo invoca con auth por defecto. Los endpoints de cooperativa/cliente se validaron en `CreditController`, `OnboardingClienteController`, `CooperativeController` y `PushNotificationController`. No se incluyen secretos ni tokens reales.

## Referencias

App: [`api_client.dart`](../lib/core/network/api_client.dart), [`api_config.dart`](../lib/core/config/api_config.dart), [`auth_remote_data_source.dart`](../lib/features/auth/data/auth_remote_data_source.dart), [`onboarding_repository.dart`](../lib/features/onboarding/data/onboarding_repository.dart), [`credit_repository.dart`](../lib/features/credit/data/credit_repository.dart), [`cooperative_repository.dart`](../lib/features/cooperative/data/cooperative_repository.dart), [`push_notification_service.dart`](../lib/core/notifications/push_notification_service.dart). Backend: `../dinerop-backend/src/main/java/com/markup/dinerop/{auth/controller/AuthController.java,credit/infrastructure/web/CreditController.java,onboarding/controller/OnboardingClienteController.java,cooperative/infrastructure/web/CooperativeController.java,notification/controller/PushNotificationController.java}`.
