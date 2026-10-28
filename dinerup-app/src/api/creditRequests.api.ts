import { httpClient } from "./httpClient";
import type {
  CreditRequest,
  CooperativeCreditRequest,
  CooperativeOfferDefaults,
  CreditRequestCooperative,
} from "../types/credit";
import { CreditDecision } from "../types/creditDecision";
import type { CreditRequirement } from "../types/credit";

export const getMyCreditRequests = async (): Promise<CreditRequest[]> => {
  const data = await httpClient<CreditRequest | CreditRequest[] | null>(
    "/api/credits/me",
    { auth: true },
  );

  if (!data) return [];

  // Defensivo: backend puede devolver array (nuevo) o un solo objeto (legado).
  const requests = Array.isArray(data) ? data : [data];

  // Filtrar entradas vacías (cuando el backend devuelve un placeholder sin solicitudId)
  return requests
    .filter((item) => item && item.solicitudId != null)
    .map((item) => ({
      ...item,
      monto: item.monto ?? 0,
    }));
};

export const getMyCooperativeRequests = async (): Promise<
  CooperativeCreditRequest[]
> => {
  const data = await httpClient<CooperativeCreditRequest[]>(
    "/api/credits/cooperative/me/requests",
    {
      auth: true,
    },
  );

  return data ?? [];
};

export const decideCreditRequest = async (
  solicitudId: number,
  decision: CreditDecision,
  offer?: { tasaAnual: number; plazoMeses: number },
  requisitos?: CreditRequirement[],
): Promise<void> => {
  await httpClient<void>(
    `/api/credits/cooperative/me/requests/${solicitudId}/decision`,
    {
      method: "PUT",
      auth: true,
      body: { decision, ...offer, requisitos },
    },
  );
};

export const getCooperativeOfferDefaults = async (
  solicitudId: number,
): Promise<CooperativeOfferDefaults> => {
  return httpClient<CooperativeOfferDefaults>(
    `/api/credits/cooperative/me/requests/${solicitudId}/offer-defaults`,
    { auth: true },
  );
};

export const getCreditRequestCooperatives = async (
  solicitudId: number,
): Promise<CreditRequestCooperative[]> => {
  const data = await httpClient<CreditRequestCooperative[]>(
    `/api/credits/me/${solicitudId}/pre-approved`,
    {
      auth: true,
    },
  );

  return data ?? [];
};

export const requestGuaranteeForCreditRequest = async (
  solicitudId: number,
  requisitos?: CreditRequirement[],
): Promise<void> => {
  await httpClient<void>(
    `/api/credits/cooperative/me/requests/${solicitudId}/solicitar-garante`,
    {
      method: "PUT",
      auth: true,
      body: requisitos,
    },
  );
};

export interface CreateCreditRequestPayload {
  monto: number;
  type: string;
  creditType?: string | null;
  plazoMeses?: number;
  city?: string;     // backend espera: city
  province?: string; // backend espera: province
}

export const createCreditRequest = async (
  payload: CreateCreditRequestPayload,
): Promise<void> => {
  await httpClient<void>("/api/credits/me", {
    method: "POST",
    auth: true,
    body: payload,
  });
};

export type GuaranteeDecision = "ACEPTAR" | "SOLICITAR_NUEVO";

export const decideGuaranteeForCreditRequest = async (
  solicitudId: number,
  decision: GuaranteeDecision,
): Promise<void> => {
  await httpClient<void>(
    `/api/credits/cooperative/me/requests/${solicitudId}/garante-decision`,
    {
      method: "PUT",
      auth: true,
      body: { decision },
    },
  );
};

export const acceptCreditCooperative = async (
  solicitudId: number,
  cooperativaId: number,
): Promise<void> => {
  await httpClient<void>(
    `/api/credits/me/${solicitudId}/cooperatives/${cooperativaId}/accept`,
    {
      method: "PUT",
      auth: true,
    },
  );
};
