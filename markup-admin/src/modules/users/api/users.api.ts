import { api } from "@/services/axios";
import type {
  UsersPageResponse,
  InviteUserRequest,
  ChangeStatusRequest,
  UserListItem,
} from "../types/user";

/**
 * Obtener usuarios
 */
export async function getUsers(
  page = 0,
  size = 10
): Promise<UsersPageResponse> {
  const { data } = await api.get<UsersPageResponse>(
    `/api/admin/users?page=${page}&size=${size}`
  );

  return data;
}

/**
 * Obtener usuario por id
 */
export async function getUserById(
  id: number
): Promise<UserListItem> {
  const { data } = await api.get<UserListItem>(
    `/api/admin/users/${id}`
  );

  return data;
}

/**
 * Invitar usuario
 */
export async function inviteUser(
  payload: InviteUserRequest
): Promise<UserListItem> {
  const { data } = await api.post<UserListItem>(
    "/api/admin/users",
    payload
  );

  return data;
}

/**
 * Cambiar estado
 */
export async function changeUserStatus(
  id: number,
  payload: ChangeStatusRequest
): Promise<UserListItem> {
  const { data } = await api.patch<UserListItem>(
    `/api/admin/users/${id}/status`,
    payload
  );

  return data;
}