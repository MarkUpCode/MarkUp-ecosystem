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
