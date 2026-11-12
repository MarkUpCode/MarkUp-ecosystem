# API_ENDPOINTS

Rutas combinadas desde `@RequestMapping` y mapping de método en cada controlador. El inventario no sustituye los DTO, validaciones, códigos de respuesta ni documentación OpenAPI. Prefijos del controlador deben concatenarse con las rutas de método. Las rutas marcadas internas no equivalen a autenticación interna confiable: revisar regla de seguridad y anotaciones concretas.

## Autenticación — `AuthController` (`/api/auth`)

| Método | Ruta | Uso |
|---|---|---|
| POST | `/register` | registro público |
| POST | `/login` | iniciar sesión |
| GET | `/activate` | activar cuenta |
| POST | `/complete-registration` | completar registro |
| POST | `/registration/start` | iniciar registro OTP |
| POST | `/registration/verify-code` | verificar OTP |
| POST | `/registration/resend-code` | reenviar OTP |
| POST | `/registration/change-email` | cambiar email en registro |
| POST | `/registration/set-password` | definir contraseña |
| POST | `/password/forgot` | iniciar recuperación |
| POST | `/password/reset` | restablecer contraseña |

`InternalAuthController`: POST `/api/internal/auth/pre-register`.

## Crédito — `CreditController` (`/api/credits`)

| Método | Ruta | Uso / autorización explícita |
|---|---|---|
| POST | `/public-request` | solicitud pública; permitida explícitamente por `SecurityConfig` |
| GET | `/me/{solicitudId}/cooperatives/{cooperativaId}/referral.pdf` | generar/obtener PDF de referido |
| POST | `/me` | crear solicitud como CLIENT |
| GET | `/me` | consultar créditos como CLIENT |
| GET | `/cooperative/me/requests` | solicitudes recibidas como COOPERATIVE |
| PUT | `/cooperative/me/requests/{solicitudId}/decision` | decisión de cooperativa |
| GET | `/cooperative/me/requests/{solicitudId}/offer-defaults` | parámetros sugeridos de oferta |
| PUT | `/cooperative/me/requests/{solicitudId}/solicitar-garante` | pedir garante |
| PUT | `/cooperative/me/requests/{solicitudId}/garante-decision` | decisión sobre garante |
| GET | `/cooperative/me/requests/{solicitudId}/timeline` | eventos del proceso |
| GET | `/me/{solicitudId}/pre-approved` | estado de preaprobación |
| PUT | `/me/{solicitudId}/cooperatives/{cooperativaId}/accept` | aceptar oferta |

`InternalCreditController` (`/internal/credits`): POST `/link-client`, POST `/completed`, PUT `/solicitudes/{solicitudId}/estado`.

## Onboarding

- `OnboardingClienteController` (`/api/onboarding/cliente`): POST `/solicitante`, POST `/garante/completar`, GET `/{solicitudId}`, GET `/formulario-status`, GET `/pre-registration`.
- `OnboardingCooperativaController` (`/api/onboarding/cooperativa`): POST `/{solicitudId}/solicitar-garante`, GET `/{solicitudId}`.

## Cooperativas

- `CooperativeController` (`/api/cooperatives`): GET `/`, GET `/{id}`, GET `/by-city`, GET `/by-province`, POST `/`.
- `InternalCooperativeController` (`/internal/cooperatives`): GET `/by-city`, GET `/{id}`, GET `/eligible`, GET `/{id}/rates/{tipoCredito}`.

## Administración

Todos estos controladores declaran `@PreAuthorize("hasRole('ADMIN')")`.

- `UserAdminController` (`/api/admin/users`): GET `/`, GET `/{id}`, POST `/`, PATCH `/{id}/status`.
- `CooperativeAdminController` (`/api/admin/cooperatives`): GET `/`, GET `/{id}`, POST `/`, PUT `/{id}`, DELETE `/{id}`.
- `DashboardController` (`/api/admin/dashboard`): GET `/`.

## Otros

- `PushNotificationController` (`/api/notifications`): POST `/devices/token`, DELETE `/devices/token`.
- `TestEmailController` (`/api/test`): POST `/email`.
- `VisitController` (`/api/visits`): GET `/`, POST `/`.

## Verificación de permisos

`SecurityConfig` permite `/api/auth/**`, `/api/cooperatives/**`, `/api/visits/**`, `/api/test/**`, Swagger, actuator, OPTIONS y POST `/api/credits/public-request`; el resto requiere autenticación. Controladores agregan roles en algunos métodos/clases. Hay que revisar ambas capas para saber el permiso efectivo. No se documentan cuerpos completos aquí; ver DTOs del controlador y `API_DOCUMENTATION.md`, validando este último con el código.
