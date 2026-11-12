# Páginas y rutas

La aplicación usa **React Router DOM**, no App Router/Pages Router de Next.js. Las rutas están en `src/App.tsx`; `BrowserRouter` se inicializa en `src/main.tsx`.

| Ruta | Vista | Acceso / comportamiento |
|---|---|---|
| `/` | `Login` | Pública solo para sesión no cargada/autenticada mediante `PublicOnlyRoute` (el guard solo espera la carga; no redirige a quien ya inició sesión) |
| `/login` | `Login` | Igual que `/` |
| `/activate` | `ActivateAccount` | Pública; el token se lee de query string |
| `/forgot-password` | `ForgotPassword` | Pública |
| `/reset-password` | `ResetPassword` | Pública; maneja token/query |
| `/dashboard-client` | `DashboardClient` | Protegida para rol `client` |
| `/onboarding` | `OnboardingPage` | Protegida para rol `client` |
| `/dashboard-cooperative` | `DashboardCooperative` | Protegida para rol `cooperative` |

`ProtectedRoute` muestra pantalla de carga durante la hidratación, dirige a `/login` si no hay sesión y redirige al dashboard correspondiente cuando el rol no coincide. No aparece una ruta catch-all para URLs desconocidas.

## Onboarding por pasos

`OnboardingPage` compone los pasos `Step1Identity`, `Step2PersonalDetails`, `Step3Address`, `Step4Economic`, `Step5Spouse` y `Step4Review`. Son componentes, no rutas independientes. El nombre `Step4Review` coexiste con `Step4Economic` en el árbol.

```mermaid
flowchart TD
  Root[/ y /login] --> Login[Login]
  Login -->|cliente autenticado| Client[/dashboard-client]
  Login -->|cooperativa autenticada| Coop[/dashboard-cooperative]
  Client --> Onboard[/onboarding]
  Public[/activate, /forgot-password, /reset-password]
  Guard{ProtectedRoute: sesión y rol}
  Guard --> Client
  Guard --> Coop
```

## Referencias

- [src/App.tsx](../src/App.tsx), [src/main.tsx](../src/main.tsx)
- [src/pages/](../src/pages/), [src/pages/steps/](../src/pages/steps/)
