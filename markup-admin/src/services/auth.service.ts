import { api } from "./axios";
import type { LoginRequest, LoginResponse } from "@/types/auth";

export async function login(payload: LoginRequest): Promise<LoginResponse> {
  const { data } = await api.post<LoginResponse>("/api/auth/login", payload);
  return data;
}
