# Diseño: Consumo de POST /api/credits/me en NewCreditModal

**Fecha:** 2026-05-10  
**Estado:** Aprobado

---

## Contexto

El endpoint `POST /api/credits/me` fue completado en el backend para crear y distribuir solicitudes de crédito a cooperativas elegibles de la ciudad. El modal `NewCreditModal` ya capturaba los campos necesarios (province, city, monto, creditType) pero no los enviaba al backend. La función `createCreditRequest` del API layer tampoco incluía esos campos ni retornaba el `requestId` de la respuesta.

---

## Objetivo

Conectar `NewCreditModal` al endpoint `POST /api/credits/me` enviando todos los campos requeridos, manejando errores específicos del backend con mensajes amigables, y sin romper ningún otro flujo existente.

---

## Enfoque elegido: Lógica API dentro del modal

El modal llama directamente a `createCreditRequest()` desde su `handleSubmit`. El prop `onSubmit` del padre pasa a ser un callback de éxito simple (`() => void`). Esto evita ensanchar la interfaz del prop y encapsula toda la lógica del formulario en un solo componente.

---

## Cambios por archivo

### 1. `src/api/creditRequests.api.ts`

**Payload extendido:**
```ts
interface CreateCreditRequestPayload {
  monto: number;
  type: "CREDITO" | "INVERSION";
  creditType?: string | null;
  province: string;
  city: string;
  plazoMeses?: number;
}
```

**Tipo de retorno actualizado:**
```ts
interface CreateCreditRequestResponse {
  requestId: number;
  message: string;
}
// createCreditRequest retorna Promise<CreateCreditRequestResponse> (antes: Promise<void>)
```

Backwards-compatible: el único consumidor actual (`DashboardClient`) no usa el valor de retorno.

---

### 2. `src/components/credit/NewCreditModal.tsx`

**Prop `onSubmit` simplificada:**
```ts
// Antes
onSubmit: (data: { amount: number; type: string }) => void
// Después
onSubmit: () => void
```

**Estado nuevo:**
| Variable | Tipo | Uso |
|---|---|---|
| `plazoMeses` | `string` | Nuevo campo de plazo en meses |
| `isLoading` | `boolean` | Deshabilita el botón durante el envío |
| `apiError` | `string \| null` | Muestra errores del backend en el modal |

**Nuevo campo en formulario:** input numérico de plazo en meses (opcional), ubicado después del tipo de crédito. Validación: si se ingresa, debe estar entre 1 y 360.

**Validaciones agregadas:**
- `province` requerida
- `city` requerida
- `plazoMeses` entre 1 y 360 si se ingresa (opcional)

**Flujo de `handleSubmit`:**
1. Valida todos los campos del formulario
2. Llama `createCreditRequest({ monto, type: "CREDITO", creditType, province, city, plazoMeses })`
3. En éxito: resetea estado, llama `onSubmit()`, cierra modal
4. En error: mapea código de error a mensaje amigable, muestra en `apiError`

**Mapeo de errores del backend:**
| Código | Mensaje en UI |
|---|---|
| `EXISTING_ACTIVE_REQUEST` | "Ya tienes una solicitud activa. Espera a que se procese antes de crear una nueva." |
| `CREDIT_TYPE_REQUIRED_FOR_CREDITO` | "Debes seleccionar el tipo de crédito." |
| `CREDIT_TYPE_NOT_ALLOWED_FOR_INVERSION` | "Para inversión no aplica tipo de crédito." |
| `INVALID_PLAZO_MESES` | "El plazo debe estar entre 1 y 360 meses." |
| (genérico) | "No se pudo enviar la solicitud. Intenta nuevamente." |

---

### 3. `src/pages/DashboardClient.tsx`

**Handler simplificado:**
```ts
// Antes: async, recibía data, llamaba createCreditRequest, manejaba error
const handleCreditSubmit = async (data: { amount: number; type: string }) => { ... }

// Después: callback de éxito puro
const handleCreditSubmit = () => {
  setCreditSuccess(true);
  setTimeout(() => setCreditSuccess(false), 5000);
  void loadData();
};
```

El import de `createCreditRequest` se elimina de `DashboardClient` si no se usa en otro lugar.  
El sitio de uso del modal (`<NewCreditModal onSubmit={handleCreditSubmit} ... />`) no cambia visualmente.

---

## Pendiente de verificación con backend

Los valores actuales del selector `creditType` en el modal son `PERSONAL`, `BUSINESS`, `AUTO`, `HOME`. El spec del backend muestra `CONSUMO` como ejemplo, lo que sugiere posible discrepancia. La implementación usará los valores actuales del modal — **requiere confirmación con el equipo de backend antes de salir a producción.** El array `creditTypes` está centralizado en el mismo archivo del modal para facilitar el cambio.

---

## Campos que NO cambian

| Elemento | Estado |
|---|---|
| URL del endpoint (`POST /api/credits/me`) | Sin cambio |
| Header de autenticación | Sin cambio — `httpClient` lo maneja automáticamente |
| Endpoints subsiguientes (GET pre-approved, PUT accept) | Sin cambio |
| Endpoint público (`/api/credits/public-request`) | Sin cambio |
| Todos los demás componentes | Sin cambio |

---

## Casos cubiertos

1. Happy path: monto + province + city + creditType → response 200 con requestId
2. Solicitud duplicada → mensaje `EXISTING_ACTIVE_REQUEST`
3. Sin tipo de crédito → mensaje `CREDIT_TYPE_REQUIRED_FOR_CREDITO`
4. Ciudad sin cooperativas → response 200, no es error de front
5. Plazo fuera de rango → mensaje `INVALID_PLAZO_MESES`
