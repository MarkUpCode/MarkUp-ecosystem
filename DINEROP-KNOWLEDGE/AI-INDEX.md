# Índice de investigación para IA

Lee primero [GLOBAL-OVERVIEW.md](GLOBAL-OVERVIEW.md) para entender límites y estrategia de investigación. Luego usa esta guía para saltar a las fuentes concretas. Las rutas son relativas a la raíz `Dinerop`.

## Elegir por funcionalidad

| Pregunta | Documentación central | Fuentes prioritarias |
|---|---|---|
| ¿Qué repositorios componen Dinerop y qué hace cada uno? | `GLOBAL-OVERVIEW.md` | `dinerop-backend/docs/PROJECT_OVERVIEW.md`, `app_movil_dinerop/docs/PROJECT_OVERVIEW.md`, `dinerup-app/docs/PROJECT_OVERVIEW.md` |
| ¿Cómo se conectan las aplicaciones con el servidor? | `API-INTEGRATIONS.md`, `CROSS-REPOSITORY-DEPENDENCIES.md` | `dinerop-backend/src/main/java/com/markup/dinerop/*Controller.java`; móvil `lib/core/network/api_client.dart`; web `src/api/httpClient.ts` |
| Login, JWT, roles, registro OTP, reset | `AUTHENTICATION-FLOW.md` | Backend `auth/controller`, `auth/service`, `auth/config`; móvil `lib/features/auth/`; web `src/api/auth/`, `src/context/AuthContext.tsx` |
| Crédito/solicitudes, distribución y ofertas | `USER-FLOWS.md`, `DATA-FLOW.md`, `API-INTEGRATIONS.md` | Backend `credit/domain/service/CreditService`, `CreditDistributionService`; `cooperative/domain/service/CooperativeService`, `FinancialProductService`; móvil `lib/features/credit/`; web `src/api/creditRequests.api.ts`, `DashboardClient.tsx`, `DashboardCooperative.tsx` |
| Onboarding cliente/garante/cooperativa | `USER-FLOWS.md`, `API-INTEGRATIONS.md` | Backend `onboarding/`; móvil `lib/features/onboarding/`; web `src/api/onboarding.api.ts`, `src/pages/OnboardingPage.tsx` |
| Catálogo de cooperativas | `API-INTEGRATIONS.md` | Backend `CooperativeController`; móvil `lib/features/cooperative/`; web `src/api/cooperatives.api.ts` |
| Catálogo estándar de productos, configuración cooperativa y simulación de inversión | `API-INTEGRATIONS.md`, `DATA-FLOW.md`, `USER-FLOWS.md` | Backend `cooperative/domain/service/FinancialProductService`, `InvestmentService`, `CooperativeCreditProductController`, `CooperativeInvestmentController`; DinerUp `src/components/credit/CooperativeCreditProductsPanel.tsx`, `src/components/investment/CooperativeInvestmentsPanel.tsx`, `src/pages/PublicInvestments.tsx`; administración `markup-admin/src/modules/products/` |
| Método central de cálculo de inversión | `API-INTEGRATIONS.md`, `ARCHITECTURAL-DECISIONS.md` | Backend `InvestmentCalculationSettingsService`, `InvestmentService`, `AdminInvestmentCalculationSettingsController`; `markup-admin/src/modules/products/pages/ProductsPage.tsx` |
| Errores del panel administrativo de cooperativas | `AUTHENTICATION-FLOW.md`, `API-INTEGRATIONS.md` | `markup-admin/src/services/axios.ts`, `src/contexts/auth-context.tsx`; backend `auth/config/SecurityConfig.java`, `JwtAuthenticationFilter.java`, `admin/cooperative/`, `admin/dashboard/` |
| Persistencia/esquema | `DATA-FLOW.md` | Backend `schema.sql`, `application*.yaml`, paquetes `*/infrastructure/repository`, entidades JPA |
| Push y dispositivos | `API-INTEGRATIONS.md` | Backend `notification/`; móvil `lib/core/notifications/push_notification_service.dart` |
| Arquitectura local por repo | `GLOBAL-ARCHITECTURE.md` | Cada repo `docs/ARCHITECTURE.md` y `graphify-out/GRAPH_REPORT.md` |

## Reglas para una investigación segura

1. Verifica vigencia del grafo local comparando commit de `graphify-out/GRAPH_REPORT.md` con HEAD si Git está disponible.
2. Confirma los endpoints del cliente contra anotaciones `@*Mapping` del backend. Para una ruta sin mapping, registra discrepancia; no asumas endpoint implícito.
3. Sigue controlador → servicio → dominio/repositorio → entidad/SQL para entender comportamiento y datos.
4. Distingue código ejecutable, mocks/catálogos estáticos, documentación y grafo inferido. Un componente visible no demuestra uso del backend.
5. No expongas valores secretos de archivos de entorno/configuración; sólo documenta nombres de variables.

## Grafos Graphify disponibles

- Global: `DINEROP-KNOWLEDGE/global-graph.json` (nodos identificados por campo `repo`).
- Backend: `dinerop-backend/graphify-out/graph.json`, `GRAPH_REPORT.md`.
- Móvil: `app_movil_dinerop/graphify-out/graph.json`, `GRAPH_REPORT.md`.
- Web: `dinerup-app/graphify-out/graph.json`, `GRAPH_REPORT.md`.
- Administración: `markup-admin/graphify-out/graph.json`, `GRAPH_REPORT.md`.

Los grafos son mapas de símbolos/relaciones para navegar. Confianza `INFERRED` o una relación semántica no constituye prueba de llamada de red entre proyectos.

## Mapa de documentos del ecosistema

- [Arquitectura global](GLOBAL-ARCHITECTURE.md)
- [Integraciones API](API-INTEGRATIONS.md)
- [Autenticación](AUTHENTICATION-FLOW.md)
- [Flujos de usuario](USER-FLOWS.md)
- [Flujo de datos](DATA-FLOW.md)
- [Dependencias cruzadas](CROSS-REPOSITORY-DEPENDENCIES.md)
- [Decisiones arquitectónicas](ARCHITECTURAL-DECISIONS.md)
