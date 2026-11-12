# Componentes

## Componentes de páginas

- Acceso: `Login`, `ActivateAccount`, `ForgotPassword`, `ResetPassword`.
- Cliente: `DashboardClient`, `OnboardingPage`.
- Cooperativa: `DashboardCooperative`.
- Formulario escalonado: `Step1Identity`, `Step2PersonalDetails`, `Step3Address`, `Step4Economic`, `Step5Spouse`, `Step4Review`.

## Componentes reutilizables

| Grupo | Componentes |
|---|---|
| `components/auth` | `CompleteRegistrationModal` (perfil, OTP y contraseña) |
| `components/cooperative` | `CooperativeCard`, `CooperativesCarousel`, `CooperativeLogoMarquee` |
| `components/credit` | `CreditCard`, `CreditDetailsModal`, `NewCreditModal`, `PreApprovalModal`, `PublicCreditRequestModal`, `SuccessRequestModal` |
| `components/investment` | `NewInvestmentModal` |
| `components/layout` | `Footer`, `Navbar`, `PlatformVisitsCounter`, `UnderDevelopment`, `WelcomePopup` |
| `components/onboarding` | `GuaranteeOnboardingModal`, `OnboardingPopup`, `SuccessOnboardingModal` |

Los componentes privados `ApplicantModal`, `RequestsView`, `Overview`, `Analytics`, `SettingsView` y elementos de presentación relacionados están definidos dentro de `DashboardCooperative.tsx`, no en archivos independientes. Los pasos de onboarding también se extraen como componentes por archivo.

## Hooks

Hook de dominio propio: `useAuth()` en `src/context/useAuth.ts`, que consume `AuthContext` y exige un `AuthProvider`. No se identificaron carpetas de hooks de datos ni bibliotecas de caché de servidor.

Los demás hooks son de React/Router y se usan localmente: `useState`, `useEffect`, `useMemo`, `useCallback`, `useRef`, `useContext`, `useNavigate`, `useSearchParams`; `Login` usa además `useForm` de React Hook Form.

## Patrones observados

Los modales reciben propiedades para abrir/cerrar y callbacks de confirmación; las páginas coordinan cargas y datos de backend. Formularios y filtros suelen tener estado local. La mayoría del estilo se expresa con clases Tailwind y utilidades CSS.

## Referencias

- [src/components/](../src/components/), [src/pages/](../src/pages/)
- [src/context/useAuth.ts](../src/context/useAuth.ts), [src/context/AuthContext.tsx](../src/context/AuthContext.tsx)
