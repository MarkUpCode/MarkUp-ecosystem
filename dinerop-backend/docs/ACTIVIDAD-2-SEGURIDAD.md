# Actividad 2 - Ingeniería de Seguridad de Software

## Ejecución

Desde la raíz:

```powershell
.\security-activity.ps1
```

El script ejecuta las seis pruebas de `SecurityActivityTest.java` y analiza las
dependencias del backend con Trivy. Cada comando conserva
su salida en `evidencias-seguridad/posterior/<fecha-hora>/` y un fallo detiene la
ejecución con código distinto de cero. El reporte de Trivy se guarda en JSON y
la salida del análisis en texto.

Requiere Java 17+, PowerShell y Trivy instalado. Como alternativa, el script usa
Docker para ejecutar `aquasec/trivy:0.57.1`. La primera ejecución puede descargar
la base de datos de Trivy. Para las pruebas se usa la configuración de base de
datos de pruebas incluida en el proyecto. No se hacen peticiones a producción.

## Casos automatizados

| ID | Objetivo | Preparación y datos | Comando | Resultado esperado | Resultado real | Estado |
|---|---|---|---|---|---|---|
| SEC-AUTH-001 | Autenticación válida | Usuario CLIENT sintético activo y autenticador simulado | `.\mvnw.cmd -Dtest=AuthServiceSecurityActivityTest#validCredentialsGenerateAccessToken test` | Devuelve token de acceso | Devuelve token sintético y verifica generación | Aprobado |
| SEC-AUTH-002 | Credenciales inválidas | Usuario CLIENT sintético y autenticador que rechaza | `.\mvnw.cmd -Dtest=AuthServiceSecurityActivityTest#invalidCredentialsAreRejected test` | Lanza rechazo y no genera JWT | `BadCredentialsException`; no genera JWT | Aprobado |
| SEC-AUTHZ-001 | Anónimo en endpoint privado | GET `/api/credits/me` sin autenticación | `.\mvnw.cmd -Dtest=SecurityActivityTest#anonymousUserCannotAccessPrivateCreditsEndpoint test` | HTTP 401 | HTTP 401 | Aprobado |
| SEC-AUTHZ-002 | Aislamiento entre clientes | Consulta sintética con clientId 22 | `.\mvnw.cmd -Dtest=ClientCreditQuerySecurityTest test` | Solo consulta 22, nunca 99 | Verifica repositorio con 22 y ausencia de 99 | Aprobado |
| SEC-AUTHZ-003 | Operación COOPERATIVE/ADMIN | Usuario CLIENT sintético | `.\mvnw.cmd -Dtest=SecurityActivityTest#clientCannotExecuteCooperativeOperation+clientCannotExecuteAdminOperation test` | HTTP 403 | HTTP 403 en ambos endpoints | Aprobado |
| SEC-INPUT-001 | Entradas inválidas | Email inválido/campos requeridos vacíos y rol ROOT | `.\mvnw.cmd -Dtest=SecurityActivityTest#invalidRegistrationPayloadIsRejected+unsupportedRoleIsRejectedByBackend test` | HTTP 400 | HTTP 400 en ambos casos | Aprobado |
| SEC-ROLE-001 | CLIENT no crea ADMIN | Usuario CLIENT y payload ADMIN | `.\mvnw.cmd -Dtest=SecurityActivityTest#clientCannotCreateAdminThroughInternalRegistration test` | HTTP 403 y no invoca servicio | HTTP 403 | Aprobado |

## Última ejecución registrada

Ejecución: `evidencias-seguridad/posterior/20261022-052848/`

- `SecurityActivityTest`: 6 pruebas ejecutadas, 0 fallos, 0 errores.
- Trivy: ejecutado mediante Docker porque no estaba instalado localmente.
- Resultado SCA: fallido de forma correcta; se detectó `CVE-2026-42198`,
  severidad `HIGH`, en `org.postgresql:postgresql` versión `42.7.3`.
- Código de salida del script: `1`, porque el umbral configurado falla ante
  vulnerabilidades `HIGH` o `CRITICAL` no corregidas.
- Reportes: `trivy-report.json`, `trivy-report.txt` y `trivy.log` dentro de la
  carpeta de la ejecución.

La vulnerabilidad no se declara corregida en esta actividad: requiere actualizar
el controlador PostgreSQL a una versión que corrija el CVE, comprobar
compatibilidad con el backend y volver a ejecutar el script. La actualización
no se hizo automáticamente para evitar cambiar dependencias sin validar su
compatibilidad.

## Correcciones

- Se eliminaron impresiones de `jwt.secret`, JWT completos y email extraído del
  filtro. También se eliminaron de logs los tokens de activación, OTP, reset y
  enlaces que los contienen.
- `/api/internal/auth/pre-register` requiere `ADMIN`; `PreRegisterRequest`
  conserva validación `@Valid` y `Role` enum, por lo que roles no definidos
  reciben 400. El registro público continúa creando `CLIENT`.
- `/api/credits/me` dejó de ser público y exige `CLIENT`. La ruta pública
  explícita sigue siendo `/api/credits/public-request`.

## Análisis SCA con Trivy

El script ejecuta un análisis de filesystem del backend con vulnerabilidades
`HIGH` y `CRITICAL` no corregidas como umbral de fallo:

```text
trivy fs --scanners vuln --format json --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed dinerop-backend
```

El resultado real de cada ejecución debe tomarse de `trivy.log`,
`trivy-report.txt` y `trivy-report.json`. Si Trivy no está instalado, Docker no
está disponible, la base de datos no puede descargarse o el análisis encuentra
vulnerabilidades, el script falla y conserva el diagnóstico; no se declara un
análisis aprobado sin evidencia.
