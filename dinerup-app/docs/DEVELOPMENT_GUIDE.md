# Guía de desarrollo

## Requisitos y configuración

El proyecto es Vite + React 18 + TypeScript, no Next.js 15/React 19. Instala dependencias con `npm install`. Copia `.env.example` a `.env` y configura `VITE_API_BASE_URL` para apuntar al backend. La configuración falla al cargar si la variable está ausente. No se debe incluir una URL de producción ni credenciales privadas en documentación.

## Comandos existentes

```bash
npm run dev       # servidor Vite
npm run build     # compilación a dist/
npm run preview   # servir build local
npm run lint      # ESLint
npm run typecheck # TypeScript sin emitir
```

Estos comandos se listan como guía; no se ejecutaron como parte de este análisis.

## Orientación de cambios

- Rutas y guards: `src/App.tsx`.
- Montaje/proveedores: `src/main.tsx`.
- Endpoint/configuración/transporte: `src/api/`; centralizar nuevas llamadas en servicios por dominio y usar `httpClient`.
- Contratos de crédito/cooperativa/onboarding: `src/types/` y tipos de API relacionados.
- Estado de sesión: `src/context/` y `src/api/auth/`.
- Páginas: `src/pages/`; componentes de UI agrupados bajo `src/components/`.
- Datos estáticos: `src/data/`; estilos globales y configuración Tailwind en raíz.

Para añadir una vista, registrar el path en `App.tsx` y asignarle el guard adecuado según el patrón presente. Para añadir llamada autenticada, definir el método/ruta en servicio de dominio y explicitar `auth` cuando sea relevante; revisar las listas de rutas públicas de `httpClient`.

## Graphify

El informe existente se encuentra en `graphify-out/GRAPH_REPORT.md`. El propio informe indica que se puede regenerar/actualizar con `graphify update .` y explorar nodos aislados con `graphify query`; requiere tener Graphify disponible en el entorno. El análisis detectó cero ciclos de importación y reporta extracción totalmente extraída. Asegúrate de regenerarlo después de cambios que alteren las relaciones del código.

## Notas de arquitectura para quien mantenga el proyecto

- Los nombres de tipos pueden representar un contrato distinto del backend: cotejar los payloads reales al modificar integración.
- El nombre `Step4Review` es peculiar junto a `Step4Economic`; no cambiarlo solo por la numeración sin revisar imports.
- `@supabase/supabase-js` aparece en dependencias pero su uso no se encontró en `src`.
- `src/utils/mockAPI.ts` es una implementación simulada local, distinta del cliente HTTP actual.
- No existe ruta catch-all visible en `App.tsx`; los redirects SPA de hosting solo hacen que `index.html` cargue para rutas profundas.

## Referencias

- [package.json](../package.json), [.env.example](../.env.example), [vite.config.ts](../vite.config.ts)
- [graphify-out/GRAPH_REPORT.md](../graphify-out/GRAPH_REPORT.md), [src/api/httpClient.ts](../src/api/httpClient.ts), [src/App.tsx](../src/App.tsx)
