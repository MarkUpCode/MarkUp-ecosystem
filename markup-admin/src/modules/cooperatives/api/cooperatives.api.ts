import { api } from "@/services/axios";

import type {
  CooperativesPageResponse,
  Cooperative,
  CreateCooperativeRequest,
  UpdateCooperativeRequest,
} from "../types/cooperative";

/**
 * Obtener cooperativas
 */
export async function getCooperatives(
  page = 0,
  size = 10,
  search = "",
  city = "",
  province = ""
): Promise<CooperativesPageResponse> {

  const { data } = await api.get<CooperativesPageResponse>(
    "/api/admin/cooperatives",
    {
      params: {
        page,
        size,
        search,
        city,
        province,
      },
    }
  );

  return data;
}

/**
 * Obtener cooperativa
 */
export async function getCooperativeById(
  id: number
): Promise<Cooperative> {

  const { data } = await api.get<Cooperative>(
    `/api/admin/cooperatives/${id}`
  );

  return data;
}

/**
 * Crear cooperativa
 */
export async function createCooperative(
  payload: CreateCooperativeRequest
): Promise<Cooperative> {

  const { data } = await api.post<Cooperative>(
    "/api/admin/cooperatives",
    payload
  );

  return data;
}

/**
 * Actualizar cooperativa
 */
export async function updateCooperative(
  id: number,
  payload: UpdateCooperativeRequest
): Promise<Cooperative> {

  const { data } = await api.put<Cooperative>(
    `/api/admin/cooperatives/${id}`,
    payload
  );

  return data;
}

/**
 * Eliminar cooperativa
 */
export async function deleteCooperative(
  id: number
): Promise<void> {

  await api.delete(
    `/api/admin/cooperatives/${id}`
  );

}