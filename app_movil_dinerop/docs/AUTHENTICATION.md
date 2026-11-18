# Autenticación y sesión

## Flujo

```mermaid
sequenceDiagram
  participant UI as LoginPage
  participant C as AuthController
  participant R as AuthRepository
  participant DS as AuthRemoteDataSource
  participant API as ApiClient
  participant S as SecureTokenStorage
  UI->>C: login(email, password)
  C->>R: login(...)
  R->>DS: login(...)
  DS->>API: POST /api/auth/login (sin bearer)
  API-->>C: LoginResponse(accessToken, user)
  C->>S: persistir sesión
  C->>R: consultar estado onboarding si cliente activo
  C-->>UI: notifyListeners()
```

En bootstrap el controlador intenta leer la sesión guardada; valida estado de onboarding para cliente activo. El router escucha el controlador y redirige según `isBootstrapping`, `isAuthenticated` y `requiresActivation`. El token se añade como `Authorization: Bearer ...` a requests autenticados por interceptor. Al recibir 401 el callback elimina almacenamiento; al cerrar sesión se limpia almacenamiento y estado en memoria.

## Datos de sesión

`SecureTokenStorage` guarda el token, serialización JSON del usuario y flag de onboarding con keys privadas de implementación. `FlutterSecureStorage` es provisto por `core/di.dart`. No almacenar credenciales de contraseña en sesión. También se persisten tema y marca de bienvenida. `clear()` llama `deleteAll`, por lo que borra también esas preferencias.

`AppUser` representa id/email/role/status y ofrece `isClient`, `isActive`, `isPendingActivation`. Login solo conserva acceso y resumen del usuario. `AuthController` también maneja último correo, busy, error, bootstrap y flags de activación/onboarding.

## Registro, activación y recuperación

Las páginas de registro, verificación y activación usan métodos del mismo `AuthController`; las peticiones son públicas (`authenticated: false`). El alta pública de cliente usa `/api/credits/public-request`. La recuperación solicita un OTP con `/api/auth/password/forgot`, lo valida con `/api/auth/password/verify-code` y usa la credencial temporal devuelta una sola vez en `/api/auth/password/reset`. El OTP tiene vigencia de 10 minutos, máximo 5 intentos y espera de 45 segundos para reenviar; es independiente del OTP de registro. El correo siempre obtiene la misma respuesta al solicitar el código, exista o no la cuenta. El login exitoso registra FCM de forma no bloqueante.

## Consideraciones observadas

El cliente no contiene flujo de refresh de JWT. Un token ausente no impide técnicamente request; endpoints protegidos devolverán error. El inicio tolera fallo de Firebase. `ApiClient` evita loguear headers/body mediante su `LogInterceptor` desactivado y el interceptor 401 no imprime token. Los mensajes de depuración muestran URL base, método/ruta y resultados; revisar configuración por entorno antes de habilitar logging en builds sensibles.

## Referencias

[`auth_controller.dart`](../lib/features/auth/presentation/auth_controller.dart), [`auth_repository.dart`](../lib/features/auth/data/auth_repository.dart), [`auth_remote_data_source.dart`](../lib/features/auth/data/auth_remote_data_source.dart), [`secure_token_storage.dart`](../lib/core/storage/secure_token_storage.dart), [`api_client.dart`](../lib/core/network/api_client.dart), [`app_router.dart`](../lib/app/router/app_router.dart).
