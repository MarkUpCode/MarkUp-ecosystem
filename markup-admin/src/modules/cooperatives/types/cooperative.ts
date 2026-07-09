export interface Cooperative {

    id: number;

    legacyId: number | null;

    nombre: string;

    ciudad: string;

    provincia: string;

    direccion: string;

    telefono: string;

    paginaWeb: string;

    logoUrl: string;

    calificacion: number;

    montoMaximoCredito: number;

}

export interface CooperativeListItem {

    id: number;

    nombre: string;

    ciudad: string;

    provincia: string;

    telefono: string;

    calificacion: number;

    montoMaximoCredito: number;

}

export interface CooperativesPageResponse {

    content: CooperativeListItem[];

    page: number;

    size: number;

    totalElements: number;

    totalPages: number;

    first: boolean;

    last: boolean;

}

export interface CreateCooperativeRequest {

    nombre: string;

    ciudad: string;

    provincia: string;

    direccion: string;

    telefono: string;

    paginaWeb: string;

    logoUrl: string;

    calificacion: number;

    montoMaximoCredito: number;

}

export interface UpdateCooperativeRequest
    extends CreateCooperativeRequest {}

export interface CooperativeFormData
  extends CreateCooperativeRequest {}