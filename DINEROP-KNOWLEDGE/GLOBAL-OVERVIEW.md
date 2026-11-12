# DINEROP: visión del ecosistema

## Propósito

Dinerop reúne una API de negocio y persistencia (`dinerop-backend`), una aplicación móvil Flutter (`app_movil_dinerop`) y una aplicación web para clientes y cooperativas (`dinerup-app`). La relación comprobada entre ellos es HTTP: ambos clientes construyen solicitudes a rutas que se corresponden con controladores REST del backend. No se encontró evidencia de importación directa de código entre repositorios.

```mermaid
flowchart LR
  M[App móvil Flutter] -->|HTTPS/JSON + Bearer cuando aplica| API[Backend Spring Boot]
  W[Web SPA Vite/React] -->|HTTP(S)/JSON + Bearer cuando aplica| API
  API -->|Spring Data JPA| DB[(PostgreSQL)]
  API -->|integraciones internas configuradas| N[Correo / push]
```

La flecha de notificaciones representa capacidades declaradas/configuradas en backend (Resend y Firebase), no una integración directa con los repositorios de cliente. PostgreSQL es la base principal declarada por el backend. Ver [GLOBAL-ARCHITECTURE.md](GLOBAL-ARCHITECTURE.md) y [DATA-FLOW.md](DATA-FLOW.md).

## Repositorios y responsabilidades observadas

| Repositorio | Implementación observada | Áreas visibles |
|---|---|---|
| `dinerop-backend/` | Java 17, Spring Boot, monolito modular y PostgreSQL | Auth/JWT, cooperativas, solicitudes de crédito, onboarding, notificaciones, administración y visitas. Inicio: `src/main/java/com/markup/dinerop/`; contratos: `API_DOCUMENTATION.md`; arquitectura: `docs/ARCHITECTURE.md`. |
| `app_movil_dinerop/` | Flutter/Dart, Riverpod, GoRouter, Dio | Registro/acceso, onboarding, solicitudes, cooperativas, perfil, dashboard y simuladores. Entrada: `lib/main.dart`; integración: `lib/core/network/api_client.dart`. |
| `dinerup-app/` | Vite 5, React 18.3, TypeScript, React Router | SPA para cliente y cooperativa, autenticación, onboarding y gestión de solicitudes. Entrada: `src/main.tsx`, rutas: `src/App.tsx`, HTTP: `src/api/httpClient.ts`. |

**Corrección de contexto:** aunque el encargo describe el sitio web como Next.js 15/React 19, `dinerup-app/package.json` declara Vite 5 y React/React DOM 18.3; el código usa `BrowserRouter`. No es una aplicación Next.js según el checkout inspeccionado.

## Cómo investigar una funcionalidad sin recorrer todo

1. Empieza en [AI-INDEX.md](AI-INDEX.md) y elige el flujo o módulo.
2. Identifica la pantalla/acción cliente y localiza su servicio API (`dinerup-app/src/api/` o `app_movil_dinerop/lib/features/*/data/`).
3. Busca la ruta exacta en el controlador Java correspondiente; confirma método, seguridad y DTO en el código, no solo en documentación.
4. Sigue el servicio de dominio y repositorios JPA para reglas y persistencia. Para entidades/tablas, usa `dinerop-backend/schema.sql` y paquetes `credit`, `onboarding`, `auth`, `cooperative`.
5. Usa `graphify-out/GRAPH_REPORT.md` como mapa de navegación y sus `graph.json` para relaciones locales. El grafo global está en `DINEROP-KNOWLEDGE/global-graph.json`; sus nodos incluyen el campo `repo`. Un vínculo de grafo no prueba por sí solo tráfico HTTP entre proyectos.

## Evidencia y límites

Los grafos locales reportan estructura intra-repositorio. El global combina nodos de los tres repositorios, pero Graphify no sustituye verificar consumidores HTTP. Rutas frontend cotejadas con mappings Java; los documentos de API pueden estar desactualizados. No se infiere que todas las pantallas visibles estén habilitadas o desplegadas. Para correspondencias y discrepancias, ver [API-INTEGRATIONS.md](API-INTEGRATIONS.md).

## Mapa de esta documentación

- [GLOBAL-ARCHITECTURE.md](GLOBAL-ARCHITECTURE.md): componentes, límites y despliegue observable.
- [API-INTEGRATIONS.md](API-INTEGRATIONS.md): rutas con consumidor verificado y huecos de contrato.
- [AUTHENTICATION-FLOW.md](AUTHENTICATION-FLOW.md): JWT, registro y almacenamiento en cada cliente.
- [USER-FLOWS.md](USER-FLOWS.md): journeys de cliente/cooperativa.
- [DATA-FLOW.md](DATA-FLOW.md): requests y persistencia.
- [CROSS-REPOSITORY-DEPENDENCIES.md](CROSS-REPOSITORY-DEPENDENCIES.md): dependencias comprobadas e inferidas.
- [ARCHITECTURAL-DECISIONS.md](ARCHITECTURAL-DECISIONS.md): decisiones identificadas en código/configuración.
- [AI-INDEX.md](AI-INDEX.md): rutas de investigación por tema.
