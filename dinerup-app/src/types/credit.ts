// src/types/credit.ts
import { CreditEstado } from "./creditEstado";

/** Base común */
interface BaseCreditRequest {
  solicitudId: number;
  estado: CreditEstado;
  tipo: string;
  fechaSolicitud: string;
}

/**
 * CLIENTE
 * GET /api/credits/me
 */
export interface CreditRequest extends BaseCreditRequest {
  monto: number;
  cantidadSolicitudesEnviadas: number;
  motivosRechazo?: string[];
  garanteEnRevision?: boolean;
  mensajeGarante?: string | null;
  requiereComparecenciaGarante?: boolean;
}

/**
 * COOPERATIVA
 * GET /api/credits/cooperative/me/requests
 */
export interface CooperativeCreditRequest extends BaseCreditRequest {
  clientId?: number;
  montoSolicitado: number;
  nombreSolicitante?: string;
  cedulaSolicitante?: string;
}

export interface CooperativeOfferDefaults {
  monto: number;
  plazoMeses: number;
  tasaAnual: number;
}

export interface CreditRequirement {
  title: string;
  description?: string;
  category?: string;
  mandatory?: boolean;
  displayOrder?: number;
}

/**
 * CLIENTE
 * GET /api/credits/me/{solicitudId}/pre-approved
 */
export interface CreditRequestCooperative {
  cooperativaId: number;
  nombreCooperativa: string;
  estado: CreditEstado | "ACEPTADA" | "ENVIADA";
  fechaActualizacion: string;
  monto: number;
  plazoMeses: number;
  tipoCredito: string;
  tasaAnual: number;
  cuotaMensual: number;
  totalPagar: number;
  interesTotal: number;
  direccion?: string;
  mapsUrl?: string;
  requisitos?: CreditRequirement[];
  motivosRechazo?: string[];
}
