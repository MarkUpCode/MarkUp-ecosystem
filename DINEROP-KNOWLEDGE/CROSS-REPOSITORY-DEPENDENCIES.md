# Dependencias entre repositorios

## Matriz de evidencia

| Relación | Evidencia | Estado |
|---|---|---|
| Móvil → backend | Rutas construidas en `lib/features/*/data/`, `ApiClient`, coincidencias de mappings Java. | Comprobada para rutas de [API-INTEGRATIONS.md](API-INTEGRATIONS.md). |
| Web → backend | `src/api/*`, `httpClient.ts`, coincidencias con controladores. | Comprobada salvo rutas señaladas sin mapping. |
| Móvil ↔ web | No hay import, SDK o llamada directa identificada entre repositorios. | No identificada; no prueba ausencia de integraciones externas. |
| Backend → PostgreSQL | Configuración Spring/JPA y repositorios. | Comprobada por configuración/código. |
| Clientes → PostgreSQL | No hay cliente DB en flujos inspeccionados. | No encontrado; las rutas de negocio van por API. |
| Backend → correo/push | Configuración Resend/Firebase y servicios de notificación. | Comprobada en backend; uso de cada evento requiere rastrear servicio. |

## Acoplamiento por contrato

Los clientes dependen de rutas, métodos, nombres de campos, enums y estados del backend de manera implícita mediante sus modelos/serializadores. No se encontró generación compartida de SDK/contrato entre repositorios. Cambios coordinados de API pueden requerir actualización separada de los dos clientes. Consultar DTO Java junto al modelo Dart/TypeScript; las tablas/docs por sí solas pueden no reflejar código vigente.

## Grafo global

`DINEROP-KNOWLEDGE/global-graph.json` contiene nodos con `repo` (`dinerop-backend`, `app_movil_dinerop`, `dinerup-app`) y relaciones Graphify. Use el grafo para saltar a símbolos locales. Las llamadas remotas se evidencian mejor en strings de ruta y controladores; una arista inferida entre nodos homónimos no debe interpretarse como dependencia runtime.

## Huecos

No se pudo comprobar consumidor de rutas internas/admin ni configuración actual de producción; no se conoce versionado/negociación formal de API ni pipeline coordinado de releases. El host de backend documentado y fallback móvil no coinciden; averiguar entorno desplegado antes de sacar conclusiones operativas.
