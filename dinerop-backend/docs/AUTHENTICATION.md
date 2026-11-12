# AUTHENTICATION

## Mecanismo

`auth/config/SecurityConfig.java` configura una cadena sin estado, CSRF desactivado, CORS y filtro `JwtAuthenticationFilter` antes del filtro de usuario/contraseña. `auth/service/JwtService.java` emite/valida JWT; `CustomUserDetailsService` carga usuarios. El proveedor de autenticación utiliza `PasswordEncoder` (`auth/util/PasswordEncoderConfig.java`). No documentar formato/valor de claves ni secretos.

```mermaid
sequenceDiagram
  participant C as Cliente
  participant AC as AuthController
  participant AS as AuthService
  participant DB as Repositorios
  participant M as Servicio de correo
  C->>AC: registro/login/OTP
  AC->>AS: operación de autenticación
  AS->>DB: verificar o persistir usuario/OTP
  opt activación o código
    AS->>M: enviar mensaje
  end
  AS-->>C: respuesta; login puede emitir JWT
  C->>AC: llamada protegida + Bearer JWT
  Note over AC: JwtAuthenticationFilter valida identidad y roles
```

## Registro y recuperación

`AuthController` expone registro, activación, OTP, definición de contraseña y recuperación. El `AuthService` coordina `UserRepository`, pre-registro, OTP y tokens. El flujo exacto y caducidad dependen del servicio y configuración vigente; no se especifican aquí valores temporales sin verificación completa.

## Autorización

- Regla general en `SecurityConfig`: acceso autenticado salvo rutas públicas enumeradas.
- `@PreAuthorize` de controladores añade roles: ADMIN en administración, CLIENT en operaciones del cliente, COOPERATIVE en operaciones de cooperativa.
- Identidades/roles se modelan por `auth/entity/User.java`, `Role.java`; revisar cómo se transforma `Role` a `GrantedAuthority` en `CustomUserDetailsService` antes de cambiar nombres o prefijos.
- El endpoint interno de auth está bajo `/api/internal/auth/**`, patrón que no aparece en las rutas públicas. Se exige autenticación general; el controlador también requiere ADMIN. «Internal» no demuestra mTLS ni autenticación de servicio.

## Límites de certeza

La autenticación efectiva se compone de cadena HTTP, filtro JWT, método de carga del usuario y `@PreAuthorize`; una ruta sin anotación de rol puede permitir cualquier usuario autenticado. Revisar `SecurityConfig`, filtros y controlador antes de declarar un permiso. Las listas CORS predeterminadas no son un inventario de todos los entornos.
