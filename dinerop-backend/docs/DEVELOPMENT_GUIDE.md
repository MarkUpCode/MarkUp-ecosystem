# DEVELOPMENT_GUIDE

## Requisitos observados

Java 17 y Maven (wrapper incluido: `mvnw`/`mvnw.cmd`). La base configurada para runtime es PostgreSQL; H2 se incluye en pruebas. Docker está descrito por `Dockerfile` y `docker-compose.yml`. Revisa perfiles/configuración antes de iniciar. No copies secretos al repositorio o a documentación.

## Configuración

`src/main/resources/application.yaml` indica el nombre `dinerop-backend` y perfil `dev`. La configuración específica de producción está en `application-prod.yaml`. Valores de conexión/proveedor deben inyectarse desde el entorno según la configuración efectiva. No incluyas valores sensibles en logs, commits o esta guía.

## Comandos habituales

```powershell
# Compilar
./mvnw.cmd -DskipTests package

# Ejecutar pruebas existentes
./mvnw.cmd test

# Ejecutar aplicación con el wrapper
./mvnw.cmd spring-boot:run
```

Estos comandos se documentan como operaciones de desarrollo; esta tarea no ejecutó tests ni compilación. Consulta `pom.xml` para plugins y dependencias.

## Orientación de cambios

1. Busca el endpoint en el controlador y sus DTOs.
2. Sigue las dependencias al servicio/caso de uso, repositorio, entidad y enums. Graphify (`graphify-out/GRAPH_REPORT.md`, `graph.json`) acelera navegación; valida relaciones contra código.
3. Para autorización, revisa simultáneamente `auth/config/SecurityConfig.java`, filtro JWT y `@PreAuthorize`.
4. Para persistencia, compara anotaciones JPA con `schema.sql`; el snapshot SQL no contiene todas las tablas declaradas por entidades.
5. Para integraciones, utiliza la abstracción existente (`NotificationService`, `CreditServiceClient`) y protege secretos/PII.
6. Actualiza documentación afectada y el grafo tras cambios de código mediante la herramienta Graphify disponible en el entorno del proyecto. No se encontró ejecutable Graphify expuesto en esta sesión.

## Pruebas presentes

Hay pruebas en `src/test/java`, incluidas seguridad de actividad, flujo OTP y consulta de crédito. Esta guía no prescribe cobertura ni afirma que la suite pase; ejecútala antes de integrar cambios cuando el contexto lo requiera.

## Diagnóstico seguro

Ante 401/403, verifica token/rol y ambas capas de permisos. Ante errores SQL, coteja esquema activo y entidades, en particular tablas no incluidas en `schema.sql`. Nunca imprimas contraseñas, JWT, OTP, tokens de reset ni credenciales de proveedor.
