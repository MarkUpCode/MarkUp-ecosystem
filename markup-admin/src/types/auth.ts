export type AdminRole = "ADMIN";

export interface AuthUser {
  id: number;
  email: string;
  role: string;
  name?: string;
  status?: string;
  avatarUrl?: string;
  cooperativaId?: number | null;
}

export function isAdminRole(role?: string | null) {
  return role?.toUpperCase() === "ADMIN";
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  accessToken: string;
  user: AuthUser;
}

export interface AuthState {
  user: AuthUser | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
}
