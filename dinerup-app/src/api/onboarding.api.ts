import { httpClient } from "./httpClient";

export interface DireccionData {
  provincia: string;
  canton: string;
  barrio: string;
  callePrincipal: string;
  numero: string;
  referenciaUbicacion: string;
  tipoVivienda: "PROPIA" | "ALQUILADA" | "FAMILIAR";
}

export interface ActividadEconomicaData {
  nombreNegocio: string;
  direccionNegocio: string;
  tiempoActividad: string;
  telefonoNegocio: string;
}

export interface IngresoEgresoData {
  ingresoMensual: number;
  egresoMensual: number;
}

export interface ReferenciaData {
  nombreCompleto: string;
  tipo: "PERSONAL" | "LABORAL" | "COMERCIAL";
  parentesco: string;
  telefono: string;
}

export interface SolicitanteData {
  nombres: string;
  apellidos: string;
  cedula: string;
  fechaNacimiento: string;
  estadoCivil: string;
  ocupacion: string;
  empresaTrabajo: string;
  telefono: string;
  email: string;
  tieneConyuge: boolean;
  direccion: DireccionData;
  actividadEconomica: ActividadEconomicaData;
  ingresoEgreso: IngresoEgresoData;
  referencias: ReferenciaData[];
}

export interface OnboardingPayload {
  destinoCredito: string;
  solicitante: SolicitanteData;
  conyuge?: SolicitanteData;
}

export interface OnboardingSubmitResponse {
  id: number;
  estado: string;
  destinoCredito: string;
  fechaCreacion: string;
}

export interface ClientePerfilUbicacion {
  provincia: string;
  ciudad: string;
  cedula: string;
  email: string;
}

export async function getClienteUbicacion(): Promise<ClientePerfilUbicacion | null> {
  try {
    return await httpClient<ClientePerfilUbicacion>(
      "/api/onboarding/cliente/mi-ubicacion",
      { method: "GET", auth: true },
    );
  } catch {
    return null;
  }
}

export async function submitOnboarding(
  payload: OnboardingPayload,
): Promise<OnboardingSubmitResponse> {
  return httpClient(`/api/onboarding/cliente/solicitante`, {
    method: "POST",
    body: payload,
    auth: true,
  });
}

export type FormularioClienteStatus = {
  formularioCompleto: boolean;
  estadoFormulario: "PENDIENTE" | "SOLICITADO" | "COMPLETO";
};

export function getFormularioClienteStatus(): Promise<FormularioClienteStatus> {
  return httpClient<FormularioClienteStatus>(
    "/api/onboarding/cliente/formulario-status",
    { method: "GET", auth: true },
  );
}

export interface GuaranteeOnboardingResponse {
  id: number;
  estado: string;
  destinoCredito: string;
  fechaCreacion: string;
}

export interface PreRegistrationData {
  firstName: string;
  lastName: string;
  identification: string;
  phone: string;
  email: string;
  province: string;
  city: string;
}

export async function getPreRegistrationData(): Promise<PreRegistrationData> {
  return httpClient<PreRegistrationData>(
    "/api/onboarding/cliente/pre-registration",
    {
      method: "GET",
      auth: true,
    },
  );
}

export async function submitGuaranteeOnboarding(
  payload: OnboardingPayload,
): Promise<GuaranteeOnboardingResponse> {
  return httpClient<GuaranteeOnboardingResponse>(
    `/api/onboarding/cliente/garante/completar`,
    {
      method: "POST",
      body: payload,
      auth: true,
    },
  );
}
