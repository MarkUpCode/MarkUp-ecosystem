# Lógica de negocio observada

Esta descripción refleja las reglas expresadas en el cliente. La validación y decisión final del backend no se pueden inferir desde aquí.

## Crédito

Un cliente puede crear solicitud autenticada (`POST /api/credits/me`) o enviar una solicitud pública desde `PublicCreditRequestModal` (`POST /api/credits/public-request`). El dashboard cliente consulta sus solicitudes. Una solicitud puede mostrar propuestas preaprobadas de cooperativas; el cliente acepta una seleccionada con un endpoint de aceptación. El modelo de oferta contiene tasa anual, plazo, cuota, monto y requisitos.

La cooperativa ve su bandeja, filtra por estado y texto, consulta valores predeterminados y expediente, preaprueba o rechaza solicitudes, y puede solicitar garante. Hay endpoints para timeline y resolución de decisión de garante (`ACEPTAR` / `SOLICITAR_NUEVO`). En la lista cliente el servicio normaliza respuesta singleton o arreglo y filtra registros sin `solicitudId`.

## Estados

Los estados de crédito están centralizados en `src/types/creditEstado.ts`; las decisiones de cooperativa en `src/types/creditDecision.ts`. La UI compara estados como `ENVIADA`, `PRE_APROBADA`, `RECHAZADA` y `SOLICITANDO_GARANTE`. No se debe asumir que esos valores cubren el conjunto completo del backend.

## Onboarding

El formulario de solicitante divide identidad/datos personales/dirección/economía y posible cónyuge; la página mantiene datos y los envía como `OnboardingPayload`. Se consulta estado y preregistro para preparar el formulario. El modal de garante presenta flujo separado y envía a `/api/onboarding/cliente/garante/completar`. La cooperativa consulta detalle de onboarding para evaluar personas, datos económicos y referencias.

## Validación y territorio

La validación del login usa Zod para email y longitud mínima de contraseña. El formulario público de crédito incorpora validaciones locales, catálogo provincial/cantonal/parroquial y aceptación de términos según el estado del componente. `src/data/ecuadorProvinces.ts` es un catálogo local. La función de validación de cédula ecuatoriana vive en el código UI correspondiente; revisar esa implementación antes de documentar reglas más precisas.

## Recuperación de errores

`httpClient` traduce respuestas no exitosas a `ApiError`, preservando estado y datos. `getErrorMessage` selecciona mensaje de excepción o fallback. Los componentes muestran mensajes y estados de carga; no hay política de reintentos/caché global observada.

## Referencias

- [src/api/creditRequests.api.ts](../src/api/creditRequests.api.ts), [src/types/credit.ts](../src/types/credit.ts), [src/types/creditEstado.ts](../src/types/creditEstado.ts), [src/types/creditDecision.ts](../src/types/creditDecision.ts)
- [src/pages/OnboardingPage.tsx](../src/pages/OnboardingPage.tsx), [src/components/onboarding/GuaranteeOnboardingModal.tsx](../src/components/onboarding/GuaranteeOnboardingModal.tsx), [src/components/credit/PublicCreditRequestModal.tsx](../src/components/credit/PublicCreditRequestModal.tsx)
