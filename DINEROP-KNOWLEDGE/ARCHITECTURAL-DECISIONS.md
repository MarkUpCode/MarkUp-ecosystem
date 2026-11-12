# Decisiones arquitectónicas identificadas

Este documento registra decisiones inferidas de código/configuración existente; no afirma que haya ADRs aprobados. Cada elemento distingue evidencia de interpretación.

| Decisión observada | Evidencia | Consecuencia/alcance |
|---|---|---|
| Backend como monolito modular Spring Boot | `docs/ARCHITECTURE.md`; servicios y controladores co-localizados; onboarding llama `CreditService` directamente. | Despliegue y límites de proceso son backend único según código. Un cliente HTTP interno también existe, pero no convierte el sistema en microservicios. |
| API HTTP stateless con JWT | `SecurityConfig`: `SessionCreationPolicy.STATELESS`; filtro JWT. | Clientes deben enviar Bearer en operaciones protegidas; no hay sesión web del backend. |
| Separar acceso web y móvil | Repositorios autónomos, frameworks distintos, clientes HTTP propios. | Contratos compartidos por HTTP, sin librería de UI/modelos compartida identificada. |
| Persistencia encapsulada por repositorios JPA | Repositorios y configuración datasource. | UI no acopla directamente a esquema PostgreSQL. |
| Auth token storage específico de plataforma | Flutter secure storage; web localStorage (`authStorage.ts`). | Diferente postura de almacenamiento/amenaza entre canales; no implica refresh token. |
| Cliente web construido como SPA | Vite, `BrowserRouter`, reglas de fallback en deploy. | No hay evidencia de SSR/App Router; contradice descripción inicial Next.js 15. |
| Configuración de API externa por ambiente | `VITE_API_BASE_URL`; `DINEROP_API_BASE_URL` y fallback móvil. | El despliegue puede apuntar distinto por configuración; confirmar valores reales fuera de código. |
| Errores y DTOs específicos por cliente | `ApiError` web y `AppException`/parsers móvil. | No hay contrato común de errores plenamente tipado identificado. |

## Decisiones que siguen abiertas/no demostradas

- No se encontró ADR formal que justifique stack, modularización o estrategia de auth.
- No se confirmó versionado de endpoints, idempotencia, retries ni política de compatibilidad.
- Presencia de Supabase en `package.json` no prueba arquitectura de datos Supabase; no se detectó uso en la aplicación.
- La documentación backend contiene discrepancias con el código. Resolver contrato con controladores/OpenAPI antes de generar SDKs o automatizar clientes.
